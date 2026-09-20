import 'dart:async';

import '../../data/pizza_order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pizza_bloc_events.dart';
import 'pizza_bloc_states.dart';

class PizzaBloc extends Bloc<PizzaEvents, PizzaState> {
  final Map<int, int> prices;
  final FirebaseAuth? _auth;
  final Map<int, Timer> _orderTimers = {};
  int _nextOrderId = 1;

  PizzaBloc({
    required this.prices,
    FirebaseAuth? auth,
    Duration demoStageDuration = const Duration(seconds: 15),
  })  : _auth = auth,
        super(PizzaState()) {
    on<AddPizzaEvent>((event, emit) {
      if (!prices.containsKey(event.pizzaId)) return;

      final quantities = Map<int, int>.from(state.quantities);
      final quantity = quantities[event.pizzaId] ?? 0;

      quantities[event.pizzaId] = quantity + 1;

      emit(state.copyWith(
        status: PizzaStatusEnum.updated,
        quantities: quantities,
        totalPrice: calculateTotal(quantities),
      ));
    });

    on<MinusPizzaEvent>((event, emit) {
      final quantity = state.quantities[event.pizzaId] ?? 0;

      if (quantity == 0) return;

      final quantities = Map<int, int>.from(state.quantities);

      if (quantity == 1) {
        quantities.remove(event.pizzaId);
      } else {
        quantities[event.pizzaId] = quantity - 1;
      }

      emit(state.copyWith(
        status: PizzaStatusEnum.updated,
        quantities: quantities,
        totalPrice: calculateTotal(quantities),
      ));
    });

    on<ClearBasketEvent>((event, emit) {
      emit(state.copyWith(
        status: PizzaStatusEnum.updated,
        quantities: {},
        totalPrice: 0,
      ));
    });

    on<PlaceOrderEvent>((event, emit) {
      if (state.totalQuantity == 0) return;

      final order = PizzaOrder(
        id: _nextOrderId++,
        quantities: state.quantities,
        totalPrice: state.totalPrice,
        placedAt: DateTime.now(),
      );

      emit(state.copyWith(
        quantities: {},
        totalPrice: 0,
        orders: List.unmodifiable([order, ...state.orders]),
        status: PizzaStatusEnum.updated,
      ));

      _orderTimers[order.id] = Timer.periodic(demoStageDuration, (_) {
        add(AdvanceOrderEvent(order.id));
      });
    });

    on<DeleteOrderEvent>((event, emit) {
      _orderTimers.remove(event.orderId)?.cancel();
      emit(state.copyWith(
        orders: List.unmodifiable(
          state.orders.where((order) => order.id != event.orderId),
        ),
      ));
    });

    on<DeleteAllOrdersEvent>((event, emit) {
      for (final timer in _orderTimers.values) {
        timer.cancel();
      }
      _orderTimers.clear();
      emit(state.copyWith(orders: const []));
    });

    on<AdvanceOrderEvent>((event, emit) {
      final orders = state.orders.map((order) {
        if (order.id != event.orderId ||
            order.stage == OrderStage.delivered) {
          return order;
        }

        final updated = order.advance();

        if (updated.stage == OrderStage.delivered) {
          _orderTimers.remove(order.id)?.cancel();
        }

        return updated;
      }).toList();

      emit(state.copyWith(orders: List.unmodifiable(orders)));
    });

    on<ToggleLoginModeEvent>((event, emit) {
      if (state.isLoading) return;

      emit(state.copyWith(
        isLogin: !state.isLogin,
        loginStatus: LoginStatusEnum.initial,
        clearError: true,
      ));
    });

    on<SubmitLoginEvent>(_submitLogin);
    on<SignOutEvent>(_signOut);
  }

  String get userEmail =>
      (_auth ?? FirebaseAuth.instance).currentUser?.email ?? 'No email';

  int calculateTotal(Map<int, int> quantities) {
    int total = 0;

    for (final pizzaId in quantities.keys) {
      total += prices[pizzaId]! * quantities[pizzaId]!;
    }

    return total;
  }

  Future<void> _submitLogin(
    SubmitLoginEvent event,
    Emitter<PizzaState> emit,
  ) async {
    if (state.isLoading) return;

    final isLogin = state.isLogin;

    emit(state.copyWith(
      loginStatus: LoginStatusEnum.loading,
      clearError: true,
    ));

    try {
      final auth = _auth ?? FirebaseAuth.instance;

      if (isLogin) {
        await auth.signInWithEmailAndPassword(
          email: event.email.trim(),
          password: event.password,
        );
      } else {
        await auth.createUserWithEmailAndPassword(
          email: event.email.trim(),
          password: event.password,
        );
      }

      emit(state.copyWith(
        loginStatus: LoginStatusEnum.success,
        clearError: true,
      ));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        loginStatus: LoginStatusEnum.failure,
        error: _errorMessage(e.code),
      ));
    } catch (_) {
      emit(state.copyWith(
        loginStatus: LoginStatusEnum.failure,
        error: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<void> _signOut(
    SignOutEvent event,
    Emitter<PizzaState> emit,
  ) async {
    if (state.isLoading) return;

    emit(state.copyWith(
      loginStatus: LoginStatusEnum.loading,
      clearError: true,
    ));

    try {
      await (_auth ?? FirebaseAuth.instance).signOut();

      for (final timer in _orderTimers.values) {
        timer.cancel();
      }

      _orderTimers.clear();

      emit(state.copyWith(
        loginStatus: LoginStatusEnum.success,
        isLogin: true,
        orders: [],
        quantities: {},
        totalPrice: 0,
        clearError: true,
      ));
    } catch (_) {
      emit(state.copyWith(
        loginStatus: LoginStatusEnum.failure,
        error: 'Unable to sign out. Please try again.',
      ));
    }
  }

  @override
  Future<void> close() {
    for (final timer in _orderTimers.values) {
      timer.cancel();
    }

    return super.close();
  }

  String _errorMessage(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'network-request-failed':
        return 'Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'operation-not-allowed':
        return 'Email and password sign-in is currently unavailable.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}

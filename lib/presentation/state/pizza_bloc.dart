import 'package:flutter_bloc/flutter_bloc.dart';
import 'pizza_bloc_events.dart';
import 'pizza_bloc_states.dart';

class PizzaBloc extends Bloc<PizzaEvents, PizzaState> {
  final Map<int, int> prices;

  PizzaBloc({required this.prices}) : super(PizzaState()) {
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
      emit(PizzaState(status: PizzaStatusEnum.updated));
    });
  }

  int calculateTotal(Map<int, int> quantities) {
    int total = 0;
    for (final pizzaId in quantities.keys) {
      total += prices[pizzaId]! * quantities[pizzaId]!;
    }
    return total;
  }
}

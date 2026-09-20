enum PizzaStatusEnum { initial, updated }

enum LoginStatusEnum { initial, loading, success, failure }

class PizzaState {
  final PizzaStatusEnum status;
  final Map<int, int> quantities;
  final int totalPrice;

  final LoginStatusEnum loginStatus;
  final bool isLogin;
  final String? error;

  PizzaState({
    this.status = PizzaStatusEnum.initial,
    this.quantities = const {},
    this.totalPrice = 0,
    this.loginStatus = LoginStatusEnum.initial,
    this.isLogin = true,
    this.error,
  });

  bool get isLoading => loginStatus == LoginStatusEnum.loading;

  int get totalQuantity {
    int total = 0;

    for (int quantity in quantities.values) {
      total += quantity;
    }

    return total;
  }

  PizzaState copyWith({
    PizzaStatusEnum? status,
    Map<int, int>? quantities,
    int? totalPrice,
    LoginStatusEnum? loginStatus,
    bool? isLogin,
    String? error,
    bool clearError = false,
  }) {
    return PizzaState(
      status: status ?? this.status,
      quantities: quantities ?? this.quantities,
      totalPrice: totalPrice ?? this.totalPrice,
      loginStatus: loginStatus ?? this.loginStatus,
      isLogin: isLogin ?? this.isLogin,
      error: clearError ? null : error ?? this.error,
    );
  }
}
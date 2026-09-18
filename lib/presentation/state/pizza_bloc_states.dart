enum PizzaStatusEnum { initial, updated }

class PizzaState {
  final PizzaStatusEnum status;
  final Map<int, int> quantities;
  final int totalPrice;

  PizzaState({
    this.status = PizzaStatusEnum.initial,
    this.quantities = const {},
    this.totalPrice = 0,
  });

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
  }) {
    return PizzaState(
      status: status ?? this.status,
      quantities: quantities ?? this.quantities,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

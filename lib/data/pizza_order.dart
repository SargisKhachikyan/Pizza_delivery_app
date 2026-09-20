enum OrderStage {
  received('Order received', 'The restaurant has received your order.'),
  preparing(
      'Preparing your order', 'Your pizzas are being made in the kitchen.'),
  pickedUp('Courier picked up your order', 'Your pizzas are on their way.'),
  nearby('Courier is almost there', 'Get ready! Your order will arrive soon.'),
  delivered('Delivered', 'Your order is with you. Enjoy your pizza!');

  const OrderStage(this.title, this.description);
  final String title;
  final String description;
}

class PizzaOrder {
  PizzaOrder({
    required this.id,
    required Map<int, int> quantities,
    required this.totalPrice,
    required this.placedAt,
    this.stage = OrderStage.received,
  }) : quantities = Map.unmodifiable(quantities);

  final int id;
  final Map<int, int> quantities;
  final int totalPrice;
  final DateTime placedAt;
  final OrderStage stage;

  PizzaOrder advance() => PizzaOrder(
        id: id,
        quantities: quantities,
        totalPrice: totalPrice,
        placedAt: placedAt,
        stage: OrderStage
            .values[(stage.index + 1).clamp(0, OrderStage.values.length - 1)],
      );
}

class PizzaEvents {}

class AddPizzaEvent extends PizzaEvents {
  final int pizzaId;
  AddPizzaEvent(this.pizzaId);
}

class MinusPizzaEvent extends PizzaEvents {
  final int pizzaId;
  MinusPizzaEvent(this.pizzaId);
}

class ClearBasketEvent extends PizzaEvents {}

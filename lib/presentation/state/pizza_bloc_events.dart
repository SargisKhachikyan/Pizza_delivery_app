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

class ToggleLoginModeEvent extends PizzaEvents {}

class SubmitLoginEvent extends PizzaEvents {
  final String email;
  final String password;

  SubmitLoginEvent({
    required this.email,
    required this.password,
  });
}

class SignOutEvent extends PizzaEvents {}

class PlaceOrderEvent extends PizzaEvents {}

class AdvanceOrderEvent extends PizzaEvents {
  final int orderId;
  AdvanceOrderEvent(this.orderId);
}

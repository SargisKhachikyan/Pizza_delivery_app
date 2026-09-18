import 'package:decision_jar_project/presentation/state/pizza_bloc.dart';
import 'package:decision_jar_project/presentation/state/pizza_bloc_events.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Basket updates preserve old states and calculate mixed prices', () async {
    final bloc = PizzaBloc(prices: {1: 1099, 2: 1299});
    addTearDown(bloc.close);

    Future<void> send(PizzaEvents event) async {
      final next = bloc.stream.first;
      bloc.add(event);
      await next;
    }

    await send(AddPizzaEvent(1));
    final previous = bloc.state;
    await send(AddPizzaEvent(1));
    await send(AddPizzaEvent(2));
    expect(previous.quantities, {1: 1});
    expect(bloc.state.totalPrice, 3497);
    expect(bloc.state.totalQuantity, 3);

    await send(MinusPizzaEvent(2));
    expect(bloc.state.quantities, {1: 2});
    expect(bloc.state.totalPrice, 2198);
    await send(ClearBasketEvent());
    expect(bloc.state.quantities, isEmpty);
    expect(bloc.state.totalPrice, 0);
    expect(bloc.state.totalQuantity, 0);
  });

  test('Unknown pizzas and subtracting from an empty basket do nothing', () async {
    final bloc = PizzaBloc(prices: {1: 1099});
    final states = [];
    final subscription = bloc.stream.listen(states.add);
    bloc.add(AddPizzaEvent(99));
    bloc.add(MinusPizzaEvent(1));
    await bloc.close();
    expect(states, isEmpty);
    await subscription.cancel();
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/pizza_data.dart';
import '../state/pizza_bloc.dart';
import '../state/pizza_bloc_events.dart';
import '../state/pizza_bloc_states.dart';
import 'widgets/appbar_widget.dart';
import 'widgets/one_pizza_card_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String formatPrice(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

  void showBasket(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFE64A19),
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => BlocBuilder<PizzaBloc, PizzaState>(
        builder: (context, state) => SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.7,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Your basket',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        tooltip: 'Close basket',
                        color: Colors.white,
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  if (state.totalQuantity == 0)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                          'Your basket is empty. Add a pizza to get started.',
                          style: TextStyle(color: Colors.white)),
                    )
                  else ...[
                    for (final pizza in pizzas)
                      if ((state.quantities[pizza.id] ?? 0) > 0)
                        ListTile(
                          textColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                          title: Text(pizza.name),
                          subtitle: Text(
                              '${state.quantities[pizza.id]} × ${formatPrice(pizza.price)}'),
                          trailing: Text(formatPrice(
                              pizza.price * state.quantities[pizza.id]!)),
                        ),
                    const Divider(color: Colors.white54),
                    Text('Total: ${formatPrice(state.totalPrice)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PizzaBloc, PizzaState>(
      builder: (context, state) => Scaffold(
        appBar: const AppbarWidget(),
        body: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(12),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 220 + MediaQuery.textScalerOf(context).scale(100),
          children: [
            for (final pizza in pizzas)
              OnePizzaCardWidget(
                name: pizza.name,
                description: pizza.description,
                imagePath: pizza.imagePath,
                price: formatPrice(pizza.price),
                quantity: state.quantities[pizza.id] ?? 0,
                onAdd: () =>
                    context.read<PizzaBloc>().add(AddPizzaEvent(pizza.id)),
                onMinus: () =>
                    context.read<PizzaBloc>().add(MinusPizzaEvent(pizza.id)),
              ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE64A19),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
            onPressed: () => showBasket(context),
            child: Row(
              children: [
                const Icon(Icons.shopping_basket_outlined),
                const SizedBox(width: 12),
                Expanded(child: Text('Basket (${state.totalQuantity})')),
                Text(formatPrice(state.totalPrice)),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_up),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

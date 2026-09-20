import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/pizza_data.dart';
import '../../state/pizza_bloc.dart';
import '../../profile_screen/profile_screen.dart';
import '../../state/pizza_bloc_events.dart';
import '../../state/pizza_bloc_states.dart';

String formatPrice(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

class BasketBottomSheet extends StatelessWidget {
  const BasketBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFE64A19),
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const BasketBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PizzaBloc, PizzaState>(
      listenWhen: (previous, current) =>
          current.orders.length > previous.orders.length,
      listener: (context, state) {
        final navigator = Navigator.of(context);
        navigator.pop();
        navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => const ProfileScreen(),
          ),
        );
      },
      builder: (context, state) => SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Your basket',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (state.totalQuantity == 0)
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Text(
                      'Your basket is empty. Add a pizza to get started.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                else ...[
                  const SizedBox(height: 8),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (final pizza in pizzas)
                            if ((state.quantities[pizza.id] ?? 0) > 0)
                              _BasketItem(
                                name: pizza.name,
                                unitPrice: pizza.price,
                                quantity: state.quantities[pizza.id]!,
                                onAdd: () => context
                                    .read<PizzaBloc>()
                                    .add(AddPizzaEvent(pizza.id)),
                                onRemove: () => context
                                    .read<PizzaBloc>()
                                    .add(MinusPizzaEvent(pizza.id)),
                              ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.white54,
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Total: ${formatPrice(state.totalPrice)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFE64A19),
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () =>
                            context.read<PizzaBloc>().add(PlaceOrderEvent()),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Place order'),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BasketItem extends StatelessWidget {
  const _BasketItem({
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  final String name;
  final int unitPrice;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 6,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$quantity × ${formatPrice(unitPrice)}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.remove_circle_outline),
            color: Colors.white,
            tooltip: 'Remove one',
          ),
          Text(
            '$quantity',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: onAdd,
            icon: const Icon(Icons.add_circle_outline),
            color: Colors.white,
            tooltip: 'Add one',
          ),
          SizedBox(
            width: 64,
            child: Text(
              formatPrice(unitPrice * quantity),
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
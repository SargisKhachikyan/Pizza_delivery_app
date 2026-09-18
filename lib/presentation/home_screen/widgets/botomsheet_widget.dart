import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/pizza_data.dart';
import '../../state/pizza_bloc.dart';
import '../../state/pizza_bloc_states.dart';

String formatPrice(int cents) {
  final dollars = cents / 100; // 1250 -> 12.5
  final text = dollars.toStringAsFixed(2); // 12.5 -> "12.50"
  return '\$$text'; // "12.50" -> "$12.50"
}

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
    return BlocBuilder<PizzaBloc, PizzaState>(
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
                const Text(
                  'Your basket',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (state.totalQuantity == 0)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'Your basket is empty. Add a pizza to get started.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                else ...[
                  for (final pizza in pizzas)
                    if ((state.quantities[pizza.id] ?? 0) > 0)
                      ListTile(
                        textColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        title: Text(pizza.name),
                        subtitle: Text(
                          '${state.quantities[pizza.id]} × ${formatPrice(pizza.price)}',
                        ),
                        trailing: Text(
                          formatPrice(
                              pizza.price * state.quantities[pizza.id]!),
                        ),
                      ),
                  const Divider(color: Colors.white54),
                  Text(
                    'Total: ${formatPrice(state.totalPrice)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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

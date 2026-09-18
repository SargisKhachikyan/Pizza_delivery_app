import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/pizza_data.dart';
import '../../state/pizza_bloc.dart';
import '../../state/pizza_bloc_events.dart'; // <- твой файл с событиями
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
      // Убираем отступы модального окна по умолчанию, чтобы оно растянулось от края до края
      builder: (_) => const BasketBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PizzaBloc, PizzaState>(
      builder: (context, state) => SafeArea(
        child: SizedBox(
          // Растягиваем на всю ширину экрана
          width: double.infinity,
          child: Padding(
            // Вертикальные отступы оставляем, а горизонтальные обнуляем (или уменьшаем по вкусу)
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Возвращаем отступы для заголовка, так как у колонки больше нет левого/правого Padding
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Text(
                      'Your basket is empty. Add a pizza to get started.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                else ...[
                  const SizedBox(height: 8),
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
                  const Divider(color: Colors.white54, height: 24),
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
      // Добавили горизонтальный Padding внутрь элемента, чтобы текст и кнопки не прилипали вплотную к краям экрана
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
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

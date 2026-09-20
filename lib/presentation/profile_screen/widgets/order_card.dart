import 'package:decision_jar_project/data/pizza_data.dart';
import 'package:decision_jar_project/data/pizza_order.dart';
import 'package:decision_jar_project/presentation/home_screen/widgets/botomsheet_widget.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final PizzaOrder order;

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFE64A19);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_pizza_outlined, color: orange),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Order #${order.id}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(formatPrice(order.totalPrice)),
              ],
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            for (final pizza in pizzas)
              if (order.quantities.containsKey(pizza.id))
                Text('${order.quantities[pizza.id]} × ${pizza.name}'),
            const Divider(height: 28),
            Text(
              order.stage.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: orange,
              ),
            ),
            const SizedBox(height: 6),
            Text(order.stage.description),
            const SizedBox(height: 20),
            for (final stage in OrderStage.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      stage.index < order.stage.index ||
                              (stage == OrderStage.delivered &&
                                  stage == order.stage)
                          ? Icons.check_circle
                          : stage == order.stage
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                      color: stage.index <= order.stage.index
                          ? orange
                          : Colors.grey,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        stage.title,
                        style: TextStyle(
                          fontWeight: stage == order.stage
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: stage.index <= order.stage.index
                              ? null
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

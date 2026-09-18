import 'package:flutter/material.dart';
import 'widgets/appbar_widget.dart';
import 'widgets/one_pizza_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final quantities = [0, 0, 0];
  final names = ['Margherita', 'Pepperoni', 'Veggie Delight'];
  final descriptions = [
    'Classic pizza with tomato sauce and cheese',
    'Topped with pepperoni slices and cheese',
    'Loaded with fresh vegetables and cheese',
  ];
  // Prices in cents keep the calculation exact.
  final prices = [1099, 1299, 1199];

  int get total {
    int sum = 0;
    for (int i = 0; i < prices.length; i++) {
      sum += prices[i] * quantities[i];
    }
    return sum;
  }

  int get itemCount => quantities.fold(0, (sum, quantity) => sum + quantity);
  String formatPrice(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

  void showBasket() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFE64A19),
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => SafeArea(
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
                if (itemCount == 0)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                        'Your basket is empty. Add a pizza to get started.',
                        style: TextStyle(color: Colors.white)),
                  )
                else ...[
                  for (int i = 0; i < names.length; i++)
                    if (quantities[i] > 0)
                      ListTile(
                        textColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        title: Text(names[i]),
                        subtitle: Text(
                            '${quantities[i]} × ${formatPrice(prices[i])}'),
                        trailing: Text(formatPrice(prices[i] * quantities[i])),
                      ),
                  const Divider(color: Colors.white54),
                  Text('Total: ${formatPrice(total)}',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarWidget(),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(12),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 220 + MediaQuery.textScalerOf(context).scale(100),
        children: [
          for (int i = 0; i < names.length; i++)
            OnePizzaCardWidget(
              name: names[i],
              description: descriptions[i],
              imagePath: 'assets/pizzas_pictures/${i + 1}.png',
              price: formatPrice(prices[i]),
              quantity: quantities[i],
              onQuantityChanged: (quantity) {
                setState(() => quantities[i] = quantity);
              },
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
          onPressed: showBasket,
          child: Row(
            children: [
              const Icon(Icons.shopping_basket_outlined),
              const SizedBox(width: 12),
              Expanded(child: Text('Basket ($itemCount)')),
              Text(formatPrice(total)),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_up),
            ],
          ),
        ),
      ),
    );
  }
}

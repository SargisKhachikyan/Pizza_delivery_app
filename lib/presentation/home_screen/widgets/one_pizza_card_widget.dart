import 'package:flutter/material.dart';

class OnePizzaCardWidget extends StatefulWidget {
  final String? name;
  final String? description;
  final String? imagePath;
  final String? price;
  final int quantity;
  final ValueChanged<int>? onQuantityChanged;

  const OnePizzaCardWidget({
    super.key,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.quantity,
    this.onQuantityChanged,
  });

  @override
  State<OnePizzaCardWidget> createState() => _OnePizzaCardWidgetState();
}

class _OnePizzaCardWidgetState extends State<OnePizzaCardWidget> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
  }

  void changeQuantity(int value) {
    if (value < 0) return;

    setState(() {
      quantity = value;
    });
    widget.onQuantityChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = widget.imagePath;

    const pizzaIcon = Center(
      child: Icon(
        Icons.local_pizza,
        size: 90,
        color: Colors.deepOrange,
      ),
    );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePath != null && imagePath.isNotEmpty)
              Image.asset(
                imagePath,
                height: 90,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return pizzaIcon;
                },
              )
            else
              pizzaIcon,
            const SizedBox(height: 12),
            Text(
              widget.name ?? 'Pizza',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            const Spacer(),
            Text(
              widget.price ?? 'Price unavailable',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: quantity == 0
                  ? ElevatedButton(
                      onPressed: () => changeQuantity(1),
                      child: const Text('Add'),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Remove one',
                          onPressed: () => changeQuantity(quantity - 1),
                          icon: const Icon(Icons.remove),
                        ),
                        Flexible(
                          child: FittedBox(
                            child: Text('$quantity',
                                style: const TextStyle(fontSize: 16)),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Add one',
                          onPressed: () => changeQuantity(quantity + 1),
                          icon: const Icon(Icons.add),
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

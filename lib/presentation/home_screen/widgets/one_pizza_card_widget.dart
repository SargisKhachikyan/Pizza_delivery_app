import 'package:flutter/material.dart';

class OnePizzaCardWidget extends StatelessWidget {
  final String? name;
  final String? description;
  final String? imagePath;
  final String? price;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onMinus;

  const OnePizzaCardWidget({
    super.key,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.quantity,
    required this.onAdd,
    required this.onMinus,
  });

  @override
  Widget build(BuildContext context) {
    final path = imagePath;

    const pizzaIcon = Center(
      child: Icon(
        Icons.local_pizza,
        size: 90,
        color: Colors.deepOrange,
      ),
    );

    return Card(
      margin: EdgeInsets.zero,
      color: const Color(0xFFFFF9E6),
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (path != null && path.isNotEmpty)
              Image.asset(
                path,
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
              name ?? 'Pizza',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            const Spacer(),
            Text(
              price ?? 'Price unavailable',
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
                      onPressed: onAdd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC64F00),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add'),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Remove one',
                          color: const Color(0xFFC64F00),
                          onPressed: onMinus,
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
                          color: const Color(0xFFC64F00),
                          onPressed: onAdd,
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

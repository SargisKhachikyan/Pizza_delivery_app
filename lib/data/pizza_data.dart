class Pizza {
  final int id;
  final String name;
  final String description;
  final String imagePath;
  // Price in cents.
  final int price;

  const Pizza({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
  });
}

const pizzas = [
  Pizza(
      id: 1,
      name: 'Margherita',
      description: 'Classic pizza with tomato sauce and cheese',
      imagePath: 'assets/pizzas_pictures/1.png',
      price: 1099),
  Pizza(
      id: 2,
      name: 'Pepperoni',
      description: 'Topped with pepperoni slices and cheese',
      imagePath: 'assets/pizzas_pictures/2.png',
      price: 1299),
  Pizza(
      id: 3,
      name: 'Veggie Delight',
      description: 'Loaded with fresh vegetables and cheese',
      imagePath: 'assets/pizzas_pictures/3.png',
      price: 1199),
];

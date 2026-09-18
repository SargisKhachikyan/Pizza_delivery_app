import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/pizza_data.dart';
import 'presentation/state/pizza_bloc.dart';
import 'presentation/home_screen/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PizzaBloc(
          prices: {for (final pizza in pizzas) pizza.id: pizza.price}),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFE64A19),
            foregroundColor: Colors.white,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}

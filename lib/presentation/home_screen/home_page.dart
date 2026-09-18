import 'package:decision_jar_project/presentation/home_screen/widgets/botomsheet_widget.dart';
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
            onPressed: () => BasketBottomSheet.show(context),
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
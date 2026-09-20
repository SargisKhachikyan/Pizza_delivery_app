import 'order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/pizza_bloc.dart';
import '../state/pizza_bloc_events.dart';
import '../state/pizza_bloc_states.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PizzaBloc, PizzaState>(
      listenWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus,
      listener: (context, state) {
        if (state.loginStatus == LoginStatusEnum.success) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }

        if (state.loginStatus == LoginStatusEnum.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error ?? 'Unable to sign out. Please try again.',
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final email = context.read<PizzaBloc>().userEmail;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0xFFEEEEEE),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          email,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  if (state.orders.isNotEmpty) ...[
                    Text('Your orders',
                        style: Theme.of(context).textTheme.titleLarge),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => context
                            .read<PizzaBloc>()
                            .add(DeleteAllOrdersEvent()),
                        icon: const Icon(Icons.delete_sweep_outlined),
                        label: const Text('Delete all orders'),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final order in state.orders)
                      OrderCard(
                        key: ValueKey(order.id),
                        order: order,
                        onDelete: () => context
                            .read<PizzaBloc>()
                            .add(DeleteOrderEvent(order.id)),
                      ),
                  ] else
                    const Text('No orders yet.'),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            context.read<PizzaBloc>().add(SignOutEvent());
                          },
                    icon: state.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.logout),
                    label: const Text('Sign out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

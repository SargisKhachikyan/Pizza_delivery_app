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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  const Spacer(),
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state/pizza_bloc.dart';
import '../../state/pizza_bloc_events.dart';
import '../../state/pizza_bloc_states.dart';
import 'login_fields.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    context.read<PizzaBloc>().add(
          SubmitLoginEvent(
            email: emailController.text,
            password: passwordController.text,
          ),
        );
  }

  void changeMode() {
    formKey.currentState?.reset();
    passwordController.clear();
    context.read<PizzaBloc>().add(ToggleLoginModeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PizzaBloc, PizzaState>(
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.local_pizza,
                size: 72,
                color: Colors.deepOrange,
              ),
              const SizedBox(height: 24),
              Text(
                state.isLogin ? 'Welcome back!' : 'Create an account',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              LoginFields(
                emailController: emailController,
                passwordController: passwordController,
                isLogin: state.isLogin,
                isLoading: state.isLoading,
                onSubmit: submit,
              ),
              if (state.error != null) ...[
                const SizedBox(height: 16),
                Text(
                  state.error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: state.isLoading ? null : submit,
                child: state.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(state.isLogin ? 'Sign in' : 'Create account'),
              ),
              TextButton(
                onPressed: state.isLoading ? null : changeMode,
                child: Text(
                  state.isLogin
                      ? "Don't have an account? Sign up"
                      : 'Already have an account? Sign in',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

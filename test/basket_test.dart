import 'package:decision_jar_project/data/pizza_data.dart';
import 'package:decision_jar_project/presentation/home_screen/home_page.dart';
import 'package:decision_jar_project/presentation/state/pizza_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basket total follows card quantity and opens a sheet',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => PizzaBloc(
          prices: {for (final pizza in pizzas) pizza.id: pizza.price},
        ),
        child: const MaterialApp(home: HomePage()),
      ),
    );
    await tester.tap(find.text('Basket (0)'));
    await tester.pumpAndSettle();
    expect(find.text('Your basket is empty. Add a pizza to get started.'),
        findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add').first);
    await tester.pump();
    await tester.tap(find.byTooltip('Add one').first);
    await tester.pump();
    expect(find.text('Basket (2)'), findsOneWidget);
    await tester.tap(find.text('Basket (2)'));
    await tester.pumpAndSettle();
    expect(find.text('Total: \$21.98'), findsOneWidget);
    expect(find.text('2 × \$10.99'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Remove one').first);
    await tester.pump();
    await tester.tap(find.byTooltip('Remove one').first);
    await tester.pump();
    expect(find.text('Basket (0)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

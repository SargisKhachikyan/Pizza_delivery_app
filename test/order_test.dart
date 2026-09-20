import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

import 'package:decision_jar_project/data/pizza_data.dart';
import 'package:decision_jar_project/data/pizza_order.dart';
import 'package:decision_jar_project/presentation/home_screen/home_page.dart';
import 'package:decision_jar_project/presentation/profile_screen/profile_screen.dart';
import 'package:decision_jar_project/presentation/state/pizza_bloc.dart';
import 'package:decision_jar_project/presentation/state/pizza_bloc_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class PreviewPizzaBloc extends PizzaBloc {
  PreviewPizzaBloc()
      : super(prices: {for (final pizza in pizzas) pizza.id: pizza.price});

  @override
  String get userEmail => 'alex@example.com';
}

void main() {
  testWidgets('Checkout clears basket, tracks all stages and keeps order items',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final bloc = PreviewPizzaBloc();
    addTearDown(bloc.close);
    await tester.pumpWidget(BlocProvider<PizzaBloc>.value(
      value: bloc,
      child: const MaterialApp(home: HomePage()),
    ));
    await tester.tap(find.text('Add').first);
    await tester.pump();
    await tester.tap(find.byTooltip('Add one').first);
    await tester.pump();
    await tester.tap(find.text('Basket (2)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(bloc.state.totalQuantity, 0);
    expect(bloc.state.totalPrice, 0);
    expect(bloc.state.orders.single.quantities.values.single, 2);
    expect(bloc.state.orders.single.totalPrice, 2198);
    bloc.add(PlaceOrderEvent());
    await tester.pump();
    expect(bloc.state.orders.length, 1);
    for (final stage in OrderStage.values.skip(1)) {
      await tester.pump(const Duration(seconds: 15));
      expect(bloc.state.orders.single.stage, stage);
    }
    expect(
        find.text('Your order is with you. Enjoy your pizza!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Profile preview', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final bloc = PreviewPizzaBloc();
    addTearDown(bloc.close);
    bloc.add(AddPizzaEvent(pizzas.first.id));
    bloc.add(AddPizzaEvent(pizzas.first.id));
    await tester.pump();
    bloc.add(PlaceOrderEvent());
    await tester.pump();
    if (Platform.environment['SAVE_ORDER_PREVIEW'] == '1') {
      await tester.runAsync(() async {
        final fontDirectory = Platform.environment['PREVIEW_FONT_DIR'] ??
            '/opt/homebrew/share/flutter/bin/cache/artifacts/material_fonts';
        for (final entry in {
          'Roboto': 'Roboto-Regular.ttf',
          'MaterialIcons': 'MaterialIcons-Regular.otf'
        }.entries) {
          final loader = FontLoader(entry.key);
          loader.addFont(Future.value(ByteData.sublistView(
              await File('$fontDirectory/${entry.value}').readAsBytes())));
          await loader.load();
        }
      });
    }
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(BlocProvider<PizzaBloc>.value(
      value: bloc,
      child: RepaintBoundary(
        key: boundaryKey,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFE64A19),
              foregroundColor: Colors.white,
            ),
          ),
          home: const ProfileScreen(),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 15));
    await tester.pump();
    expect(tester.takeException(), isNull);
    if (Platform.environment['SAVE_ORDER_PREVIEW'] == '1') {
      final boundary = boundaryKey.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await Directory('output').create(recursive: true);
        await File('output/order-profile.png')
            .writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }
    await tester.pump(const Duration(seconds: 45));
    await tester.pump();
  });
}

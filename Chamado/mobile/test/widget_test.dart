// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';
import 'package:provider/provider.dart';
import 'package:mobile/view_models/login_view_model.dart';
import 'package:mobile/view_models/home_view_model.dart';
import 'package:mobile/view_models/auth_view_model.dart';

void main() {
  testWidgets('Login page smoke test', (WidgetTester tester) async {
    // Build our app with required providers and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
          ChangeNotifierProvider(create: (_) => HomeViewModel()),
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ],
        child: const PredialFix(initialRoute: '/'),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the login page displays institutional email text and the enter button
    expect(find.text('E-MAIL INSTITUCIONAL'), findsOneWidget);
    expect(find.text('ENTRAR NO SISTEMA'), findsOneWidget);
  });
}

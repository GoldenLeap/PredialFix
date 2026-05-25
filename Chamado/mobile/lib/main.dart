import 'package:mobile/view_models/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'view/login_view.dart';
import 'view_models/login_view_model.dart';
import 'view/home_view.dart';
import 'services/sound_navigation_observer.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  final token = await authService.getToken();
  final initialRoute = (token != null && token.isNotEmpty) ? '/home' : '/';

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ChangeNotifierProvider(create: (_) => HomeViewModel()),
    ], child: PredialFix(initialRoute: initialRoute)),
  );
}

class PredialFix extends StatelessWidget {
  final String initialRoute;
  const PredialFix({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PredialFix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Roboto',
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const LoginView(),
        '/home': (context) => const HomeView(),
      },
      navigatorObservers: [
        SoundNavigationObserver(),
      ],
    );
  }
}
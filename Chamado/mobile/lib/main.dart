import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'view/login_view.dart';
import 'view_models/login_view_model.dart';
import 'view/home_view.dart';
import 'view_models/home_view_model.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ChangeNotifierProvider(create: (_) => HomeViewModel()),
    ], child: const PredialFix()),
  );
}

class PredialFix extends StatelessWidget {
  const PredialFix({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PredialFix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/home': (context) => const HomeView(),
      },
    );
  }
}
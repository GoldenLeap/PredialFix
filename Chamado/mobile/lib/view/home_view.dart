import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/home_view_model.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});


  @override
  State<HomeView> createState() => _homeViewState();
}

class _homeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final homeModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PredialFix'),
        backgroundColor: const Color(0xFFFF0000),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await homeModel.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Column(
        children: [
          Title(color:Colors.purple, child: Text("67", style: TextStyle(fontSize: 200))),
        ],
      
      )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cust_drawer.dart';


class DashboardView extends StatefulWidget{
  const DashboardView({super.key});

  @override 
  State<DashboardView> createState() => _DashboardViewState();

}

class _DashboardViewState extends State<DashboardView>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Controle'),
        backgroundColor: const Color(0xFFFF0000),
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer()

    );
  }
}
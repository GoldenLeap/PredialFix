import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../view_models/home_view_model.dart';

Widget _buildDrawer(BuildContext context, HomeViewModel viewModel) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFFFF0000)),
            accountName: Text(viewModel.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text(viewModel.userCargo.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFFFF0000)),
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Meu Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(alignment: Alignment.centerLeft, child: Text('CONFIGURAÇÕES', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5))),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Alterar Senha'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings/password');
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Autenticação 2FA'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings/two-factor');
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Aparência'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings/appearance');
            },
          ),
          
          // Itens visíveis apenas para Administradores / Responsáveis
          if (viewModel.userCargo == 'responsavel' || viewModel.userCargo == 'admin') ...[
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(alignment: Alignment.centerLeft, child: Text('ADMINISTRAÇÃO', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5))),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Materiais'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/materiais');
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Orçamento'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/orcamento');
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Relatórios'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/relatorios');
              },
            ),
          ],
          
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sair do Sistema', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () async {
              final authService = AuthService();
              await authService.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        return _buildDrawer(context, viewModel);
      },
    );
  }
}
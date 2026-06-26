import 'package:agenda_eletronica_pessoal/screens/home/components/dynamic_fab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const HomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 0,
      ),

      body: SafeArea(child: navigationShell),

      floatingActionButton: buildDynamicFAB(
        context,
        navigationShell.currentIndex,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) {
          navigationShell.goBranch(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contatos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Grupos'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Eventos'),
        ],
      ),
    );
  }
}

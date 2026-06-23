import 'package:agenda_eletronica_pessoal/screens/home/components/dynamic_fab.dart';
import 'package:agenda_eletronica_pessoal/screens/home/components/main_body.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyHomePage(title: 'Agenda Eletrônica');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    // Inicializa o controlador para as 3 abas
    _tabController = TabController(length: 3, vsync: this);

    // Listener para re-renderizar o widget quando a aba ativa mudar
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: buildBody(_tabController),
      floatingActionButton: buildDynamicFAB(context, _tabController),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Theme.of(context).colorScheme.inversePrimary,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: const [
          Tab(icon: Icon(Icons.contacts), text: 'Contatos'),
          Tab(icon: Icon(Icons.group), text: 'Grupos'),
          Tab(icon: Icon(Icons.event), text: 'Eventos'),
        ],
      ),
    );
  }
}

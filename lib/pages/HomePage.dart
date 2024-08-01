import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error); // Icône d'erreur si l'image ne charge pas
                    },
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.brown, size: 25),
                    Text("Dakar,SN",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.brown,
                            fontFamily: 'Poppins'))
                  ],
                ),
                Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text('5',
                            style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const Icon(Icons.notifications_none,
                        color: Colors.brown, size: 50),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Nom User",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins')),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  labelText: 'Recherchez',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100))),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200, // Définir la hauteur du conteneur
              child: Scaffold(
                appBar: TabBar(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  controller: _tabController,
                  tabs: const [
                    Tab(icon: Icon(Icons.restaurant) , ),
                    Tab(icon: Icon(Icons.party_mode) , ),
                    Tab(icon: Icon(Icons.local_activity) ,),
                  ],
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.brown,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(80.0),
                    color: Colors.brown.withOpacity(0.2),
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: const <Widget>[
                    Center(child: Text('Pizza Tab Content')),
                    Center(child: Text('Drink Tab Content')),
                    Center(child: Text('Cake Tab Content')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Screen/CategorieTile.dart';
import '../model/categorie.dart';
import 'Liste.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final FirebaseFirestore _Etablissement = FirebaseFirestore.instance;
  List<Category> categories = [];
  List<Category> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    getDocumentData();
  }

  Future<void> getDocumentData() async {
    try {
      QuerySnapshot querySnapshot = await _Etablissement.collection('TypeEtab').get();
      setState(() {
        categories = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Category(
            name: data['Etab'] ?? 'Pas de nom',
            typetab: data['ActiviteEtab'],
            imageUrl: data['ImageEtab'] ?? 'not found',
          );
        }).toList();
      });
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
    }
  }

  void filterCategories(String typetab) {
    setState(() {
      filteredCategories = categories.where((category) => category.typetab == typetab).toList();
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
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  const Text(
                    "Nom User",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSearchField(),
                  const SizedBox(height: 16),
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildCategoryListView("food"),
                        _buildCategoryListView("loge"),
                        _buildCategoryListView("divertissement"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.menu, size: 30),
          onPressed: () {
            setState(() {
              // Action de menu si nécessaire
            });
          },
        ),
        const Row(
          children: [
            Icon(Icons.location_on, color: Colors.brown, size: 25),
            Text(
              "Dakar,SN",
              style: TextStyle(
                fontSize: 20,
                color: Colors.brown,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        _buildNotificationIcon(),
      ],
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
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
            child: const Text(
              '5',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        const Icon(
          Icons.notifications_none,
          color: Colors.brown,
          size: 50,
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.search),
        labelText: 'Recherchez',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(icon: Icon(Icons.restaurant)),
        Tab(icon: Icon(Icons.hotel)),
        Tab(icon: Icon(Icons.park)),
      ],
      unselectedLabelColor: Colors.black,
      labelColor: Colors.brown,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(80.0),
        color: Colors.brown.withOpacity(0.2),
      ),
    );
  }

  Widget _buildCategoryListView(String typetab) {
    List<Category> filteredList = categories.where((category) => category.typetab == typetab).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final category = filteredList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CategoryTile(
            typetab: category.typetab,
            imageUrl: category.imageUrl,
            imageAlignment: Alignment.topCenter,
            NameItem: category.name,
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => Grids(category: category),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

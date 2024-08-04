import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      body: Padding(
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildProfileImage(),
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

  Widget _buildProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Image.network(
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      ),
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
          ),
        );
      },
    );
  }
}

class Category {
  final String name;
  final String imageUrl;
  final String typetab;

  Category({required this.name, required this.imageUrl,required this.typetab });
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    required this.imageUrl,
    required this.NameItem,
    required this.typetab,
    this.imageAlignment = Alignment.center,
    Key? key,
  }) : super(key: key);

  final String typetab;
  final String NameItem;
  final String imageUrl;
  final Alignment imageAlignment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              colorBlendMode: BlendMode.darken,
              alignment: imageAlignment,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.3),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                NameItem,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

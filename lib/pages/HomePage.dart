import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Category> categories = [
    Category(
      name: 'Restaurant',
      imageUrl: 'https://images.unsplash.com/photo-1551632436-cbf8dd35adfa?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHJlc3RhdXJhbnR8ZW58MHx8MHx8fDA%3D',
    ),
    Category(
      name: 'Hotel',
      imageUrl: 'https://plus.unsplash.com/premium_photo-1661962754715-d081d9ec53a3?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fG1vbnVtZW50JTIwZGUlMjBsYSUyMHJlbmFpc3NhbmNlfGVufDB8fDB8fHww',
    ),
    Category(
      name: 'Place',
      imageUrl: 'https://images.unsplash.com/photo-1514321648849-f4e1d5da98dc?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGZldGUlMjBmb3JyYWluZXxlbnwwfHwwfHx8MA%3D%3D',
    ),
  ];

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
                  _buildCategoryListView(),
                  Center(child: Text('Hotel Tab Content')),
                  Center(child: Text('Park Tab Content')),
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

  Widget _buildCategoryListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CategoryTile(
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

  Category({required this.name, required this.imageUrl});
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    required this.imageUrl,
    required this.NameItem,
    this.imageAlignment = Alignment.center,
    Key? key,
  }) : super(key: key);

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

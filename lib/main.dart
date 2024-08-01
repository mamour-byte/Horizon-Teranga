import 'package:flutter/material.dart';
import 'package:horizonteranga/pages/Profile.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'pages/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  SetCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
            [
            "Acceuil",
            "Profile",
            ][_currentIndex],
              style: const TextStyle(color: Colors.brown),
          ),
          backgroundColor: Colors.white,
        ),
          body: [
            const HomePage(),
            const Profile(),
          ][_currentIndex],

          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,
            selectedItemColor: const Color(0xff6200ee),
            unselectedItemColor: const Color(0xff757575),
            backgroundColor: Colors.white,
            onTap: (i) => setState(() => _currentIndex = i),
            items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Acceuil"),
            selectedColor: Colors.brown,
            ),

          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.brown,
            ),

          ],
        )

      )
    );
  }
}


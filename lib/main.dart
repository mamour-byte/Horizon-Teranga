import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:horizonteranga/pages/Auth.dart';
import 'package:horizonteranga/pages/Liste.dart';
import 'package:horizonteranga/pages/Profile.dart';
import 'Screen/Animation.dart';
import 'firebase_options.dart';
import 'package:horizonteranga/pages/Maps.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'pages/HomePage.dart';



void main() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEEEEEE)),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context  , AsyncSnapshot<User?> snapshot){
              if (snapshot.hasData && snapshot.data != null){
                return  Home(currentIndex: _currentIndex, setCurrentIndex: setCurrentIndex);
              }else if(snapshot.connectionState == ConnectionState.waiting){
                return const Center( child: LoadAnimation(),);
              }
              return Auth();
            }
        )
    );
  }
}



class Home extends StatelessWidget {
  final int currentIndex;
  final void Function(int) setCurrentIndex;

  Home({required this.currentIndex, required this.setCurrentIndex});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                [
                  "Acceuil",
                  "Maps",
                  "Profile",
                ][currentIndex],
                style: const TextStyle(color: Colors.brown),
              ),
              backgroundColor: Colors.white,
            ),
            body: [
              const HomePage(),
              const MapsPage(),
              const ProfilePage(),
            ][currentIndex],

            bottomNavigationBar: SalomonBottomBar(
              currentIndex: currentIndex,
              selectedItemColor: const Color(0xff6200ee),
              unselectedItemColor: const Color(0xff757575),
              backgroundColor: Colors.white,
              onTap: (i) => setCurrentIndex(i),
              items: [
                /// Home
                SalomonBottomBarItem(
                  icon: const Icon(Icons.home),
                  title: const Text("Acceuil"),
                  selectedColor: Colors.brown,
                ),

                SalomonBottomBarItem(
                  icon: Icon(Icons.map),
                  title: Text("Carte"),
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




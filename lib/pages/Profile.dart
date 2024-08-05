import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screen/Animation.dart';
import '../Screen/ShowScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  late Future<DocumentSnapshot> _userDocument;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _userDocument = FirebaseFirestore.instance
          .collection('User')
          .doc(_user!.uid)
          .get();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _userDocument,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Profil') , backgroundColor: Colors.brown,),
            body:   const Center(child: LoadAnimation() ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Profil')),
            body: const Center(child: Text('Erreur de chargement')),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: const Text('Profil')),
            body: const Center(child: Text('Aucun utilisateur trouvé')),
          );
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  userData['NomUser'] ?? 'Nom inconnu',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userData['EmailUser'] ?? 'Email inconnu',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone, color: Colors.brown),
                    const SizedBox(width: 8),
                    Text(
                      userData['TelephoneUser'] ?? 'Téléphone inconnu',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cake, color: Colors.brown),
                    const SizedBox(width: 8),
                    Text(
                      userData['DateUser'] ?? 'Not found',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    const ShowScreen();
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Modifier le profil'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSettingsOption(
                  context,
                  icon: Icons.settings,
                  label: 'Paramètres du compte',
                  onTap: () {},
                ),
                _buildSettingsOption(
                  context,
                  icon: Icons.lock,
                  label: 'Changer le mot de passe',
                  onTap: () {},
                ),
                _buildSettingsOption(
                  context,
                  icon: Icons.help_outline,
                  label: 'Support',
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Déconnexion'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.brown),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Colors.brown,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsOption(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.brown),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Poppins',
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.brown),
      onTap: onTap,
    );
  }
}

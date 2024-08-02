import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
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

              // Nom de l'utilisateur
              const Text(
                'Nom Utilisateur',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),


              const Text(
                'email@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),


              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: Colors.brown),
                  SizedBox(width: 8),
                  Text(
                    '+221 123 456 789',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date de naissance
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Icon(Icons.cake, color: Colors.brown),
                  SizedBox(width: 8),
                  Text(
                    '01 Janvier 1990',
                    style: TextStyle(
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
                  // Action pour modifier le profil
                },
                icon: const Icon(Icons.edit),
                label: const Text('Modifier le profil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Section Paramètres
              _buildSettingsOption(
                context,
                icon: Icons.settings,
                label: 'Paramètres du compte',
                onTap: () {
                  // Action pour accéder aux paramètres
                },
              ),
              _buildSettingsOption(
                context,
                icon: Icons.lock,
                label: 'Changer le mot de passe',
                onTap: () {
                  // Action pour changer le mot de passe
                },
              ),
              _buildSettingsOption(
                context,
                icon: Icons.help_outline,
                label: 'Support',
                onTap: () {
                  // Action pour accéder au support
                },
              ),
              const SizedBox(height: 24),

              // Bouton pour se déconnecter
              OutlinedButton.icon(
                onPressed: () {
                  // Action pour se déconnecter
                },
                icon: const Icon(Icons.logout),
                label: const Text('Déconnexion'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.brown),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
        )
    );
  }

  Widget _buildSettingsOption(
      BuildContext context, {
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



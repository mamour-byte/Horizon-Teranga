import 'package:flutter/material.dart';

class ShowScreen extends StatefulWidget {
  const ShowScreen({super.key});

  @override
  State<ShowScreen> createState() => _ShowScreenState();
}

class _ShowScreenState extends State<ShowScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('hello'),);

  }


  Future<void> show() async {
    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text('Modifier le Profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {},
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                onChanged: (value) {},
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                onChanged: (value) {},
                decoration: const InputDecoration(labelText: 'Photo de Profil'),
              ),
              TextField(
                onChanged: (value) {},
                decoration: const InputDecoration(labelText: 'Telephone'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: ()  {
                Navigator.pop(context);
              },
              child: const Text('Modifier'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annular'),
            ),
          ],
        );
      },
    );
  }


}


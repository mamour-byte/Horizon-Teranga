import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:horizonteranga/Screen/Animation.dart';
import 'package:horizonteranga/model/categorie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'Maps.dart';

class Grids extends StatefulWidget {
  final Category category;

  const Grids({super.key, required this.category});

  @override
  State<Grids> createState() => _GridsState();
}

class _GridsState extends State<Grids> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name), backgroundColor: Colors.brown,),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Etablissement').where('Categorie', isEqualTo: widget.category.name).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadAnimation());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var items = snapshot.data!.docs;

            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          imageUrl: item['ImageEtab']!,
                          title: item['NomEtab']!,
                          description: item['Description']!,
                          localisation: item['localisation'],
                        ),
                      ),
                    );
                  },
                  child: MouseRegion(
                    onEnter: (_) => setState(() {}),
                    onExit: (_) => setState(() {}),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(item['ImageEtab']!),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['NomEtab']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item['Description']!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Aucune donnée trouvée.'));
          }
        },
      ),
    );
  }
}



class DetailPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final GeoPoint localisation;

  const DetailPage({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.localisation
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage de l'image en haut
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
            ),

            SizedBox(height: 20,),

            // Description du lieu touristique
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            SizedBox(height: 20,),

            // Système d'étoiles pour la note
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text(
                    "Note:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 12),
                  RatingBar.builder(
                    initialRating: 4,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                    itemBuilder: (context, _) => const Icon( Icons.star,  color: Colors.brown, ),
                    onRatingUpdate: (rating) {
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20,),

            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [

                  Text("Contact" , style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold ),) ,
                  SizedBox(width: 12),
                  Text('77 856 98 23 , 78 477 17 06' )
                ],
              )
            ),

            SizedBox(height: 20,),


            // Bouton de redirection vers la page de localisation
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(),
                      settings: RouteSettings(
                        arguments: localisation,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: const Center(
                  child: Text("Voir la localisation"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
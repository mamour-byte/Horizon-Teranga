import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/User.dart';


class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  final CollectionReference<Map<String, dynamic>> userCollection = FirebaseFirestore.instance.collection("User");



  Future<void> saveUser(String Nom, String Email, String Telephone, String Password) async {
    await userCollection.doc(uid).set({
        'NomUser': Nom,
        'EmailUser': Email,
        'TelephoneUser': Telephone,
        'PasswordUser': Password
      });
  }


  AppUserData _userFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("Utilisateur inexistant");
    return AppUserData(
        uid: uid,
        Nom: data['Nom'],
        Telephone: data['Telephone'],
        Email : data['Email'],
        Password: data['Password'],
        Adresse: data['Adresse']
    );
  }

  Future<AppUserData> userData(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('User').doc(userId).get();
      if (snapshot.exists) {
        return _userFromSnapshot(snapshot);
      } else {
        throw Exception('Utilisateur non trouvé');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des données : $e');
    }
  }



}
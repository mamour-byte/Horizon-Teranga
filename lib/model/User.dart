class AppUser {
  final String uid;
  AppUser(this.uid);
}

class AppUserData {
  final String uid;
  final String Nom;
  final String Telephone ;
  final String Email ;
  final String Password;
  final String Adresse;

  AppUserData({
    required this.uid,
    required this.Nom,
    required this.Telephone,
    required this.Email,
    required this.Password,
    required this.Adresse,
  });
}

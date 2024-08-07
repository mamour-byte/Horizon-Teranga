import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:horizonteranga/main.dart';
import 'package:horizonteranga/model/User.dart';
import 'package:horizonteranga/pages/Profile.dart';
import '../Screen/FormWidget.dart';
import '../Services/AuthService.dart';
import 'HomePage.dart';

class Auth extends StatefulWidget {
  final Function(String? email, String? password)? onSubmitted;

  const Auth({this.onSubmitted, Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<Auth> {
  late String email = '', password = '';
  String? emailError, passwordError;
  final _auth = AuthenticationService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

    final emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    bool isValid = true;
    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = 'Email is invalid';
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Please enter a password';
      });
      isValid = false;
    }

    return isValid;
  }

  void submit() {
    if (validate() && widget.onSubmitted != null) {
      widget.onSubmitted!(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: screenHeight * .12),
              const Text(
                'Welcome,',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                'Sign in to continue!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(.6),
                ),
              ),
              SizedBox(height: screenHeight * .12),
              InputField(
                controller: _emailController,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                labelText: 'Email',
                errorText: emailError,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autoFocus: true,
              ),
              SizedBox(height: screenHeight * .025),
              InputField(
                controller: _passwordController,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                onSubmitted: (val) => submit(),
                labelText: 'Password',
                errorText: passwordError,
                obscureText: true,
                textInputAction: TextInputAction.done,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * .075),
              FormButton(
                text: 'Log In',
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    var result = await _auth.signInWithEmailAndPassword(_emailController.value.text, _passwordController.value.text,);
                    if (result == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login ou Mot de passe incorrect'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: screenHeight * .05),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () async{
                        UserCredential? userCredential = await _handleSignIn();
                        if (userCredential != null) {
                          print("User signed in: ${userCredential.user!.displayName}");
                        } else {
                          print("Error signing in.");
                        }

                      },
                      icon: const Icon(Icons.g_mobiledata_outlined,
                      color: Colors.brown,
                        size: 40,
                      )
                  ),
                  IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.facebook),
                    color: Colors.brown,
                  ),
                  IconButton(
                      onPressed: (){},
                      icon: const Icon(
                          Icons.apple,
                        color: Colors.brown,
                      )
                  ),
                ],
              ),
              SizedBox(height: screenHeight * .05),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SimpleRegisterScreen(),
                  ),
                ),
                child: RichText(
                  text: const TextSpan(
                    text: "I'm a new user, ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<UserCredential?> _handleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      return await _auth.signInWithCredential(googleAuthCredential);
    } catch (error) {
      print(error);
      return null;
    }
  }



}

class SimpleRegisterScreen extends StatefulWidget {
  final Function(String? email, String? password)? onSubmitted;

  const SimpleRegisterScreen({this.onSubmitted, Key? key}) : super(key: key);

  @override
  State<SimpleRegisterScreen> createState() => _SimpleRegisterScreenState();
}

class _SimpleRegisterScreenState extends State<SimpleRegisterScreen> {
  late String email = '', password = '', confirmPassword = '', Nom = '', Telephone = '';
  String? emailError, passwordError;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomController = TextEditingController();
  final _telephoneController = TextEditingController();



  @override
  void initState() {
    super.initState();
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

    final emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    bool isValid = true;
    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = 'Email is invalid';
      });
      isValid = false;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        passwordError = 'Please enter a password';
      });
      isValid = false;
    }
    if (password != confirmPassword) {
      setState(() {
        passwordError = 'Passwords do not match';
      });
      isValid = false;
    }

    return isValid;
  }

  void submit() {
    if (validate() && widget.onSubmitted != null) {
      widget.onSubmitted!(email, password);
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: screenHeight * .1),
              const Text(
                'Create Account,',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                'Sign up to get started!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(.6),
                ),
              ),
              SizedBox(height: screenHeight * .10),
              InputField(
                controller: _nomController,
                onChanged: (value) => setState(() => Nom = value),
                labelText: 'Nom',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autoFocus: true,
              ),
              SizedBox(height: screenHeight * .025),
              InputField(
                controller: _emailController,
                onChanged: (value) => setState(() => email = value),
                labelText: 'Email',
                errorText: emailError,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: screenHeight * .025),
              InputField(
                controller: _telephoneController,
                onChanged: (value) => setState(() => Telephone = value),
                labelText: 'Telephone',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: screenHeight * .025),
              InputField(
                onChanged: (value) => setState(() => password = value),
                labelText: 'Password',
                errorText: passwordError,
                obscureText: true,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: screenHeight * .025),
              InputField(
                onChanged: (value) => setState(() => confirmPassword = value),
                controller: _passwordController,
                onSubmitted: (value) => submit(),
                labelText: 'Confirm Password',
                errorText: passwordError,
                obscureText: true,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: screenHeight * .075),
              FormButton(
                text: 'Sign Up',
                onPressed: ()async{
                if (_formKey.currentState?.validate() ?? false) {
                  var nom = _nomController.text;
                  var email = _emailController.text;
                  var password = _passwordController.text;
                  var telephone = _telephoneController.text;

                  AppUser? user = await _auth.registerWithEmailAndPassword(nom, email, telephone, password);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()), );

                  } else {
                    ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                        content: Text('Erreur lors de l\'inscription.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                 }
              ),
              SizedBox(height: screenHeight * .075),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: RichText(
                  text: const TextSpan(
                    text: "I'm already a member, ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Sign In',
                        style: TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * .1),
            ],
          ),
        ),
      ),
    );
  }
}




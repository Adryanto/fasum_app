import 'package:fasum_app/screens/home_screen.dart';
import 'package:fasum_app/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
  clientId:
      //'829645055585-pnupfc4ej4qtn8pm33s37vu8491mafo7.apps.googleusercontent.com',
      '859967241146-1j9mncnm5hurf8blt8urslvjagnkcu7r.apps.googleusercontent.com',
);

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key});
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  ValueNotifier userCredential = ValueNotifier('');

  Future<dynamic> _signInWIthGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_errorMessage),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text;

                  if (email.isEmpty || !isValidEmail(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please Enter A Valid Email")));
                    return;
                  }
                  if (password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please Enter Your Password")));
                    return;
                  }

                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      // <-- Gunakan FirebaseAuth.instance
                      email: email,
                      password: password,
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  } on FirebaseAuthException catch (error) {
                    print('Error code: ${error.code}');
                    if (error.code == 'user-not-found') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('No User Found With That Email')),
                      );
                    } else if (error.code == 'wrong-password') {
                      // Jika password salah, tampilkan pesan kesalahan
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Wrong password. Please try again.')),
                      );
                    } else {
                      // Jika terjadi kesalahan lain, tampilkan pesan kesalahan umum
                      setState(() {
                        _errorMessage = error.message ?? 'An error occurred';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_errorMessage),
                        ),
                      );
                    }
                  } catch (error) {
                    // Tangani kesalahan lain yang tidak terkait dengan otentikasi
                    setState(() {
                      _errorMessage = error.toString();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_errorMessage),
                      ),
                    );
                  }
                },
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 20.0),
              const Text(
                "-- Or Sign In With --",
                style: TextStyle(color: Color.fromARGB(255, 187, 179, 179)),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton.icon(
                  onPressed: _signInWIthGoogle,
                  icon: Image.asset(
                    'assets/gicon.png',
                    height: 20,
                  ),
                  label: const Text(
                    'Sign In with Google',
                  )),
              const SizedBox(height: 32.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    String emailRegex =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9- ]+)*$";
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }
}

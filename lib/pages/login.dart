import 'package:bcsantos/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // Create  a global key that uniquely identifies the Form widget
  final GlobalKey<FormState> _formKey = GlobalKey();
  // Create a focus node for the password field
  final FocusNode _focusNodePassword = FocusNode();
  bool _obscurePassword = true;
  // Create text controllers to deal with the text fields
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  // Create a firebase auth instance to use the firebase authentication methods
  final FirebaseAuth _auth = FirebaseAuth.instance;
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the user is already logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const MyHomePage(title: 'BC SANTOS');
    }

    return Scaffold(
        backgroundColor: Colors.white,
        // Here we use a LayoutBuilder to generate different widths depending on the screen size 
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth <= 400) {
              return _buildLayout(50);
            }
            else if (constraints.maxWidth <= 600 && constraints.maxWidth > 400) {
              return _buildLayout(100);
            }
            else if (constraints.maxWidth <= 800 && constraints.maxWidth > 600) {
              return _buildLayout(150);
            }
            else if (constraints.maxWidth <= 1000 && constraints.maxWidth > 800) {
              return _buildLayout(200);
            }
            else if (constraints.maxWidth <= 1200 && constraints.maxWidth > 1000) {
              return _buildLayout(250);
            }
            else if (constraints.maxWidth <= 1400 && constraints.maxWidth > 1200) {
              return _buildLayout(300);
            }
            else if (constraints.maxWidth <= 1500 && constraints.maxWidth > 1400) {
              return _buildLayout(400.0);
            } else if (constraints.maxWidth <= 1700 && constraints.maxWidth > 1500) {
              return _buildLayout(500.0);
            }
            else if (constraints.maxWidth <= 1800 && constraints.maxWidth > 1700) {
              return _buildLayout(600.0);
            }
            else {
              return _buildLayout(700.0);
            }
          } 
    ));
  }

  // This method is used to build the layout for the login screen
  Widget _buildLayout(double hozizontalPadding) {
    return Padding(
      // Add padding to the layout
      padding: EdgeInsets.symmetric(horizontal: hozizontalPadding),
      child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 50),
                  // Add provider to the widget tree to make the application state available to the widgets
                  Provider<ApplicationState>(
                    create: (_) =>
                        ApplicationState(),
                    // Introduce the Form widget    
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          Text(
                            "BC SANTOS",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 60),
                          // Add text fields to the form
                          TextFormField(
                            controller: _controllerUsername,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: "Usuário",
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onEditingComplete: () => _focusNodePassword.requestFocus(),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _controllerPassword,
                            focusNode: _focusNodePassword,
                            obscureText: _obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelText: "Senha",
                              prefixIcon: const Icon(Icons.password_outlined),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: _obscurePassword
                                      ? const Icon(Icons.visibility_outlined)
                                      : const Icon(Icons.visibility_off_outlined)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () async {
                                  // Validate the form
                                  if (_formKey.currentState?.validate() ?? false) {
                                    // Sign in the user with firebase
                                    try {
                                      final userCredential =
                                          await _auth.signInWithEmailAndPassword(
                                        email: _controllerUsername.text,
                                        password: _controllerPassword.text,
                                      );
                                      // If the sign in was successful, go to the home page
                                      if (userCredential.user != null) {
                                        await Future.delayed(Duration.zero).then((value) => GoRouter.of(context).go('/home'));
                                      }
                                    } catch (e) {
                                      // Error handling
                                      if (kDebugMode) {
                                        print('Erro ao fazer login: $e');
                                      }
                                    }
                                  }
                                },
                                child: const Text("Login"),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Deseja entrar sem logar?"),
                                  TextButton(
                                    onPressed: () async {
                                      FirebaseAuth auth = FirebaseAuth.instance;
                                      try {
                                        await auth.signInAnonymously();
                                        // Await the anonymous login
                                        await Future.delayed(Duration.zero).then((value) => GoRouter.of(context).go('/home'));
                                      } catch (e) {
                                        if (kDebugMode) {
                                          print('Erro ao autenticar anonimamente: $e');
                                        }
                                      }
                                    },
                                    child: const Text("Entrar"),
                                  ),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Esqueceu a senha?"),
                                    TextButton(
                                      onPressed: () {
                                        GoRouter.of(context).go('/forgot-password');
                                      },
                                      child: const Text("Resetar"),
                                    ),
                                  ])
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
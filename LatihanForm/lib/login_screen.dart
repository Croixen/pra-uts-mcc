import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:statefulclickcounter/definitions.dart';
import 'package:statefulclickcounter/registration.dart';
import 'package:statefulclickcounter/welcome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  void handleLogin() async {
    try {
      final credential = LoginCredential(username, password);
      final url = Uri.parse('http://localhost/API/login.php');
      final response = await http.post(url, body: jsonEncode(credential));
      if (response.statusCode != 200) {
        final responseBody = jsonDecode(response.body);
        throw Exception(responseBody['message']);
      } else if (response.statusCode == 200 && mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('error, ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://eduqette.com/wp-content/uploads/2022/10/20-1.jpg'),
                      fit: BoxFit.fill)),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onSaved: (value) {
                username = value!;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onSaved: (value) {
                password = value!;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                final form = _formKey.currentState;
                if (form != null && form.validate()) {
                  form.save();
                  handleLogin();
                }
              },
              icon: const Icon(Icons.login),
              label: const Text('Login'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistrationForm()));
              },
              icon: const Icon(Icons.add),
              label: const Text('Registration'),
            )
          ],
        ));
  }
}

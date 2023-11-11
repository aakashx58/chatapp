import 'package:chat_app/utils/snacks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  _signupUser(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(
          {
            "name": _nameController.text,
            "email": _emailController.text,
            "uid": userCredential.user!.uid,
          },
        );
        showSuccessSnack("User created successfully.");
        if (kDebugMode) print(userCredential.user?.email);
      } else {
        showErrorSnack("Something went wrong");
      }
    } on FirebaseAuthException catch (e) {
      showErrorSnack(e.message.toString());
    } catch (e) {
      showErrorSnack(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Signup"),
      ),
      body: Form(
        key: _signupFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
              validator: (value) {
                if (value != null && value.length >= 3) {
                  return null;
                } else {
                  return "Name should be greater than 2 characters.";
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              validator: (value) {
                if (value != null &&
                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                  return null;
                } else {
                  return "Please enter a valid email.";
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              validator: (value) {
                if (value != null && value.length > 7) {
                  return null;
                } else {
                  return "Password should be of minimum 8 characters.";
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_signupFormKey.currentState!.validate()) {
                  _signupUser(_emailController.text, _passwordController.text);
                }
              },
              child: const Text("Sign up"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Already have an account ? Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

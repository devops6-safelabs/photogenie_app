import 'package:flutter/material.dart';
import 'package:photogenie_app/resources/auth_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AuthMethods().signOut(context);
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}

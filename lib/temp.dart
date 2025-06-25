import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmelon Home"),
        backgroundColor: const Color(0xFFE66A6C),
      ),
      body: const Center(
        child: Text("Welcome to Farmelon!"),
      ),
    );
  }
}

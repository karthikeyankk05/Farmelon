// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Widget destinationPage;

  const CustomCard({
    required this.title,
    required this.imagePath,
    required this.destinationPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFFE66A6C); // Your app's primary color

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => destinationPage,
          ),
        );
      },
      child: SizedBox(
        width: 150,
        height: 150,
        child: Card(
          color: themeColor.withOpacity(0.2), // Light shade for background
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: themeColor, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                  color: themeColor.withOpacity(0.85), // Strong background for text
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../nav.dart';
import '../temp.dart';
import '../card.dart';
import 'drone_view.dart';
import 'ferti_calc.dart';
import 'profit_estimate.dart';
import 'weather_box.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //final themeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              // TODO: Navigate to profile
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/logo.jpeg'),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: const [
                  CustomCard(
                    title: 'Drone View',
                    imagePath: 'assets/drone.jpeg',
                    destinationPage: DroneViewPage(),
                  ),
                  CustomCard(
                    title: 'Pest and Diseases',
                    imagePath: 'assets/pest.jpeg',
                    destinationPage: Home(),
                  ),
                  CustomCard(
                    title: 'Fertilizer CALC',
                    imagePath: 'assets/ferti.jpeg',
                    destinationPage: WatermelonCarePage(),
                  ),
                  CustomCard(
                    title: 'Profit Estimate',
                    imagePath: 'assets/profit.jpeg',
                    destinationPage: ProfitEstimate(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const WeatherBox(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}

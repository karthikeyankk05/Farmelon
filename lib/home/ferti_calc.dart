import 'package:flutter/material.dart';

class WatermelonCarePage extends StatefulWidget {
  const WatermelonCarePage({super.key});

  @override
  State<WatermelonCarePage> createState() => _WatermelonCarePageState();
}

class _WatermelonCarePageState extends State<WatermelonCarePage> {
  int _plantCount = 1;

  // Base values per watermelon plant (in grams or ml)
  final double _fertilizerNPK = 25.0;
  final double _urea = 15.0;
  final double _pesticideNeem = 10.0;
  final double _pesticideChlorpyrifos = 5.0;

  double totalNPK = 0.0;
  double totalUrea = 0.0;
  double totalNeem = 0.0;
  double totalChlorpyrifos = 0.0;

  void _calculateRequirements() {
    setState(() {
      totalNPK = _fertilizerNPK * _plantCount;
      totalUrea = _urea * _plantCount;
      totalNeem = _pesticideNeem * _plantCount;
      totalChlorpyrifos = _pesticideChlorpyrifos * _plantCount;
    });
  }

  void _increment() => setState(() => _plantCount++);
  void _decrement() => setState(() {
        if (_plantCount > 1) _plantCount--;
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final softPrimary = theme.colorScheme.primary.withOpacity(0.4); // soft tone

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE66A6C),
        title: const Text('Watermelon Care'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Number of Watermelon Plants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _decrement,
                  icon: Icon(Icons.remove_circle, color: softPrimary),
                ),
                Text(
                  '$_plantCount',
                  style: const TextStyle(fontSize: 24),
                ),
                IconButton(
                  onPressed: _increment,
                  icon: Icon(Icons.add_circle, color: softPrimary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateRequirements,
              style: ElevatedButton.styleFrom(
                backgroundColor: softPrimary,
              ),
              child: const Text(
                'Calculate Requirements',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            _buildRequirementCard("NPK Fertilizer", totalNPK, "grams", softPrimary),
            _buildRequirementCard("Urea", totalUrea, "grams", softPrimary),
            _buildRequirementCard("Neem Oil", totalNeem, "ml", softPrimary),
            _buildRequirementCard("Chlorpyrifos", totalChlorpyrifos, "ml", softPrimary),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grass), label: 'Fertilizer'),
          BottomNavigationBarItem(icon: Icon(Icons.sanitizer), label: 'Pesticides'),
        ],
      ),
    );
  }

  Widget _buildRequirementCard(String label, double amount, String unit, Color iconColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.eco, color: iconColor),
        title: Text(label),
        trailing: Text(
          "${amount.toStringAsFixed(1)} $unit",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

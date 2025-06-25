import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfitEstimate extends StatefulWidget {
  const ProfitEstimate({super.key});

  @override
  State<ProfitEstimate> createState() => _ProfitEstimateState();
}

class _ProfitEstimateState extends State<ProfitEstimate> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _yieldController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  double profit = 0;
  List<double> profitHistory = [];

  void calculateProfit() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final yieldQty = double.tryParse(_yieldController.text) ?? 0;
    final cost = double.tryParse(_costController.text) ?? 0;

    final newProfit = (price * yieldQty) - cost;

    setState(() {
      profit = newProfit;
      profitHistory.add(newProfit);
    });
  }

  List<FlSpot> _getSpots() {
    return List.generate(
      profitHistory.length,
      (index) => FlSpot(index.toDouble(), profitHistory[index]),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _yieldController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final hasGraphData = profitHistory.length > 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Profit Estimation'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 🍉 Logo
            Center(
              child: Image.asset(
                'assets/melon.png',
                height: 100,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Estimate your profit',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Selling Price per Unit (₹)',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => calculateProfit(),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _yieldController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Yield (Units)',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => calculateProfit(),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Cost (₹)',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => calculateProfit(),
            ),
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Estimated Profit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '₹${profit.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: profit >= 0 ? primaryColor : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            if (hasGraphData) ...[
              const Text(
                'Profit History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    borderData: FlBorderData(show: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: _getSpots(),
                        barWidth: 3,
                        color: primaryColor,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],

            const Text(
              'Feedback',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.sentiment_very_dissatisfied),
                  onPressed: () {},
                  color: Colors.redAccent,
                ),
                IconButton(
                  icon: const Icon(Icons.sentiment_neutral),
                  onPressed: () {},
                  color: Colors.amber,
                ),
                IconButton(
                  icon: const Icon(Icons.sentiment_satisfied),
                  onPressed: () {},
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Estimate'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

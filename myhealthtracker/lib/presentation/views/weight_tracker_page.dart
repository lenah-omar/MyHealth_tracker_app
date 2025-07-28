import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightTrackerPage extends StatefulWidget {
  const WeightTrackerPage({super.key});

  @override
  State<WeightTrackerPage> createState() => _WeightTrackerPageState();
}

class _WeightTrackerPageState extends State<WeightTrackerPage> {
  final TextEditingController weightController = TextEditingController();
  List<double> weights = [];

  @override
  void initState() {
    super.initState();
    _loadWeights();
  }

  Future<void> _loadWeights() async {
    final prefs = await SharedPreferences.getInstance();
    final savedWeights = prefs.getStringList('weights') ?? [];
    setState(() {
      weights = savedWeights.map((e) => double.parse(e)).toList();
    });
  }

  Future<void> _addWeight() async {
    if (weightController.text.isEmpty) return;
    double weight = double.parse(weightController.text);
    weights.add(weight);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('weights', weights.map((e) => e.toString()).toList());

    weightController.clear();
    setState(() {});
  }

  void _deleteWeight(int index) {
    weights.removeAt(index);
    _saveWeights();
    setState(() {});
  }

  Future<void> _saveWeights() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('weights', weights.map((e) => e.toString()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تتبع الوزن"),
        backgroundColor: const Color(0xFF4C7EFF),
      ),
      body: SingleChildScrollView( // إضافة SingleChildScrollView
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[50]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "أدخل وزنك",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: "الوزن (كجم)",
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: const Icon(Icons.fitness_center),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addWeight,
                  child: const Text("إضافة وزن"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C7EFF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "الأوزان المدخلة:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200, // تحديد ارتفاع للقائمة
                child: ListView.builder(
                  itemCount: weights.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text("الوزن: ${weights[index]} كجم"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteWeight(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "مخطط الوزن:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                height: 250,
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(show: true),
                    gridData: FlGridData(show: false), // تأكد من إخفاء الشبكة
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: const Color(0xFF4C7EFF)), // لون الحدود
                    ),
                    minX: 0,
                    maxX: weights.length.toDouble(),
                    minY: weights.isNotEmpty ? weights.reduce((a, b) => a < b ? a : b) - 1 : 0,
                    maxY: weights.isNotEmpty ? weights.reduce((a, b) => a > b ? a : b) + 1 : 100,
                    lineBarsData: [
                      LineChartBarData(
                        spots: weights.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value);
                        }).toList(),
                        isCurved: true,
                        color: const Color(0xFF4C7EFF), // استخدام اللون المحدد
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
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
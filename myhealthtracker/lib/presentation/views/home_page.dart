import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لوحة التحكم"),
        backgroundColor: const Color(0xFF4C7EFF),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "مرحباً بك في MyHealth Tracker!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C7EFF),
                  ),
                ),
                const SizedBox(height: 40),
                _buildCard(
                  context,
                  icon: Icons.cloud_upload,
                  label: "رفع صورة",
                  onPressed: () => Navigator.pushNamed(context, '/upload'),
                ),
                const SizedBox(height: 20),
                _buildCard(
                  context,
                  icon: Icons.track_changes,
                  label: "تتبع الوزن",
                  onPressed: () => Navigator.pushNamed(context, '/weight_tracker'),
                ),
                const SizedBox(height: 20),
                _buildCard(
                  context,
                  icon: Icons.nights_stay,
                  label: "متابعة النوم",
                  onPressed: () => Navigator.pushNamed(context, '/sleep_tracker'),
                ),
                const SizedBox(height: 20),
                _buildCard(
                  context,
                  icon: Icons.alarm,
                  label: "التذكيرات اليومية",
                  onPressed: () => Navigator.pushNamed(context, '/reminders'),
                ),
                const SizedBox(height: 20),
                _buildCard(
                  context,
                  icon: Icons.lightbulb,
                  label: "نصائح صحية",
                  onPressed: () => Navigator.pushNamed(context, '/health_tips'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFF4C7EFF),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
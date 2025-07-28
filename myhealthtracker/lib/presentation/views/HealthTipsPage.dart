import 'package:flutter/material.dart';

class HealthTipsPage extends StatelessWidget {
  const HealthTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tips = [
      {
        'title': 'شرب الماء بانتظام',
        'image': 'assets/water.jpg',
        'description': 'شرب الماء يساعد في الحفاظ على الترطيب الجيد.'
      },
      {
        'title': 'تناول الفواكه والخضروات',
        'image': 'assets/fruits_vegetables.jpg',
        'description': 'الغنية بالفيتامينات والمعادن.'
      },
      {
        'title': 'ممارسة الرياضة بانتظام',
        'image': 'assets/exercise.jpg',
        'description': 'تساعد في تحسين الصحة العامة.'
      },
      {
        'title': 'الحصول على قسط كافٍ من النوم',
        'image': 'assets/sleep.jpg',
        'description': 'يساعد في تعزيز التركيز والذاكرة.'
      },
      {
        'title': 'تجنب الأطعمة السريعة',
        'image': 'assets/junk_food.jpg',
        'description': 'تجنب الأطعمة غير الصحية للحفاظ على الوزن.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("نصائح صحية"),
        backgroundColor: const Color(0xFF4C7EFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: tips.length,
          itemBuilder: (context, index) {
            return _buildTipCard(tips[index]);
          },
        ),
      ),
    );
  }

  Widget _buildTipCard(Map<String, String> tip) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Image.asset(
            tip['image']!,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // محاذاة النصوص في المنتصف
              children: [
                Text(
                  tip['title']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // محاذاة النص إلى المنتصف
                ),
                const SizedBox(height: 8),
                Text(
                  tip['description']!,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center, // محاذاة النص إلى المنتصف
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
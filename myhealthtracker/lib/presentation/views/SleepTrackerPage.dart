import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepTrackerPage extends StatefulWidget {
  const SleepTrackerPage({super.key});

  @override
  State<SleepTrackerPage> createState() => _SleepTrackerPageState();
}

class _SleepTrackerPageState extends State<SleepTrackerPage> {
  final TextEditingController _hoursController = TextEditingController();
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _sleepData = [];

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveSleepData() {
    if (_hoursController.text.isNotEmpty && _selectedDate != null) {
      setState(() {
        _sleepData.add({
          'date': _selectedDate!,
          'hours': int.tryParse(_hoursController.text) ?? 0, // استخدام tryParse للتأكد من عدم الخطأ
        });
        _hoursController.clear();
        _selectedDate = null;
      });
    }
  }

  int getTotalSleepHours() {
    return _sleepData.fold(0, (total, item) => total + (item['hours'] as int)); // تأكد من أن item['hours'] هو int
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("متابعة النوم"),
        backgroundColor: const Color(0xFF4C7EFF),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "تتبع نومك",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                "يمكنك إدخال عدد ساعات النوم الخاصة بك هنا.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDate == null
                            ? "اختر تاريخ النوم"
                            : DateFormat.yMd().format(_selectedDate!),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _hoursController,
                decoration: InputDecoration(
                  labelText: "عدد ساعات النوم",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSleepData,
                child: const Text("حفظ"),
              ),
              const SizedBox(height: 20),
              Text(
                "إجمالي ساعات النوم: ${getTotalSleepHours()} ساعة",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _sleepData.length,
                  itemBuilder: (context, index) {
                    final item = _sleepData[index];
                    return ListTile(
                      title: Text(
                        "${DateFormat.yMd().format(item['date'])}: ${item['hours']} ساعة",
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
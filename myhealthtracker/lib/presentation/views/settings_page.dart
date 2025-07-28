import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'العربية';
  bool _notificationsEnabled = false;
  String _selectedUnit = 'كيلوجرام';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'العربية';
      _notificationsEnabled = prefs.getBool('notifications') ?? false;
      _selectedUnit = prefs.getString('unit') ?? 'كيلوجرام';
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  Future<void> _changeLanguage(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value!);
    setState(() {
      _selectedLanguage = value;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _changeUnit(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('unit', value!);
    setState(() {
      _selectedUnit = value;
    });
  }

  Future<void> _resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // إعادة تعيين جميع الإعدادات
    _loadPreferences(); // إعادة تحميل الإعدادات
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الإعدادات"),
        backgroundColor: const Color(0xFF4C7EFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text("الوضع الليلي"),
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),
            const SizedBox(height: 20),
            const Text(
              "اختيار اللغة",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedLanguage,
              icon: const Icon(Icons.arrow_drop_down),
              isExpanded: true,
              items: <String>['العربية', 'English']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: _changeLanguage,
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text("تفعيل الإشعارات"),
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
            ),
            const SizedBox(height: 20),
            const Text(
              "اختيار وحدة القياس",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedUnit,
              icon: const Icon(Icons.arrow_drop_down),
              isExpanded: true,
              items: <String>['كيلوجرام', 'باوند']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: _changeUnit,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetSettings,
              child: const Text("إعادة تعيين الإعدادات",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // لون الزر
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "معلومات حول التطبيق",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "هذا التطبيق يساعدك في تتبع صحتك وتحقيق أهدافك.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
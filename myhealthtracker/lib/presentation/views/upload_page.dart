import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _selectedImage;
  bool _isUploading = false;
  String? _uploadedImageUrl;
  String? _nutritionInfo;

  final TextEditingController _nutritionController = TextEditingController();
  List<String> _mealSuggestions = [];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    setState(() => _isUploading = true);

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final supabase = Supabase.instance.client;

      await supabase.storage.from('uploads').upload(fileName, _selectedImage!);
      final url = supabase.storage.from('uploads').getPublicUrl(fileName);

      setState(() {
        _uploadedImageUrl = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم رفع الصورة بنجاح")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ في الرفع: $e")),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _suggestMeals() {
    if (_nutritionInfo != null && _nutritionInfo!.isNotEmpty) {
      List<String> suggestions = getMealSuggestions(_nutritionInfo!);
      setState(() {
        _mealSuggestions = suggestions;
      });
    }
  }

  List<String> getMealSuggestions(String foodItem) {
    final Map<String, List<String>> healthyMealSuggestions = {
      "تفاح": ["سلطة فواكه", "عصير تفاح طبيعي"],
      "موز": ["سموذي موز", "فطائر موز"],
    };
    return healthyMealSuggestions[foodItem] ?? ["لا توجد اقتراحات متاحة."];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("رفع صورة"),
        backgroundColor: const Color(0xFF4C7EFF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center( // إضافة Center هنا لتمركز العناصر
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 200)
                  : const Icon(Icons.image, size: 100, color: Colors.grey),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("اختر صورة"),
              ),
              const SizedBox(height: 16),
              _isUploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _uploadImage,
                      child: const Text("رفع الصورة"),
                    ),
              const SizedBox(height: 16),
              if (_uploadedImageUrl != null) ...[
                Text("رابط الصورة:"),
                SelectableText(_uploadedImageUrl!),
                const SizedBox(height: 16),
                TextField(
                  controller: _nutritionController,
                  decoration: InputDecoration(
                    labelText: "أدخل المعلومات الغذائية",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _nutritionInfo = _nutritionController.text;
                    });
                    _suggestMeals(); // دعوة الاقتراح
                  },
                  child: const Text("تأكيد المعلومات الغذائية"),
                ),
                if (_nutritionInfo != null) ...[
                  const SizedBox(height: 16),
                  Text("المعلومات الغذائية المدخلة:"),
                  Text(_nutritionInfo!),
                ],
                if (_mealSuggestions.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text("اقتراحات للوجبات:"),
                  for (var suggestion in _mealSuggestions)
                    Text("- $suggestion"),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
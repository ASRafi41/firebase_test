import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItemFullScreen extends StatefulWidget {
  const AddItemFullScreen({super.key});

  @override
  State<AddItemFullScreen> createState() => _AddItemFullScreenState();
}

class _AddItemFullScreenState extends State<AddItemFullScreen> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _subTitleTextController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> uploadCard() async {
    try {
      final data = await FirebaseFirestore.instance.collection("tasks").add({
        "title": _titleTextController.text,
        "subTitle": _subTitleTextController.text,
        "date": DateTime.now(),
      });
      print("ID = ${data.id}");
    }
    catch (e) {
      print("Exception is $e");
    }
  }

  void _handleSubmit() {
    final titleText = _titleTextController.text.trim();
    final subTitleText = _subTitleTextController.text.trim();
    if (titleText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select image and enter text')),
      );
      return;
    }

    uploadCard();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Successful Updated\nTitle: $titleText \nSubTitle: $subTitleText')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add new iteam')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                  color: Colors.grey[200],
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
                    : const Center(child: Text('Tap to pick an image')),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleTextController,
              decoration: const InputDecoration(
                labelText: 'Enter title text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _subTitleTextController,
              decoration: const InputDecoration(
                labelText: 'Enter sub-title text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                _handleSubmit();
              },
            ),
          ],
        ),
      ),
    );
  }
}

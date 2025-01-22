import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadNewsScreen extends StatefulWidget {
  @override
  _UploadNewsScreenState createState() => _UploadNewsScreenState();
}

class _UploadNewsScreenState extends State<UploadNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _category;
  File? _imageFile;
  bool _isUploading = false;

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Fungsi untuk mengunggah berita ke Firestore
  Future<void> _uploadNews() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap pilih gambar untuk berita!')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Unggah gambar ke Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('news_images/${DateTime.now().toIso8601String()}');
      final uploadTask = await storageRef.putFile(_imageFile!);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      // Simpan data berita ke Firestore
      await FirebaseFirestore.instance.collection('news').add({
        'title': _titleController.text,
        'content': _contentController.text,
        'category': _category,
        'imageUrl': imageUrl,
        'date': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berita berhasil diunggah!')),
      );

      // Reset form setelah berhasil
      _formKey.currentState!.reset();
      _titleController.clear();
      _contentController.clear();
      setState(() {
        _category = null;
        _imageFile = null;
        _isUploading = false;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah berita: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Berita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input judul
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Judul Berita'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Input isi berita
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: 'Isi Berita'),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Isi berita tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Pilihan kategori
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: InputDecoration(labelText: 'Kategori'),
                  items: ['Anime', 'E-sport']
                      .map((category) => DropdownMenuItem(
                          value: category, child: Text(category)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Harap pilih kategori';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Pilihan gambar
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _imageFile == null
                        ? Center(child: Text('Pilih Gambar'))
                        : Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 16),

                // Tombol unggah
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _uploadNews,
                    child: _isUploading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Unggah Berita'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

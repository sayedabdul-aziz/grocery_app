import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/core/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';

class AddRestuarentView extends StatefulWidget {
  const AddRestuarentView({super.key});

  @override
  _AddRestuarentViewScreenState createState() =>
      _AddRestuarentViewScreenState();
}

class _AddRestuarentViewScreenState extends State<AddRestuarentView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? _imagePath;
  File? file;
  String? coverUrl;

  uploadImageToFireStore(File image, String imageName) async {
    Reference ref =
        FirebaseStorage.instanceFor(bucket: 'gs://hotel-wave.appspot.com')
            .ref()
            .child('restaurents/${DateTime.now().toIso8601String()}$imageName');
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putFile(image, metadata);
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        file = File(pickedFile.path);
      });
    }
    coverUrl = await uploadImageToFireStore(file!, 'cover');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Restaurent'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomButton(
          text: 'Add Restaurent',
          onTap: () {
            if (formKey.currentState!.validate() && coverUrl != null) {
              var id = DateTime.now().toString();
              FirebaseFirestore.instance.collection("restaurents").doc(id).set({
                "id": id,
                "name": _nameController.text,
                "location": _addressController.text,
                "contactNumber": _contactController.text,
                "email": _emailController.text,
                "cover": coverUrl,
                "description": _descController.text,
                "rating": 4.0,
                "reviews": [
                  {
                    "name": "Ahmed Ali",
                    "rate": 4.0,
                    "comment": "Great experience, friendly staff!"
                  },
                  {
                    "name": "Mohammed Ali",
                    "rate": 5.0,
                    "comment": "Absolutely loved my stay. Highly recommended!"
                  }
                ]
              });
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const Text('Cover'),
              const Gap(5),
              InkWell(
                onTap: () {
                  _pickImage();
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: _imagePath == null
                      ? BoxDecoration(
                          border: Border.all(color: AppColors.shadeColor),
                          borderRadius: BorderRadius.circular(10),
                        )
                      : BoxDecoration(
                          border: Border.all(color: AppColors.shadeColor),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(_imagePath!)))),
                  child: Icon(
                    Icons.add,
                    color: AppColors.white,
                  ),
                ),
              ),
              const Gap(16),
              const Text('Restaurent Name'),
              const Gap(5),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Restaurent Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '* Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Description'),
              const Gap(5),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '* Required';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              const SizedBox(height: 16.0),
              const Text('Location'),
              const Gap(5),
              TextFormField(
                controller: _addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '* Required';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: 'Location'),
              ),
              const SizedBox(height: 16.0),
              const Text('Contact Number'),
              const Gap(5),
              TextFormField(
                controller: _contactController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '* Required';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: 'Contact Number'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),
              const Text('Email'),
              const Gap(5),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '* Required';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: 'Email'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }
}

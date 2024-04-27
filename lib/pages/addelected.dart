import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tp_election/pages/candidates.dart';
import 'package:tp_election/pages/showelect.dart';

class AddElectPage extends StatefulWidget {
  @override
  _AddElectPageState createState() => _AddElectPageState();
}

class _AddElectPageState extends State<AddElectPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _surname = '';
  String _party = '';
  String _bio = '';
  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      final candidate = Candidate(
        id: 0,
        name: _name,
        surname: _surname,
        party: _party,
        bio: _bio,
        imageUrl: '',
      );

      final requestBody = {
        'name': _name,
        'surname': _surname,
        'party': _party,
        'bio': _bio,
      };

      final jsonBody = json.encode(requestBody);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      request.headers['Content-Type'] = 'application/json';
      request.fields['data'] = jsonBody;

      if (_image != null) {
        final imageStream = http.ByteStream(_image!.openRead());
        final imageLength = await _image!.length();
        final imageMultipartFile = http.MultipartFile(
          'image',
          imageStream,
          imageLength,
          filename: _image!.path.split('/').last,
        );
        request.files.add(imageMultipartFile);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final createdCandidate = Candidate.fromJson(json.decode(responseBody));
        Navigator.pop(context, createdCandidate);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add candidate')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Candidate'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Candidate image
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null ? const Icon(Icons.camera_alt) : null,
                  ),
                ),
                // Name
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                // Surname
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Surname'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a surname';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _surname = value!;
                  },
                ),
                // Party
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Party'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a party';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _party = value!;
                  },
                ),
                // Bio
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Biography'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a biography';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _bio = value!;
                  },
                ),
                // Add button
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

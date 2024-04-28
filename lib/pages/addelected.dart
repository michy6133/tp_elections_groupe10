import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'candidates.dart';

class AddElectPage extends StatefulWidget {
  const AddElectPage({super.key});

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

      assert(_name != null);
      assert(_surname != null);
      assert(_party != null);
      assert(_bio != null);

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
      final client = http.Client();

      try {
        final response = await client.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          headers: {'Content-Type': 'application/json'},
          body: jsonBody,
        );

        if (response.statusCode == 201) {
          final createdCandidate = Candidate.fromJson(json.decode(response.body));
          Navigator.pop(context, createdCandidate);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add candidate: Error ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error: $e'); // Imprimer l'exception dans la console
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error: Please check your internet connection')),
        );
      } finally {
        client.close();
        setState(() {
          _isLoading = false;
        });
      }
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
                  onPressed: _image == null ? null : _submitForm,
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

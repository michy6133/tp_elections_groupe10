import 'dart:io';
import 'package:flutter/material.dart';
import 'addelected.dart';

class ShowElectPage extends StatefulWidget {
  const ShowElectPage({super.key});

  @override
  _ShowElectPageState createState() => _ShowElectPageState();
}

class _ShowElectPageState extends State<ShowElectPage> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _candidates = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  dynamic _addCandidate(String name, String party, File image) {
    setState(() {
      _candidates.add({
        'name': name,
        'party': party,
        'image': image,
      });
    });
    return null; // retourne null pour satisfaire le type de retour dynamic
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Samiat'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[300],
        child: Column(
          children: [
            // Horizontal navigation bar
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildNavigationButton('Presidential'),
                  _buildNavigationButton('Governship'),
                  _buildNavigationButton('LGDA'),
                ],
              ),
            ),
            // Candidates
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Candidates: ${_candidates.length}'),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddElectPage(
                            addCandidate: _addCandidate, // passe la fonction _addCandidate à la deuxième page
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),

                ],
              ),
            ),
            // Display candidates
            Expanded(
              child: ListView.builder(
                itemCount: _candidates.length,
                itemBuilder: (context, index) {
                  final candidate = _candidates[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(candidate['image']),
                    ),
                    title: Text(candidate['name']),
                    subtitle: Text(candidate['party']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Vote',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildNavigationButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(title),
      ),
    );
  }
}

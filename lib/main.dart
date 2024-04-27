import 'package:flutter/material.dart';
import 'package:tp_election/pages/showelect.dart';
import 'package:tp_election/pages/candidates.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultCandidate = Candidate(
      id: 0,
      name: '',
      surname: '',
      party: '',
      bio: '',
      imageUrl: '',
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShowElectPage(candidate: defaultCandidate),
    );
  }
}

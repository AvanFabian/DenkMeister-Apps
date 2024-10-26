import 'package:flutter/material.dart';

class Quizdashboard extends StatelessWidget {
  const Quizdashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Full width SizedBox with another SizedBox inside
            SizedBox(
              width: double.infinity,
              height: 100.0,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: SizedBox(
                    width: 100.0,
                    height: 50.0,
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0), // Vertical gap
            // Text below the nested SizedBox
            const Text(
              'This is a text below the nested SizedBox',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0), // Vertical gap
            // Card with horizontal layout inside
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    // SizedBox inside Card
                    SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: Container(
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 20.0), // Horizontal gap
                    // Column with 2 Text widgets
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Title Text',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0), // Vertical gap between texts
                        Text(
                          'Subtitle Text',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20.0), // Horizontal gap
                    // Another SizedBox inside Card
                    SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: Container(
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
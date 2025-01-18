import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tebak_gambar/library_items.dart';
import 'package:tebak_gambar/quiz_home.dart';
import 'package:tebak_gambar/pengaturan.dart';
import 'package:tebak_gambar/models/kosakatamodel.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
    List<Kosakata> _kosakata = [];

    @override
    void initState() {
      super.initState();
      loadQuestions().then((kosakata) {
        setState(() {
          _kosakata = kosakata;
        });
      });
    }

    Future<List<Kosakata>> loadQuestions() async {
    final data = await rootBundle.loadString('assets/utils/kosakata.json');
    final List<dynamic> jsonResult = json.decode(data);
    return jsonResult.map((json) => Kosakata.fromJson(json)).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Scrollable content area
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Header Container
                Container(
                  width: double.infinity,
                  height: 104.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFF007BFF),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(-.0),
                      bottomRight: Radius.circular(-.0),
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 48.0),
                          child: Image.asset(
                            'assets/logodenkmeister-2.png',
                            width: 200.0,
                            height: 74.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Kosakata Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Kosakata',
                      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Color(0xFF181818)),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Search Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 17.0,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 26.0,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF000000).withOpacity(0.05), // Light gray background
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // List of Quizzes Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F2FF),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: List.generate(8, (index) {
                        final List<String> imagePaths = [
                          'assets/q1.png',
                          'assets/q2.png',
                          'assets/q3.png',
                          'assets/q4.png',
                          'assets/q4.png',
                          'assets/q4.png',
                          'assets/q4.png',
                          'assets/q4.png',
                        ];

                        // final List<String> quizNames = [
                        //   'Number & Colors',
                        //   'Family Members',
                        //   'Days of the Week and Months',
                        //   'Foods and Drinks',
                        //   'Basic Verbs',
                        //   'Everyday Items',
                        //   'Common Animals',
                        //   'Buildings and Places in Town',
                        //   'Basic Greetings and Phrases',
                        //   'Adjectives & Adverbs',
                        // ];

                        // final List<String> quizDescriptions = [
                        //   '200 Words',
                        //   '100 words',
                        //   '300 words',
                        //   '100 words',
                        //   '100 words',
                        //   '100 words',
                        //   '100 words',
                        //   '100 words',
                        //   '100 words',
                        //   '100 words',
                        // ];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      // builder: (context) => DetailLibraryItems(quizName: quizNames[index]),
                                      builder: (context) => DetailLibraryItems(kategori: _kosakata[index].kategori),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 42.0,
                                      height: 42.0,
                                      child: Image.asset(
                                        imagePaths[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            // quizNames[index],
                                            _kosakata[index].kategori,
                                            style: const TextStyle(fontSize: 16.0),
                                          ),
                                          Text(
                                            // quizDescriptions[index],
                                            '${_kosakata[index].numberofWords} Words',
                                            style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (index < 7) // Add a bottom border except for the last item
                              Divider(
                                color: Colors.grey.withOpacity(0.5),
                                thickness: 1.0,
                                indent: 16.0,
                                endIndent: 16.0,
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 80.0), // Add spacing to account for the bottom button
              ],
            ),
          ),

          // Bottom Positioned Button Container
          Positioned(
            bottom: 32.0,
            left: 56.0, // Adjusted for better alignment
            right: 56.0,
            child: Container(
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Quizdashboard()),
                      );
                    },
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.task, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Library()),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Settings()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tebak_gambar/models/kosakatamodel.dart';

class DetailLibraryItems extends StatefulWidget {
  final String Kategori;

  const DetailLibraryItems({super.key, required this.Kategori});

  @override
  State<DetailLibraryItems> createState() => _DetailLibraryItemsState();
}

class _DetailLibraryItemsState extends State<DetailLibraryItems> {
  List<Kosakata> _categoryWords = [];

  @override
  void initState() {
    super.initState();
    loadCategoryWords();
  }

  Future<void> loadCategoryWords() async {
    try {
      final data = await rootBundle.loadString('assets/utils/kosakata.json');
      final List<dynamic> jsonResult = json.decode(data);
      final List<Kosakata> allWords = jsonResult.map((json) => Kosakata.fromJson(json)).toList();

      setState(() {
        // Filter words for the selected category
        _categoryWords = allWords.where((word) => word.Kategori == widget.Kategori).toList();
      });
    } catch (e) {
      print("Error loading category words: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF007BFF),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24.0, // Set the size of the icon
              color: Colors.white, // Set the color of the icon to white
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Row(
          children: [
            const Spacer(), // Pushes the title to the right
            Text(
              widget.Kategori,
              style: const TextStyle(
                fontSize: 22.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Scrollable content area
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 24.0),

                // List of Quizzes Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: List.generate(_categoryWords.length, (index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              // vertical divider
                                              Container(
                                                height: 40.0,
                                                margin: const EdgeInsets.only(right: 8.0),
                                                width: 2.0,
                                                color: Colors.black26,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _categoryWords[index].bahasaJerman,
                                                    style: const TextStyle(fontSize: 16.0, color: Color(0xFF848484), fontWeight: FontWeight.bold),
                                                  ),
                                                  // const SizedBox(height: 2.0),
                                                  Text(
                                                    _categoryWords[index].bahasaIndonesia,
                                                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
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
                ),
                const SizedBox(height: 80.0), // Add spacing to account for the bottom button
              ],
            ),
          ),
        ],
      ),
    );
  }
}

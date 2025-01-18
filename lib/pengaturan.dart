import 'package:flutter/material.dart';
import 'package:tebak_gambar/quiz_home.dart';
import 'package:tebak_gambar/library_home.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isSoundOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
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
                            'Pengaturan',
                            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      // List of Quizzes Section
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                        child: Column(
                          children: List.generate(3, (index) {
                            // List of image paths
                            final imagePaths = [
                              'assets/pengaturan_icon/Export_fill.png',
                              'assets/pengaturan_icon/sound_max_fill.png',
                              'assets/pengaturan_icon/Group.png',
                            ];

                            final List<String> settingNames = [
                              'Share',
                              'Sound',
                              'About Us',
                            ];

                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
                              child: Card(
                                elevation: 4.0,
                                color: Colors.blue[50], // Set the background color here
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 16.0, right: 16.0),
                                  child: Row(
                                    children: <Widget>[
                                      // SizedBox inside Card
                                      SizedBox(
                                        width: 36.0,
                                        height: 36.0,
                                        child: Image.asset(
                                          imagePaths[index], // Use different image for each card
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // Rest of the card content
                                      const SizedBox(width: 16.0), // Horizontal gap
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              settingNames[index],
                                              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                            ),
                                            if (settingNames[index] == 'Sound')
                                              Switch(
                                                value: _isSoundOn,
                                                onChanged: (bool value) {
                                                  // Add your logic here
                                                  setState(() {
                                                    _isSoundOn = value;
                                                  });
                                                },
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
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
                          icon: const Icon(Icons.home, color: Colors.black, size: 30.0),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Quizdashboard()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.task, color: Colors.black, size: 30.0),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Library()),
                            );
                          },
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.settings, color: Colors.white, size: 30.0),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Library()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

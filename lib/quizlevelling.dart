import 'package:flutter/material.dart';
import 'package:tebak_gambar/cocok_kata.dart';
import 'package:tebak_gambar/kalimat_rumpang.dart';
// import 'package:tebak_gambar/quizprogressmanager.dart';
import 'package:tebak_gambar/susun_kalimat.dart';
import 'package:tebak_gambar/tebak_gambar.dart';

class QuizLevelling extends StatefulWidget {
  final String quizName;
  final String difficulty;

  const QuizLevelling({super.key, required this.quizName, required this.difficulty});

  @override
  _QuizLevellingState createState() => _QuizLevellingState();
}

class _QuizLevellingState extends State<QuizLevelling> {
  // int _answeredCount = 0;

  void _onProgressUpdate(int answeredCount) {
    // Update progress in this page if needed
    print('Progress updated: $answeredCount questions answered.');
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
              size: 24.0,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Pilih Level',
                style: TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 56.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      'assets/jalur-leveling.png',
                      height: 1100.0,
                      fit: BoxFit.cover,
                    ),
                    ...List.generate(7, (index) {
                      List<Map<String, double>> positions = [
                        {'top': -30.0, 'left': -5.0},
                        {'top': 40.0, 'right': 4.0},
                        {'top': 180.0, 'left': 28.0},
                        {'top': 310.0, 'right': -20.0},
                        {'top': 405.0, 'left': 14.0},
                        {'top': 540.0, 'right': 18.0},
                        {'top': 660.0, 'left': 32.0},
                      ];

                      return Positioned(
                        top: positions[index]['top'],
                        left: positions[index].containsKey('left') ? positions[index]['left'] : null,
                        right: positions[index].containsKey('right') ? positions[index]['right'] : null,
                        child: GestureDetector(
                          onTap: () {
                            Widget destinationPage;
                            if (widget.quizName == "Tebak Gambar") {
                              destinationPage = TebakGambar(currentlevel: '${index + 1}', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty);
                            } else if (widget.quizName == "Cocok Kata") {
                              destinationPage = CocokKata(currentlevel: '${index + 1}', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty);
                            } else if (widget.quizName == "Kalimat Rumpang") {
                              destinationPage = KalimatRumpang(currentlevel: '${index + 1}', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty);
                            } else if (widget.quizName == "Susun Kalimat") {
                              destinationPage = SusunKalimat(currentlevel: '${index + 1}', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty);
                            } else {
                              destinationPage =
                                  TebakGambar(currentlevel: '${index + 1}', onProgressUpdate: _onProgressUpdate, difficulty: widget.difficulty);
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => destinationPage),
                            );
                          },
                          child: CircleAvatar(
                            radius: 40.0,
                            backgroundColor: const Color(0xFFD9D9D9),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

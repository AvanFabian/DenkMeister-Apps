import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tebak_gambar/quizdashboard.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _currentIndex = 0;

  final List<Widget> _slides = [
    _buildSlide('Selamat Datang \n di Denkmaster!', 'Mulailah Petualangan Bahasa \n Jermanmu di Sini! '),
    _buildSlide('Belajar Jadi Mudah \n Bersama Kami', 'Dapatkan Pengalaman Belajar \n yang Seru dan Menarik!'),
    _buildSlide('Nikmati Keseruan \n Belajar Bahasa', 'Belajar Sambil Bermain, Pilih Kuis \n Favoritmu!'),
  ];

  static Widget _buildSlide(String title, String description) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 285.0,
            height: 250.0,
            color: Colors.blue,
          ),
          const SizedBox(height: 54.0),
          Text(
            title,
            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center, // Center the title text
          ),
          const SizedBox(height: 18.0),
          Text(
            description,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center, // Center the description text
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: CarouselSlider(
              items: _slides,
              options: CarouselOptions(
                height: 550.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _slides.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => CarouselSlider(
                  items: _slides,
                  options: CarouselOptions(
                    initialPage: entry.key,
                  ),
                ),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withOpacity(_currentIndex == entry.key ? 0.9 : 0.4),
                  ),
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 72.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 275.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      backgroundColor: Colors.black54,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Quizdashboard()),
                        );
                      },
                      child: const Text(
                        'Mulai',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 275.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      backgroundColor: Colors.white70,
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
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

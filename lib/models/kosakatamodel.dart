class Kosakata {
  final int numberofWords;
  final String bahasaJerman;
  final String bahasaIndonesia;
  final String kategori;

  Kosakata({
    required this.numberofWords,
    required this.bahasaJerman,
    required this.bahasaIndonesia,
    required this.kategori,
  });

  factory Kosakata.fromJson(Map<String, dynamic> json) {
    return Kosakata(
      numberofWords: json['numberofWords'],
      bahasaJerman: json['bahasaJerman'],
      bahasaIndonesia: json['bahasaIndonesia'],
      kategori: json['kategori'],
    );
  }
}

class Kosakata {
  final int numberofWords;
  final String bahasaJerman;
  final String bahasaIndonesia;
  final String Kategori;

  Kosakata({
    required this.numberofWords,
    required this.bahasaJerman,
    required this.bahasaIndonesia,
    required this.Kategori,
  });

  factory Kosakata.fromJson(Map<String, dynamic> json) {
    return Kosakata(
      numberofWords: json['numberofWords'],
      bahasaJerman: json['bahasaJerman'],
      bahasaIndonesia: json['bahasaIndonesia'],
      Kategori: json['Kategori'],
    );
  }
}

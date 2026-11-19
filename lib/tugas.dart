class Tugas {
  String id;
  String judul;
  String matakuliah;
  String deskripsi;
  String tenggat;
  String prioritas;
  bool selesai;

  Tugas({
    required this.id,
    required this.judul,
    required this.matakuliah,
    required this.deskripsi,
    required this.tenggat,
    required this.prioritas,
    this.selesai = false,
  });
}

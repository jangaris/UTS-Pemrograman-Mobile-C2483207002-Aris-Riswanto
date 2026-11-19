import 'package:flutter/material.dart';

import 'tugas.dart';

class Halamanformtugas extends StatefulWidget {
  final Tugas? tugasUbah;
  const Halamanformtugas({super.key, this.tugasUbah});

  @override
  State<Halamanformtugas> createState() => _HalamanformtugasState();
}

class _HalamanformtugasState extends State<Halamanformtugas> {
  final formkey = GlobalKey<FormState>();
  late TextEditingController judulController;
  late TextEditingController mataKuliahController;
  late TextEditingController deskripsiController;
  late TextEditingController tenggatController;

  // Samakan huruf kapital awal dengan pilihan di DropdownButtonFormField
  String prioritasPilihan = 'Sedang';
  bool selesaiStatus = false;

  final List<String> daftarPrioritas = ['Rendah', 'Sedang', 'Tinggi'];

  @override
  void initState() {
    super.initState();

    judulController = TextEditingController(
      text: widget.tugasUbah?.judul ?? '',
    );
    mataKuliahController = TextEditingController(
      text: widget.tugasUbah?.matakuliah ?? '',
    );
    deskripsiController = TextEditingController(
      text: widget.tugasUbah?.deskripsi ?? '',
    );
    tenggatController = TextEditingController(
      text: widget.tugasUbah?.tenggat ?? '',
    );

    if (widget.tugasUbah != null) {
      // Cegah crash jika data lama memiliki huruf kecil/tidak sesuai daftar
      final prioritasLama = widget.tugasUbah!.prioritas;
      final cocok = daftarPrioritas.firstWhere(
        (item) => item.toLowerCase() == prioritasLama.toLowerCase(),
        orElse: () => 'Sedang',
      );
      prioritasPilihan = cocok;
      selesaiStatus = widget.tugasUbah!.selesai;
    }
  }

  @override
  void dispose() {
    judulController.dispose();
    mataKuliahController.dispose();
    deskripsiController.dispose();
    tenggatController.dispose();
    super.dispose();
  }

  String? validasiTanggal(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Tanggal tenggat tidak boleh kosong';
    }

    final cocokFormat = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$').firstMatch(text);
    if (cocokFormat == null) {
      return 'Format harus DD-MM-YYYY (contoh: 25-11-2026)';
    }

    final hari = int.parse(cocokFormat.group(1)!);
    final bulan = int.parse(cocokFormat.group(2)!);
    final tahun = int.parse(cocokFormat.group(3)!);

    if (bulan < 1 || bulan > 12 || hari < 1 || hari > 31) {
      return 'Tanggal tidak valid atau bukan tanggal nyata';
    }

    final tanggal = DateTime(tahun, bulan, hari);
    if (tanggal.year != tahun ||
        tanggal.month != bulan ||
        tanggal.day != hari) {
      return 'Tanggal tidak nyata (contoh: 31-02-2026 tidak valid)';
    }

    return null;
  }

  void simpanData() {
    if (formkey.currentState!.validate()) {
      final tugashasil = Tugas(
        id:
            widget.tugasUbah?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        judul: judulController.text.trim(),
        matakuliah: mataKuliahController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        tenggat: tenggatController.text.trim(),
        prioritas: prioritasPilihan,
        selesai: selesaiStatus,
      );
      Navigator.pop(context, tugashasil);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = widget.tugasUbah != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Ubah Tugas' : 'Tambah Tugas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formkey, // Dipindahkan ke Form
          child: ListView(
            children: [
              TextFormField(
                controller: judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tugas tidak boleh kosong';
                  }
                  if (value.trim().length < 3) {
                    return 'Judul minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: mataKuliahController,
                decoration: const InputDecoration(
                  labelText: 'Mata Kuliah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Mata kuliah tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  if (value.trim().length < 10) {
                    return 'Deskripsi minimal 10 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: tenggatController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Tanggal (dd-MM-yyyy)',
                  hintText: 'Contoh: 25-11-2026',
                  border: OutlineInputBorder(),
                ),
                validator: validasiTanggal,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: prioritasPilihan,
                decoration: const InputDecoration(
                  labelText: 'Prioritas',
                  border: OutlineInputBorder(),
                ),
                items: daftarPrioritas
                    .map(
                      (prioritas) => DropdownMenuItem(
                        value: prioritas,
                        child: Text(prioritas),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      prioritasPilihan = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: simpanData,
                child: Text(
                  isEditMode ? 'Simpan Perubahan' : 'Tambah Tugas',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

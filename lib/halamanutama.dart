import 'package:flutter/material.dart';

import 'halamanformtugas.dart';

import 'tugas.dart';
import 'halamandetailtugas.dart';

class Halamanutama extends StatefulWidget {
  const Halamanutama({super.key});

  @override
  State<Halamanutama> createState() => _HalamanutamaState();
}

class _HalamanutamaState extends State<Halamanutama> {
  List<Tugas> daptarTugas = [
    Tugas(
      id: '1',
      judul: 'laporan praktek',
      matakuliah: 'pemograman',
      deskripsi: 'menyusun documentasi',
      tenggat: '10-06-2026',
      prioritas: 'Tinggi',
      selesai: false,
    ),
    Tugas(
      id: '2',
      judul: 'analisis praktek',
      matakuliah: 'pemograman',
      deskripsi: 'menyusun analisis',
      tenggat: '10-06-2028',
      prioritas: 'Sedang',
      selesai: true,
    ),
    Tugas(
      id: '3',
      judul: 'laporan praktek 3D',
      matakuliah: 'pemograman',
      deskripsi: 'menyusun  model 3D',
      tenggat: '10-06-2027',
      prioritas: 'Tinggi',
      selesai: false,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    int totalTugas = daptarTugas.length;
    int tugasSelesai = daptarTugas.where((tSelesai) => tSelesai.selesai).length;
    int tugasBelum = totalTugas - tugasSelesai;
    return Scaffold(
      appBar: AppBar(
        title: Text('TugasKu'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                builInfoCard(' Total |', totalTugas.toString(), Colors.blue),
                builInfoCard(
                  ' Selesai |',
                  tugasSelesai.toString(),
                  Colors.blue,
                ),
                builInfoCard(' Belum ', tugasBelum.toString(), Colors.blue),
              ],
            ),
          ),
          Expanded(
            child: daptarTugas.isEmpty
                ? Center(
                    child: Text('Belum ada tugas', textAlign: TextAlign.center),
                  )
                : ListView.builder(
                    itemCount: daptarTugas.length,
                    itemBuilder: (context, index) {
                      final tugas = daptarTugas[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            tugas.judul,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: tugas.selesai
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 4),
                              Text('MK: ${tugas.matakuliah}'),
                              Text(
                                'Tenggat : ${tugas.tenggat} | Prioritas : ${tugas.prioritas}',
                              ),
                            ],
                          ),
                          trailing: Checkbox(
                            value: tugas.selesai,
                            onChanged: (bool? value) {
                              setState(() {
                                tugas.selesai = value ?? false;
                              });
                            },
                          ),
                          // ini untuk ke halaman DetailTugas
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Halamandetailtugas(tugas: tugas),
                              ),
                            );

                            // jika aada aksi hapus / edit di detail
                            if (result == 'hapus') {
                              setState(() {
                                daptarTugas.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Tugas terhapus')),
                              );
                            } else if (result == "ubah") {
                              setState(() {});
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Tugas? tugasbaru = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Halamanformtugas()),
          );
          if (tugasbaru != null) {
            setState(() {
              daptarTugas.add(tugasbaru);
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('tugas baru di tamabahkan')));
          }
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget builInfoCard(String title, String count, Color color) {
    return Column(children: [Text(title), SizedBox(height: 4), Text(count)]);
  }
}

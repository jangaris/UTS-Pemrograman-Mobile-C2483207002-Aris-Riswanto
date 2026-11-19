import 'package:flutter/material.dart';

import 'halamanformtugas.dart';
import 'tugas.dart';

class Halamandetailtugas extends StatelessWidget {
  final Tugas tugas;
  const Halamandetailtugas({super.key, required this.tugas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('detail tugas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tugas.judul),
                    Divider(height: 24, thickness: 1),
                    _buildDetailItem('mata kuliah', tugas.matakuliah),
                    SizedBox(height: 12),
                    _buildDetailItem('deskripsi', tugas.deskripsi),
                    SizedBox(height: 12),
                    _buildDetailItem('Tenggat', tugas.tenggat),
                    SizedBox(height: 12),
                    _buildDetailItem('Prioritas', tugas.prioritas),
                    SizedBox(height: 12),
                    _buildDetailItem(
                      'Status',
                      tugas.selesai ? 'selesai' : 'belum selesai',
                      statusColor: tugas.selesai ? Colors.green : Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final Tugas? tugasDiperbarui = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Halamanformtugas(tugasUbah: tugas),
                  ),
                );
                if (tugasDiperbarui != null) {
                  tugas.judul = tugasDiperbarui.judul;
                  tugas.matakuliah = tugasDiperbarui.matakuliah;
                  tugas.deskripsi = tugasDiperbarui.deskripsi;
                  tugas.tenggat = tugasDiperbarui.tenggat;
                  tugas.prioritas = tugasDiperbarui.prioritas;
                  tugas.selesai = tugasDiperbarui.selesai;

                  Navigator.pop(context, 'ubah');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Tugas Berhasil Di perbarui")),
                  );
                }
              },
              icon: Icon(Icons.edit),
              label: Text('ubah tugas'),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: Text('kompirmasi'),
                      content: Text('apakah mau hapus'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            Navigator.pop(context, 'hapus');
                          },
                          child: Text('hapus'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.delete),
              label: Text('Hapus tugas'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {Color? statusColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 16),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: statusColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}

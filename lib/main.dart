import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 1. MODEL DATA TUGAS

class Tugas {
  final String judul;
  final String mataKuliah;
  final String tenggat;
  final String catatan;

  Tugas({
    required this.judul,
    required this.mataKuliah,
    required this.tenggat,
    this.catatan = '',
  });
}

// 2. WIDGET UTAMA APLIKASI

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Tugas Kuliah',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HalamanDaftarTugas(),
    );
  }
}

// 3. HALAMAN DAFTAR TUGAS

class HalamanDaftarTugas extends StatefulWidget {
  const HalamanDaftarTugas({super.key});

  @override
  State<HalamanDaftarTugas> createState() => _HalamanDaftarTugasState();
}

class _HalamanDaftarTugasState extends State<HalamanDaftarTugas> {
  // Data awal tugas kuliah
  final List<Tugas> daftarTugas = [
    Tugas(
      judul: 'Membuat Makalah',
      mataKuliah: 'Pengelolaan Pendidikan',
      tenggat: '10 November 2026',
      catatan: 'Membuat makalah tentang manajemen pendidikan.',
    ),
    Tugas(
      judul: 'Praktikum Flutter',
      mataKuliah: 'Pemrograman Mobile',
      tenggat: '12 November 2026',
      catatan: 'Membuat aplikasi sederhana menggunakan Flutter.',
    ),
    Tugas(
      judul: 'Laporan Praktikum',
      mataKuliah: 'Jaringan Komputer',
      tenggat: '15 November 2026',
      catatan: 'Menyelesaikan laporan konfigurasi jaringan.',
    ),
  ];

  // CREATE: MENAMBAHKAN TUGAS

  Future<void> tambahTugas() async {
    final hasil = await Navigator.push<Tugas>(
      context,
      MaterialPageRoute(builder: (context) => const HalamanFormTugas()),
    );

    if (hasil != null) {
      setState(() {
        daftarTugas.add(hasil);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tugas berhasil ditambahkan!')),
      );
    }
  }

  // UPDATE: MENGEDIT TUGAS

  Future<void> editTugas(int index) async {
    final hasil = await Navigator.push<Tugas>(
      context,
      MaterialPageRoute(
        builder: (context) => HalamanFormTugas(tugas: daftarTugas[index]),
      ),
    );

    if (hasil != null) {
      setState(() {
        daftarTugas[index] = hasil;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tugas berhasil diperbarui!')),
      );
    }
  }

  // DELETE: MENGHAPUS TUGAS

  void hapusTugas(int index) {
    final judul = daftarTugas[index].judul;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Tugas'),
          content: Text('Apakah kamu yakin ingin menghapus "$judul"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  daftarTugas.removeAt(index);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tugas berhasil dihapus!')),
                );
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // READ: MENAMPILKAN DAFTAR TUGAS

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Tugas Kuliah',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan jumlah tugas
            Text(
              'Total Tugas: ${daftarTugas.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            // Menampilkan daftar tugas
            Expanded(
              child: daftarTugas.isEmpty
                  // Pesan jika daftar kosong
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 65,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Belum ada tugas kuliah.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  // ListView untuk menampilkan data
                  : ListView.builder(
                      itemCount: daftarTugas.length,

                      itemBuilder: (context, index) {
                        final tugas = daftarTugas[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),

                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              child: Icon(Icons.assignment),
                            ),

                            title: Text(
                              tugas.judul,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(
                              '${tugas.mataKuliah}\n'
                              'Tenggat: ${tugas.tenggat}',
                            ),

                            isThreeLine: true,

                            // Menu edit dan hapus
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  editTugas(index);
                                } else if (value == 'hapus') {
                                  hapusTugas(index);
                                }
                              },

                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.blue),
                                      SizedBox(width: 10),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),

                                const PopupMenuItem(
                                  value: 'hapus',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 10),
                                      Text('Hapus'),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Membuka halaman detail
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HalamanDetailTugas(tugas: tugas),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // Tombol tambah tugas
      floatingActionButton: FloatingActionButton(
        onPressed: tambahTugas,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// 4. HALAMAN FORM TAMBAH DAN EDIT TUGAS

class HalamanFormTugas extends StatefulWidget {
  final Tugas? tugas;

  const HalamanFormTugas({super.key, this.tugas});

  @override
  State<HalamanFormTugas> createState() => _HalamanFormTugasState();
}

class _HalamanFormTugasState extends State<HalamanFormTugas> {
  // Form dan controller
  final _formKey = GlobalKey<FormState>();

  final judulController = TextEditingController();
  final mataKuliahController = TextEditingController();
  final catatanController = TextEditingController();

  DateTime? tanggalTenggat;

  // Menyimpan tenggat lama ketika mengedit
  String? tenggatAwal;

  // Mengisi formulir jika sedang melakukan edit
  @override
  void initState() {
    super.initState();

    if (widget.tugas != null) {
      judulController.text = widget.tugas!.judul;
      mataKuliahController.text = widget.tugas!.mataKuliah;
      catatanController.text = widget.tugas!.catatan;

      tenggatAwal = widget.tugas!.tenggat;
    }
  }

  // MEMILIH TANGGAL TENGGAT

  Future<void> pilihTanggal() async {
    final tanggal = await showDatePicker(
      context: context,
      initialDate: tanggalTenggat ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (tanggal != null) {
      setState(() {
        tanggalTenggat = tanggal;
      });
    }
  }

  // MENYIMPAN TUGAS

  void simpanTugas() {
    // Memeriksa validasi formulir
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Memeriksa tenggat waktu
    if (tanggalTenggat == null && tenggatAwal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tenggat waktu wajib diisi!')),
      );
      return;
    }

    // Membuat objek tugas baru
    final tugasBaru = Tugas(
      judul: judulController.text.trim(),

      mataKuliah: mataKuliahController.text.trim(),

      tenggat: tanggalTenggat != null
          ? '${tanggalTenggat!.day} '
                '${tanggalTenggat!.month} '
                '${tanggalTenggat!.year}'
          : tenggatAwal!,

      catatan: catatanController.text.trim(),
    );

    // Mengirim data ke halaman sebelumnya
    Navigator.pop(context, tugasBaru);
  }

  // Membersihkan controller
  @override
  void dispose() {
    judulController.dispose();
    mataKuliahController.dispose();
    catatanController.dispose();

    super.dispose();
  }

  // TAMPILAN FORMULIR

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tugas == null ? 'Tambah Tugas' : 'Edit Tugas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.tugas == null
                    ? 'Formulir Tugas Kuliah'
                    : 'Ubah Data Tugas',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Input judul tugas
              TextFormField(
                controller: judulController,

                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.assignment),
                ),

                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return 'Judul minimal 3 karakter!';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Input mata kuliah
              TextFormField(
                controller: mataKuliahController,

                decoration: const InputDecoration(
                  labelText: 'Mata Kuliah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Mata kuliah wajib diisi!';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Input tenggat waktu
              InkWell(
                onTap: pilihTanggal,

                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tenggat Waktu',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),

                  child: Text(
                    tanggalTenggat != null
                        ? '${tanggalTenggat!.day}/'
                              '${tanggalTenggat!.month}/'
                              '${tanggalTenggat!.year}'
                        : tenggatAwal ?? 'Pilih tanggal',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Input catatan opsional
              TextFormField(
                controller: catatanController,
                maxLines: 3,

                decoration: const InputDecoration(
                  labelText: 'Catatan (Opsional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                ),
              ),

              const SizedBox(height: 25),

              // Tombol simpan
              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: simpanTugas,

                  icon: const Icon(Icons.save),

                  label: Text(
                    widget.tugas == null ? 'Simpan Tugas' : 'Simpan Perubahan',
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 5. HALAMAN DETAIL TUGAS

class HalamanDetailTugas extends StatelessWidget {
  final Tugas tugas;

  const HalamanDetailTugas({super.key, required this.tugas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ikon tugas
            const Center(
              child: Icon(Icons.assignment, size: 70, color: Colors.blue),
            ),

            const SizedBox(height: 20),

            // Judul tugas
            Text(
              tugas.judul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const Divider(height: 30),

            // Mata kuliah
            const Text(
              'Mata Kuliah',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 5),

            Text(tugas.mataKuliah),

            const SizedBox(height: 20),

            // Tenggat waktu
            const Text(
              'Tenggat Waktu',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 5),

            Text(tugas.tenggat),

            const SizedBox(height: 20),

            // Catatan
            const Text(
              'Catatan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 5),

            Text(tugas.catatan.isEmpty ? 'Tidak ada catatan.' : tugas.catatan),
          ],
        ),
      ),
    );
  }
}

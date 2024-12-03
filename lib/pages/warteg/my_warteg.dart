// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:warteg_uts/components/custom_navbar.dart';

class MyWarteg extends StatefulWidget {
  const MyWarteg({super.key});

  @override
  _MyWartegState createState() => _MyWartegState();
}

class _MyWartegState extends State<MyWarteg> {
  bool isMenuSelected = true;

  final List<Map<String, String>> menuData = [
    {
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Ayam_goreng_in_Jakarta.JPG/800px-Ayam_goreng_in_Jakarta.JPG',
      'name': 'Ayam Goreng',
      'price': 'Rp3.000',
    },
    {
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/2/21/Indonesian_fried_tempeh.JPG',
      'name': 'Tempe Goreng',
      'price': 'Rp1.000',
    },
    {
      'image':
          'https://awsimages.detik.net.id/community/media/visual/2021/08/06/ilustrasi-jengkol_43.jpeg?w=600&q=90',
      'name': 'Sayur Jengkol',
      'price': 'Rp2.000',
    },
  ];

  final List<Map<String, String>> paketData = [
    {
      'image':
          'https://asset.kompas.com/crops/Slbj_ngGVguffqNkbgjtdZqd8OU=/13x7:700x465/1200x800/data/photo/2021/09/24/614dc6865eb24.jpg',
      'name': 'Nasi Goreng Spesial',
      'price': 'Rp25.000',
      'description': 'Nasi goreng lezat dengan topping ayam, udang, dan telur.',
    },
    {
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2UKCaOnjAbGnFsDctG8x5D39mSDonUB_13w&s',
      'name': 'Mie Ayam Komplit',
      'price': 'Rp20.000',
      'description':
          'Mie ayam dengan bakso, pangsit, dan taburan bawang goreng.',
    },
    {
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRvknvknxI8c7mJ6LFJlRySTX0GddP-SEgiQ&s',
      'name': 'Sate Ayam',
      'price': 'Rp30.000',
      'description': 'Sate ayam dengan bumbu kacang khas dan lontong.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditTokoDialog,
          ),
          IconButton(
            icon: const Icon(Icons.assignment),
            onPressed: () {
              Navigator.pushNamed(context, '/pesanan');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Info Toko
            _buildHeader(),
            const SizedBox(height: 16),

            // Menu and Paket Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMenuButton('Menu', true),
                  _buildMenuButton('Paket', false),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Daftar menu atau paket
            if (isMenuSelected)
              _buildMenuList(menuData)
            else
              _buildPaketList(paketData),

            const SizedBox(height: 16)
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavbar(currentIndex: 3),

      // Floating action button for adding menu or package
      floatingActionButton: FloatingActionButton(
        onPressed: _addMenuOrPaket, // Function to handle adding
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Header: Info Toko
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blueAccent,
      child: const Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://ultimagz.com/wp-content/uploads/warteg-flx.jpg',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Warteg Bahari',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Toko Aktif',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8), // Space for the address
            Text(
              'Jl. Raya No. 123, Jakarta', // Replace this with the actual address
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat tombol Menu dan Paket
  Widget _buildMenuButton(String label, bool isMenu) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMenuSelected = isMenu;
        });
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isMenuSelected == isMenu ? Colors.blueAccent : Colors.grey,
          decoration: isMenuSelected == isMenu
              ? TextDecoration.underline
              : TextDecoration.none,
        ),
      ),
    );
  }

  // Fungsi untuk membangun daftar menu
  Widget _buildMenuList(List<Map<String, String>> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  item['image']!,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    item['price']!,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaketList(List<Map<String, String>> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final paket = data[index];
          return Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar tetap dengan tinggi yang sudah ada
                Image.network(
                  paket['image']!,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    paket['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    paket['price']!,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
                // Deskripsi dengan Expanded
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      paket['description']!,
                      style: const TextStyle(color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow
                          .ellipsis, // Agar deskripsi tidak overflow
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Function to handle adding menu or paket
  void _addMenuOrPaket() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Menu atau Paket'),
          content: const Text('Halaman untuk menambah menu atau paket baru.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTokoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Toko'),
          content: const Text('Halaman untuk mengedit informasi toko.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}

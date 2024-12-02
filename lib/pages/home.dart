import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warteg_uts/bloc/auth/bloc/auth_bloc.dart';
import 'package:warteg_uts/components/custom_navbar.dart';
import 'package:warteg_uts/components/hero_slider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(uid)
          .get(const GetOptions(
              source: Source.server)); // Ambil langsung dari server
      return snapshot.data();
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan instance pengguna saat ini dari FirebaseAuth
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'WartegKu',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic, // Gaya kursif
          ),
        ),
        actions: [
          // CircleAvatar dengan dropdown profile
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<Map<String, dynamic>?>(
              // Ambil data user
              future: currentUser != null
                  ? getUserData(currentUser.uid)
                  : Future.value(null),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://www.example.com/avatar.jpg', // Placeholder avatar
                    ),
                  );
                }

                final userData = snapshot.data!;
                final userName = userData['name'] ?? 'Guest'; // Ambil nama
                final userEmail = userData['email'] ?? '';

                return PopupMenuButton<int>(
                  onSelected: (int value) {
                    if (value == 1) {
                      // Aksi Edit Profile
                      context.goNamed('akun');
                    } else if (value == 2) {
                      context.read<AuthBloc>().add(AuthEventLogout());
                      context.goNamed('welcome');
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      enabled: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar User
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              userData['avatarUrl'] ??
                                  'https://www.example.com/avatar.jpg', // Placeholder jika avatar tidak tersedia
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(userName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(userEmail,
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<int>(
                      // Edit profile option
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Edit Profile'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<int>(
                      // Logout option
                      value: 2,
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      userData['avatarUrl'] ??
                          'https://www.example.com/avatar.jpg', // Placeholder jika avatar tidak tersedia
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _methodOption(
                          Icons.delivery_dining, 'Diantar', Colors.lightGreen),
                      _methodOption(
                          Icons.storefront, 'Takeout', Colors.orangeAccent),
                      _methodOption(
                          Icons.local_dining, 'Dine-In', Colors.pinkAccent),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Hero Section
            const SizedBox(height: 20),
            const HeroSlider(),

            // Kategori Section
            const SizedBox(height: 20),
            _categorySection(),

            // Rekomendasi Section
            const SizedBox(height: 20),
            _recommendationSection(),

            // Warteg Terdekat Section
            const SizedBox(height: 20),
            _wartegNearbySection(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavbar(currentIndex: 0),
    );
  }

  Widget _methodOption(IconData icon, String label, Color bgColor) {
    return GestureDetector(
      onTap: () {
        // Aksi saat opsi diklik
      },
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 35, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.arrow_forward, color: Colors.lightBlue),
                  onPressed: onTap,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Content Section
            content,
          ],
        ),
      ),
    );
  }

  Widget _categorySection() {
    return _buildSection(
      title: 'Kategori Makanan',
      content: _categoryGrid(),
      onTap: () {
        // Aksi untuk lihat semua kategori
      },
    );
  }

  Widget _categoryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.lightBlue,
                child: Icon(Icons.fastfood, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Kategori ${index + 1}',
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _recommendationSection() {
    return _buildSection(
      title: 'Rekomendasi Makanan',
      content: _horizontalFoodList(),
      onTap: () {
        // Aksi untuk lihat semua rekomendasi
      },
    );
  }

  Widget _horizontalFoodList() {
    // Daftar data makanan
    final List<Map<String, String>> foodData = [
      {
        'image':
            'https://asset.kompas.com/crops/Slbj_ngGVguffqNkbgjtdZqd8OU=/13x7:700x465/1200x800/data/photo/2021/09/24/614dc6865eb24.jpg',
        'name': 'Nasi Goreng Spesial',
        'price': 'Rp25.000',
        'description':
            'Nasi goreng lezat dengan topping ayam, udang, dan telur.',
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
      {
        'image':
            'https://awsimages.detik.net.id/community/media/visual/2021/08/06/ilustrasi-jengkol_43.jpeg?w=600&q=90',
        'name': 'Sayur Jengkol',
        'price': 'Rp10.000',
        'description': '',
      }
    ];

    return SizedBox(
      height: 250, // Tinggi total kontainer
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: foodData.length,
        itemBuilder: (context, index) {
          final food = foodData[index];
          return GestureDetector(
            onTap: () {
              // Aksi saat item makanan diklik, arahkan ke halaman Warteg
              context.goNamed('warteg', extra: food);
            },
            child: Container(
              width: 180, // Lebar setiap item
              margin: const EdgeInsets.only(left: 16), // Jarak antar item
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 4), // Efek bayangan ke bawah
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Makanan
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      food['image']!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Makanan
                        Text(
                          food['name']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Harga
                        Text(
                          food['price']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Deskripsi Singkat
                        Text(
                          food['description']!,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _wartegNearbySection() {
    return _buildSection(
      title: 'Warteg Terdekat',
      content: _verticalWartegList(),
      onTap: () {
        // Aksi untuk lihat semua warteg
      },
    );
  }

  Widget _verticalWartegList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://ultimagz.com/wp-content/uploads/warteg-flx.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          title: Text('Warteg ${index + 1}'),
          subtitle: const Text('Jalan Raya Nomor 123'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Aksi untuk masuk ke detail warteg
          },
        );
      },
    );
  }
}

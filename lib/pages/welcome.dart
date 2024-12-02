import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna tema Biru Muda
    const primaryColor = Colors.lightBlue; // Warna biru muda
    const accentColor = Colors.blueAccent; // Warna aksen biru lebih gelap

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian atas dengan latar belakang melengkung dan gambar
            Container(
              height: MediaQuery.of(context).size.height *
                  0.45, // Tinggi ditingkatkan sedikit
              decoration: const BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Gambar Logo (Ikon Fastfood)
                      Icon(
                        Icons.fastfood,
                        size: 100,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Welcome to Warteg Online',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Deskripsi aplikasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Makan enak, cepat, dan hemat! Warteg Online hadir untuk memenuhi kebutuhan makanan harian Anda dengan harga terjangkau.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Tombol Sign In
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  context.goNamed('login');
                },
                child: const Text(
                  'LOG IN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Tombol Sign Up
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryColor, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  context.goNamed('register');
                },
                child: const Text(
                  'REGISTER',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

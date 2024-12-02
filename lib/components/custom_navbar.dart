import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

class CustomNavbar extends StatelessWidget {
  final int currentIndex;

  const CustomNavbar({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    // Navigasi ke halaman lain dengan context.goNamed
    switch (index) {
      case 0:
        context.goNamed('home'); // Menggunakan nama rute dari GoRouter
        break;
      case 1:
        context.goNamed('explore'); // Rute Explore
        break;
      case 2:
        context.goNamed('orders'); // Rute Pesanan
        break;
      case 3:
        context.goNamed('mywarteg'); // Rute WartegKu
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: currentIndex,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.transparent,
        elevation: 0,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), // Ikon diubah ke Icons.receipt
            label: 'Pesanan', // Label diubah menjadi Pesanan
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store), // Ikon untuk WartegKu
            label: 'WartegKu',
          ),
        ],
      ),
    );
  }
}

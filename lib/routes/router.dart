import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:uts_warteg/pages/akun.dart';
import 'package:uts_warteg/pages/home.dart';
import 'package:uts_warteg/pages/login.dart';
import 'package:uts_warteg/pages/pemesanan/detail_menu.dart';
import 'package:uts_warteg/pages/pemesanan/detail_pesanan.dart';
import 'package:uts_warteg/pages/pemesanan/warteg.dart';
import 'package:uts_warteg/pages/register.dart';
import 'package:uts_warteg/pages/warteg/my_warteg.dart';
import 'package:uts_warteg/pages/welcome.dart';

class AuthNotifier extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthNotifier() {
    _auth.authStateChanges().listen((User? user) {
      notifyListeners(); // Notifikasi saat status login berubah
    });
  }

  bool get isLoggedIn => _auth.currentUser != null;
}

final authNotifier = AuthNotifier();

final router = GoRouter(
  initialLocation: '/welcome',
  redirect: (context, state) {
    final isLoggedIn = authNotifier.isLoggedIn;

    // Rute akses yang memerlukan status login tertentu
    final routesBeforeLogin = ['/welcome', '/login', '/register'];
    final routesAfterLogin = ['/home'];

    // Jika sudah login tetapi mengakses rute sebelum login
    if (isLoggedIn && routesBeforeLogin.contains(state.matchedLocation)) {
      return '/home';
    }

    // Jika belum login tetapi mengakses rute setelah login
    if (!isLoggedIn && routesAfterLogin.contains(state.matchedLocation)) {
      return '/welcome';
    }

    return null; // Tidak ada perubahan rute
  },
  refreshListenable: authNotifier,
  routes: [
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => Login(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => Register(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/akun',
      name: 'akun',
      builder: (context, state) => const Akun(),
    ),
    GoRoute(
      path: '/mywarteg',
      name: 'mywarteg',
      builder: (context, state) => const MyWarteg(),
    ),
    GoRoute(
      path: '/detail-pesanan',
      name: 'detailpesanan',
      builder: (context, state) => const CartDetail(),
    ),
    GoRoute(
      path: '/warteg',
      name: 'warteg',
      builder: (context, state) => const Warteg(),
    ),
    GoRoute(
      path: '/detail-menu',
      name: 'detailmenu',
      builder: (context, state) => const DetailMenu(),
    ),
  ],
);

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:warteg_uts/bloc/profile/bloc/profile_bloc.dart';

class Akun extends StatefulWidget {
  const Akun({super.key});

  @override
  State<Akun> createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  late TextEditingController nameController;
  late String photoUrl; // Menyimpan URL foto pengguna
  File? _image; // Menyimpan gambar yang dipilih
  Uint8List? _imageBytes; // For web platform

  final ImagePicker _picker = ImagePicker();

  bool isUploading = false;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller dengan nama kosong sebagai default
    nameController = TextEditingController();
    photoUrl = ''; // Default foto URL

    // Jika pengguna sudah login, ambil data pengguna dari Firestore
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          final userData = doc.data();
          if (userData != null) {
            setState(() {
              nameController.text = userData['name'] ?? '';
              photoUrl = userData['photoUrl'] ?? ''; // Ambil URL foto
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    // Pastikan controller dibuang setelah widget tidak digunakan
    nameController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageBytes = null; // Reset image bytes if a file is selected
      });

      // If platform is web, convert the image to bytes
      if (kIsWeb) {
        final byteData = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = byteData;
        });
      }

      // If you want to upload the image, you can call the upload method here.
      await _uploadImageToFirebase();
    }
  }

  Future<void> _uploadImageToFirebase() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (_image != null && currentUser != null) {
      try {
        setState(() {
          isUploading = true; // Proses upload dimulai
        });

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures/${currentUser.uid}.jpg');

        // Unggah gambar
        await storageRef.putFile(_image!);

        // Ambil URL gambar setelah berhasil diupload
        final downloadUrl = await storageRef.getDownloadURL();

        // Perbarui URL foto pengguna di Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'photoUrl': downloadUrl,
        });

        setState(() {
          photoUrl = downloadUrl; // Simpan URL baru
        });

        print('Photo URL updated successfully: $downloadUrl');
      } catch (e) {
        print('Error uploading image: $e');
      } finally {
        setState(() {
          isUploading = false; // Proses upload selesai
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.goNamed('home');
          },
        ),
        title: const Text('Akun Saya'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileStateUpdated) {
            // Tampilkan notifikasi sukses
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ProfileStateError) {
            // Tampilkan notifikasi error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Profile Section
              Center(
                child: GestureDetector(
                  onTap: _pickImage, // Pilih gambar saat ditekan
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: kIsWeb
                            ? (_imageBytes != null
                                ? Image.memory(_imageBytes!).image
                                : const AssetImage('assets/default_avatar.png'))
                            : (_image != null
                                ? FileImage(_image!) as ImageProvider
                                : NetworkImage(photoUrl.isNotEmpty
                                    ? photoUrl
                                    : 'https://www.w3schools.com/howto/img_avatar.png')),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child:
                              const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Full Name
              const Text(
                'Nama Lengkap',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Masukkan Nama Anda',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Email
              const Text(
                'Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                currentUser?.email ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (isUploading) {
                      // Tampilkan notifikasi atau pesan kepada pengguna
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Harap tunggu hingga upload selesai')),
                      );
                      return;
                    }

                    if (currentUser != null) {
                      print('Photo URL sebelumnya: $photoUrl'); // URL lama
                      print(
                          'Photo URL yang akan dikirim: $photoUrl'); // URL baru setelah diperbarui

                      // Kirim data ke Firestore
                      context.read<ProfileBloc>().add(ProfileEventUpdate(
                            uid: currentUser.uid,
                            updatedData: {
                              'name': nameController.text,
                              'photoUrl': photoUrl, // Gunakan URL terbaru
                            },
                          ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uts_warteg/bloc/register/bloc/register_bloc.dart';
import 'package:uts_warteg/visibility_cubit.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static const primaryColor = Colors.lightBlue;
  static const accentColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    // Warna tema

    return Scaffold(
      body: Container(
        color: primaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Header teks
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                alignment: Alignment.center,
                child: const Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // Formulir dalam kartu
              Transform.translate(
                offset: const Offset(0, 15),
                child: Container(
                  width: double.infinity, // Memastikan lebar kartu penuh
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _nameField(),
                        const SizedBox(height: 20),
                        _emailField(),
                        const SizedBox(height: 20),
                        _passwordField(),
                        const SizedBox(height: 30),
                        // Tombol Register
                        _registerButton(context),
                        const SizedBox(height: 20),
                        // Teks untuk navigasi ke halaman login
                        Center(
                          child: TextButton(
                            onPressed: () {
                              context.goNamed('login');
                            },
                            child: const Text(
                              'Already have an account? Login',
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nama',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: 'Masukkan Nama Anda',
          ),
        ),
      ],
    );
  }

  Widget _emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: 'Masukkan Email Anda',
          ),
        ),
      ],
    );
  }

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 8),
        BlocConsumer<VisibilityCubit, bool>(
          listener: (context, state) {},
          builder: (context, isObscured) {
            return TextField(
              controller: _passwordController,
              obscureText: isObscured,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: 'Masukkan Password Anda',
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscured
                        ? Icons.visibility_off
                        : Icons.visibility, // Toggle visibility icons
                  ),
                  onPressed: () {
                    context.read<VisibilityCubit>().change();
                  },
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _registerButton(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is RegisterSuccess) {
          // Navigasi ke halaman login
          context.goNamed('login');
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: state is! RegisterLoading
              ? () {
                  context.read<RegisterBloc>().add(
                        RegisterSubmitted(
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                }
              : null,
          child: state is RegisterLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text(
                  'REGISTER',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );
      },
    );
  }
}

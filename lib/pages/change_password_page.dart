import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _toggleOldPasswordVisibility() {
    setState(() {
      _isOldPasswordVisible = !_isOldPasswordVisible;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _isNewPasswordVisible = !_isNewPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ubah Password',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[300],
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 15,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _oldPasswordController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                          filled: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.white,
                          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                          hintText: 'Masukkan password lama',
                          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                          suffixIcon: IconButton(
                            onPressed: _toggleOldPasswordVisibility,
                            color: Theme.of(context).primaryColor,
                            icon: Icon(_isOldPasswordVisible ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                        obscureText: !_isOldPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan password lama terlebih dahulu';
                          }
                          return null;
                        },
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.2),
                        height: 1,
                        thickness: 1,
                      ),
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.white,
                          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                          hintText: 'Masukkan password baru',
                          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                          suffixIcon: IconButton(
                            onPressed: _toggleNewPasswordVisibility,
                            color: Theme.of(context).primaryColor,
                            icon: Icon(_isNewPasswordVisible ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                        obscureText: !_isNewPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan password baru terlebih dahulu';
                          }
                          return null;
                        },
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.2),
                        height: 1,
                        thickness: 1,
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                          filled: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.white,
                          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                          hintText: 'Masukkan kembali password baru',
                          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                          suffixIcon: IconButton(
                            onPressed: _toggleConfirmPasswordVisibility,
                            color: Theme.of(context).primaryColor,
                            icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                        obscureText: !_isConfirmPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password baru terlebih dahulu';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Password tidak sama';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      shadowColor: Colors.transparent,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Ubah Password', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final oldPassword = _oldPasswordController.text;
      final newPassword = _newPasswordController.text;

      // Retrieve the user
      final user = await DatabaseHelper.instance.getUser('satrio', oldPassword);
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password lama salah!')),
        );
        return;
      }

      await DatabaseHelper.instance.updateUserPassword('satrio', newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diubah :D')),
      );

      Navigator.pop(context);
    }
  }
}

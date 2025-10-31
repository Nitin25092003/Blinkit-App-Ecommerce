import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import '../services/db_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _form = GlobalKey<FormState>();
  String? _name;
  String? _email;
  File? _imageFile;
  bool _saving = false;

  Future<void> _pickImage() async {
    final p = ImagePicker();
    final XFile? picked = await p.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked == null) return;
    setState(() => _imageFile = File(picked.path));
  }

  Future<void> _save() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final u = auth.user!;
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    setState(() => _saving = true);
    final updated = User(
      id: u.id,
      name: _name ?? u.name,
      email: _email ?? u.email,
      password: u.password,
      profileImagePath: _imageFile?.path ?? u.profileImagePath,
    );
    await DBHelper.updateUser(updated);
    await auth.updateProfile(updated);
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () async {
              await auth.logout();
              Navigator.of(context).popUntil((r) => r.isFirst);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (user.profileImagePath != null
                          ? (user.profileImagePath!.startsWith('assets') ? AssetImage(user.profileImagePath!) as ImageProvider : FileImage(File(user.profileImagePath!)))
                          : const AssetImage('assets/images/profile_placeholder.png')),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        child: Container(
                          decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                initialValue: user.name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                onSaved: (v) => _name = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: user.email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
                onSaved: (v) => _email = v,
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(14)),
                child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

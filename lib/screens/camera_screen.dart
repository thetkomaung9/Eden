import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart'; // global cameras list ကို သုံးရန်

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initFuture;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Camera list ရှိမရှိ အရင်စစ်သည်
    if (cameras.isNotEmpty) {
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false, // အသံမလိုအပ်ပါက ပိတ်ထားနိုင်သည်
      );
      _initFuture = _controller!.initialize();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takeAndUpload() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isUploading) {
      return;
    }

    setState(() => _isUploading = true);

    try {
      // 1. တည်နေရာ ခွင့်ပြုချက် စစ်ဆေးခြင်း
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      // 2. ဓာတ်ပုံရိုက်ခြင်းနှင့် တည်နေရာယူခြင်း
      final image = await _controller!.takePicture();
      final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ));

      // 3. Firebase Storage သို့ ပုံတင်ခြင်း
      String fileName = 'eden_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child('eden_posts/$fileName');

      await ref.putFile(File(image.path));
      final imageUrl = await ref.getDownloadURL();

      // 4. Firestore ထဲသို့ Data သိမ်းခြင်း
      await FirebaseFirestore.instance.collection('posts').add({
        'imageUrl': imageUrl,
        'location': GeoPoint(position.latitude, position.longitude),
        'timestamp': FieldValue.serverTimestamp(),
        'userId':
            'thetko_eden_user', // နောက်ပိုင်းတွင် Auth ID ဖြင့် အစားထိုးပါ
        'status': 'verified',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Karma Uploaded to Eden Network!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("KARMA CAM", style: TextStyle(letterSpacing: 2)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.greenAccent,
      ),
      body: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.greenAccent));
          }

          if (_controller == null || snapshot.hasError) {
            return const Center(child: Text('Camera Initialization Failed'));
          }

          return Stack(
            children: [
              // ကင်မရာ မြင်ကွင်းကို အပြည့်ပြရန်
              SizedBox.expand(child: CameraPreview(_controller!)),

              // Upload လုပ်နေစဉ် Loading ပြရန်
              if (_isUploading)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.greenAccent),
                        SizedBox(height: 20),
                        Text("UPLOADING TO EDEN...",
                            style: TextStyle(color: Colors.greenAccent)),
                      ],
                    ),
                  ),
                ),

              // UI Controls
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: FloatingActionButton(
                    onPressed: _isUploading ? null : _takeAndUpload,
                    backgroundColor: Colors.greenAccent,
                    child:
                        const Icon(Icons.camera, size: 35, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

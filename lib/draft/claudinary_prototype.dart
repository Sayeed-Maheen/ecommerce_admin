import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cloudinary Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();

  File? selectedImage;

  String? cloudinaryImageUrl;

  bool isUploading = false;

  // ------------------------------------------
  // Cloudinary configuration
  // ------------------------------------------

  static const String cloudName = 'YOUR_CLOUD_NAME';

  static const String uploadPreset = 'YOUR_UPLOAD_PRESET';

  // ------------------------------------------
  // Pick image
  // ------------------------------------------

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    setState(() {
      selectedImage = File(image.path);
      cloudinaryImageUrl = null;
    });
  }

  // ------------------------------------------
  // Upload to Cloudinary
  // ------------------------------------------

  Future<void> uploadToCloudinary() async {
    if (selectedImage == null) {
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', uri);

      request.fields['upload_preset'] = uploadPreset;

      request.files.add(await http.MultipartFile.fromPath('file', selectedImage!.path));

      final response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);

        setState(() {
          cloudinaryImageUrl = data['secure_url'];
        });

        debugPrint('Cloudinary URL: ${data['secure_url']}');

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Image uploaded successfully')));
        }
      } else {
        debugPrint('Upload failed: $responseBody');

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Image upload failed')));
        }
      }
    } catch (e) {
      debugPrint('Upload error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cloudinary Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ------------------------------------------
            // Selected local image
            // ------------------------------------------
            if (selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  selectedImage!,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(child: Text('No image selected')),
              ),

            const SizedBox(height: 20),

            // ------------------------------------------
            // Pick image button
            // ------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pick Image'),
              ),
            ),

            const SizedBox(height: 10),

            // ------------------------------------------
            // Upload button
            // ------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: selectedImage == null || isUploading ? null : uploadToCloudinary,
                icon: isUploading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cloud_upload),
                label: Text(isUploading ? 'Uploading...' : 'Upload to Cloudinary'),
              ),
            ),

            const SizedBox(height: 30),

            // ------------------------------------------
            // Cloudinary image
            // ------------------------------------------
            if (cloudinaryImageUrl != null) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Image loaded from Cloudinary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  cloudinaryImageUrl!,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const SizedBox(
                      height: 300,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 300,
                      child: Center(child: Text('Failed to load image')),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

              // ------------------------------------------
              // Cloudinary URL
              // ------------------------------------------
              SelectableText(cloudinaryImageUrl!, style: const TextStyle(fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }
}

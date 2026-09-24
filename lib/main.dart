// import 'package:ecommerce_admin/features/auth/auth_binding.dart';
// import 'package:ecommerce_admin/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'app/router/app_router.dart';
// import 'app/theme/app_theme.dart';
// import 'core/bindings/initial_bindings.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   final preferences = await SharedPreferences.getInstance();

//   Get.put<SharedPreferences>(preferences, permanent: true);

//   InitialBindings().dependencies();

//   AuthBinding().dependencies();

//   runApp(const EcommerceAdminApp());
// }

// class EcommerceAdminApp extends StatelessWidget {
//   const EcommerceAdminApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'E-Commerce Admin',

//       debugShowCheckedModeBanner: false,

//       theme: AppTheme.light,
//       darkTheme: AppTheme.dark,

//       themeMode: ThemeMode.system,

//       routerConfig: AppRouter.router,
//     );
//   }
// }

import 'dart:convert';
import 'dart:typed_data';

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
      title: 'Cloudinary Web Demo',
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

  Uint8List? selectedImageBytes;

  String? cloudinaryImageUrl;

  bool isUploading = false;

  // -----------------------------------------
  // Cloudinary configuration
  // -----------------------------------------

  static const String cloudName = 'nthm8wd3';

  static const String uploadPreset = 'ecommerce_product_images';

  // -----------------------------------------
  // Pick image
  // -----------------------------------------

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    final bytes = await image.readAsBytes();

    setState(() {
      selectedImageBytes = bytes;
      cloudinaryImageUrl = null;
    });
  }

  // -----------------------------------------
  // Upload image to Cloudinary
  // -----------------------------------------

  Future<void> uploadToCloudinary() async {
    if (selectedImageBytes == null) {
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', url);

      // Upload preset
      request.fields['upload_preset'] = uploadPreset;

      // Image bytes
      request.files.add(
        http.MultipartFile.fromBytes('file', selectedImageBytes!, filename: 'flutter_image.jpg'),
      );

      final response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);

        final imageUrl = data['secure_url'];

        final finalImageUrl = imageUrl;

        setState(() {
          cloudinaryImageUrl = imageUrl;
        });

        debugPrint('Cloudinary URL: $imageUrl');

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Image uploaded successfully!')));
        }
      } else {
        debugPrint('Cloudinary error: $responseBody');

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
      appBar: AppBar(title: const Text('Cloudinary Flutter Web')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // --------------------------------
                // Selected image
                // --------------------------------
                Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: selectedImageBytes == null
                      ? const Center(child: Text('No image selected'))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.memory(selectedImageBytes!, fit: BoxFit.cover),
                        ),
                ),

                const SizedBox(height: 20),

                // --------------------------------
                // Pick image
                // --------------------------------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Select Image'),
                  ),
                ),

                const SizedBox(height: 12),

                // --------------------------------
                // Upload
                // --------------------------------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: selectedImageBytes == null || isUploading
                        ? null
                        : uploadToCloudinary,
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

                // --------------------------------
                // Cloudinary image
                // --------------------------------
                if (cloudinaryImageUrl != null) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Image from Cloudinary',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      cloudinaryImageUrl!,
                      width: double.infinity,
                      height: 350,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const SizedBox(
                          height: 350,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 350,
                          child: Center(child: Text('Failed to load image')),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  SelectableText(cloudinaryImageUrl!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

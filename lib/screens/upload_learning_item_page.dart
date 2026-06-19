import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 🔥 CLOUDINARY IMAGE UPLOAD
Future<String?> uploadImage(Uint8List bytes) async {
  final url =
      Uri.parse("https://api.cloudinary.com/v1_1/diacqf2n7/image/upload");

  final request = http.MultipartRequest("POST", url);
  request.fields['upload_preset'] = "unsigned_preset";

  request.files.add(
    http.MultipartFile.fromBytes('file', bytes, filename: "image.jpg"),
  );

  final response = await request.send();

  if (response.statusCode == 200) {
    final res = await response.stream.bytesToString();
    return json.decode(res)['secure_url'];
  }
  return null;
}

class UploadLearningItemPage extends StatefulWidget {
  const UploadLearningItemPage({super.key});

  @override
  State<UploadLearningItemPage> createState() => _UploadLearningItemPageState();
}

class _UploadLearningItemPageState extends State<UploadLearningItemPage> {
  /// 🔤 TEXT CONTROLLERS
  final mal = TextEditingController();
  final eng = TextEditingController();
  final tam = TextEditingController();
  final videoUrl = TextEditingController();

  /// 📂 DATA
  Uint8List? imageBytes;

  String selectedType = "Alphabet"; // Dropdown

  final picker = ImagePicker();

  bool loading = false;

  /// 📸 PICK IMAGE
  Future pickImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      imageBytes = await img.readAsBytes();
      setState(() {});
    }
  }

  /// 🚀 UPLOAD FUNCTION
  Future upload() async {
    /// ✅ VALIDATION
    /// ✅ AT LEAST ONE FIELD REQUIRED
    if (mal.text.isEmpty &&
        eng.text.isEmpty &&
        tam.text.isEmpty &&
        videoUrl.text.isEmpty &&
        imageBytes == null) {
      showSnack("Fill at least one field");
      return;
    }

  setState(() => loading = true);

  try {

    /// ☁️ Upload image only if selected
    String? imgUrl;

    if (imageBytes != null) {
      imgUrl = await uploadImage(imageBytes!);
    }

    /// 🔥 Save to Firestore
    await FirebaseFirestore.instance.collection("learning_items").add({
      "type": selectedType,
      "malayalam": mal.text,
      "english": eng.text,
      "tamil": tam.text,
      "image": imgUrl,
      "audio": "dummy_audio",
      "video": videoUrl.text,
      "createdAt": DateTime.now(),
    });

    showSnack("Uploaded Successfully ✅");

    mal.clear();
    eng.clear();
    tam.clear();
    videoUrl.clear();
    imageBytes = null;

    setState(() {});
  } catch (e) {
    showSnack("Upload failed: $e");
  }

  setState(() => loading = false);
}

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    mal.dispose();
    eng.dispose();
    tam.dispose();
    videoUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 🎨 MODERN BACKGROUND
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// 🔝 HEADER
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Upload Lesson 📚",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              /// 📝 FORM CONTENT
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🔽 TYPE DROPDOWN
                        const Text(
                          "Select Type",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6A11CB),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedType,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            items: ["Alphabet", "Word", "Sentence"]
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (val) {
                              setState(() => selectedType = val!);
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// 📝 TEXT FIELDS
                        _buildTextField(
                          controller: mal,
                          label: "Malayalam",
                          icon: Icons.language,
                        ),

                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: eng,
                          label: "English",
                          icon: Icons.translate,
                        ),

                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: tam,
                          label: "Tamil",
                          icon: Icons.text_fields,
                        ),

                        const SizedBox(height: 24),

                        /// 🖼 IMAGE UPLOAD
                        const Text(
                          "Upload Image",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6A11CB),
                          ),
                        ),
                        const SizedBox(height: 8),

                        GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade50,
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image,
                                      size: 40, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text("Tap to upload image"),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (imageBytes != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              imageBytes!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                        const SizedBox(height: 24),

                        /// 🎤 AUDIO SECTION
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade50,
                          ),
                          child: const Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.mic, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Text(
                                    "Audio Recording",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "🎤 Audio recording feature coming soon",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// 🎥 VIDEO URL
                        _buildTextField(
                          controller: videoUrl,
                          label: "YouTube Video URL",
                          icon: Icons.video_library,
                        ),

                        const SizedBox(height: 32),

                        /// 🚀 UPLOAD BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: loading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: upload,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6A11CB),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: const Text(
                                    "Upload Lesson 🚀",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                        ),

                        const SizedBox(height: 20),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF6A11CB)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

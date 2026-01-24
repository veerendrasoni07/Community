import 'dart:io';

import 'package:codingera2/controllers/admin_controller.dart';
import 'package:codingera2/provider/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AdminUploadBanner extends ConsumerStatefulWidget {
  const AdminUploadBanner({super.key});

  @override
  ConsumerState<AdminUploadBanner> createState() => _AdminUploadBannerState();
}

class _AdminUploadBannerState extends ConsumerState<AdminUploadBanner> {
  
  PageController pageController = PageController();


  bool isUploading = false;
  XFile? pickedImage;
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => pickedImage = image);
    }
  }

  Future<void> uploadBanner()async{
    setState(() {
      isUploading = true;
    });
    await AdminController().uploadBanner(bannerFile: pickedImage!, context: context,ref: ref);
    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Banner"),
      ),
      body:  Column(
        children: [
          GestureDetector(
            onTap: pickImage,
            child: Container(
              height: 180,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: isUploading ?
    Center(child: CircularProgressIndicator(),) :  pickedImage == null
                  ? const Center(child: Text("Tap to select banner image"))
                  : ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(pickedImage!.path),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              controller: pageController,
              itemCount: banners.length,
              itemBuilder: (context,index){
                final banner = banners[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blueAccent.shade100,
                              blurRadius: 5,
                              spreadRadius: 2
                          )
                        ]
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        banner.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(onPressed: (){
              uploadBanner();
            }, child: Text("Upload Banner")),
          )

        ],
      ),
    );
  }
}

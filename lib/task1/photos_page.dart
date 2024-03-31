import 'dart:convert';
import 'package:company_task/task1/model/photo.dart';
import 'package:company_task/task1/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PhotosPage extends StatelessWidget {
  PhotosPage({super.key});

  final PhotosController photosController = Get.put(PhotosController());

  @override
  Widget build(BuildContext context) {
    int id = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Photos"),
        titleTextStyle: const TextStyle(
          fontFamily: "nunito",
          color: Colors.black,
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: FutureBuilder(
        future: photosController.fetchFilteredPhotos(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Container(
              height: 65.0,
              width: 65.0,
              padding: const EdgeInsets.all(17.0),
              child: const CircularProgressIndicator(
                color: Colors.deepPurple,
                strokeWidth: 2.2,
              ),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Obx(
              () => ListView.separated(
                itemCount: photosController.photos.length,
                itemBuilder: (context, index) {
                  final photo = photosController.photos[index];

                  return ListTile(
                    leading: Image.network(photo.thumbnailUrl),
                    title: Text(photo.title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          photo.url,
                          height: 50.0,
                          width: 50.0,
                        ),
                        IconButton(
                            onPressed: () =>
                                photosController.deletePhotos(photo.id),
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.shade200,
                  thickness: 0.8,
                  indent: 5.0,
                  endIndent: 5.0,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class PhotosController extends GetxController {
  var photos = <Photo>[].obs;

  Future<void> fetchFilteredPhotos(int id) async {
    final response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      List<dynamic> filteredData =
          data.where((json) => json["albumId"] == id).toList();

      photos
          .assignAll(filteredData.map((json) => Photo.fromJson(json)).toList());
    } else {
      throw Exception("Failed to load albums");
    }
  }

  Future<void> deletePhotos(int id) async {
    deleteDialog(() async {
      Get.back();
      easyLoading();

      final response = await http
          .delete(Uri.parse("https://jsonplaceholder.typicode.com/photos/$id"));

      if (response.statusCode == 200) {
        photos.removeWhere((photo) => photo.id == id);
        Get.back();
      } else {
        Get.back();
        throw Exception("Failed to delete item $id");
      }
    });
  }

  void addPhoto(Photo photo) {
    photos.insert(0, photo);
  }
}

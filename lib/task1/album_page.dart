import 'dart:convert';
import 'package:company_task/task1/model/album.dart';
import 'package:company_task/task1/photos_page.dart';
import 'package:company_task/task1/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AlbumPage extends StatelessWidget {
  AlbumPage({super.key});

  final AlbumController albumController = Get.put(AlbumController());

  @override
  Widget build(BuildContext context) {
    int id = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Albums"),
        titleTextStyle: const TextStyle(
          fontFamily: "nunito",
          color: Colors.black,
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: FutureBuilder(
        future: albumController.fetchFilteredAlbums(id),
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
                itemCount: albumController.albums.length,
                itemBuilder: (context, index) {
                  final album = albumController.albums[index];

                  return GestureDetector(
                    onTap: () => Get.to(
                      () => PhotosPage(),
                      arguments: album.id,
                      transition: Transition.rightToLeft,
                      curve: Curves.linear,
                      duration: const Duration(milliseconds: 500),
                    ),
                    child: ListTile(
                      title: Text(album.title,
                          style: const TextStyle(fontFamily: "nunito")),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _editAlbum(context, album),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () =>
                                albumController.deleteAlbums(album.id),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewAlbum(context, id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editAlbum(BuildContext context, Album album) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController titleController =
            TextEditingController(text: album.title);

        return AlertDialog(
          title: const Text("Edit Album"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Titls"),
                ),
                // Add more text fields for other fields as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                albumController.editAlbum(
                  Album(
                    userId: album.userId,
                    title: titleController.text.trim(),
                    id: album.id,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _addNewAlbum(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController titleController = TextEditingController();

        return AlertDialog(
          title: const Text("Add New User"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                // Add more text fields for other fields as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final newAlbum = Album(
                  id: albumController.albums.length + 1,
                  title: titleController.text.trim(),
                  userId: id,
                  // Add other fields as needed
                );
                albumController.addAlbum(newAlbum);
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}

class AlbumController extends GetxController {
  var albums = <Album>[].obs;

  Future<void> fetchFilteredAlbums(int id) async {
    final response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/albums"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      List<dynamic> filteredData =
          data.where((json) => json["userId"] == id).toList();

      albums
          .assignAll(filteredData.map((json) => Album.fromJson(json)).toList());
    } else {
      throw Exception("Failed to load albums");
    }
  }

  Future<void> deleteAlbums(int id) async {
    deleteDialog(() async {
      Get.back();
      easyLoading();

      final response = await http
          .delete(Uri.parse("https://jsonplaceholder.typicode.com/albums/$id"));

      if (response.statusCode == 200) {
        albums.removeWhere((album) => album.id == id);
        Get.back();
      } else {
        Get.back();
        throw Exception("Failed to delete item $id");
      }
    });
  }

  Future<void> editAlbum(Album album) async {
    final Map<String, dynamic> updatedUserJson = {"title": album.title};

    final response = await http.put(
      Uri.parse("https://jsonplaceholder.typicode.com/albums/${album.id}"),
      body: jsonEncode(updatedUserJson),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      int index = albums.indexWhere((a) => a.id == album.id);
      if (index != -1) {
        albums[index] = album;
      }
    } else {
      throw Exception("Failed to update user ${album.id}");
    }
  }

  void addAlbum(Album album) {
    albums.insert(0, album);
  }
}

import 'dart:convert';
import 'package:company_task/task1/album_page.dart';
import 'package:company_task/task1/model/user.dart';
import 'package:company_task/task1/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatelessWidget {
  UserPage({super.key});

  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        titleTextStyle: const TextStyle(
          fontFamily: "nunito",
          color: Colors.black,
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: FutureBuilder(
        future: userController.fetchUsers(),
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
                itemCount: userController.users.length,
                itemBuilder: (context, index) {
                  final user = userController.users[index];

                  return GestureDetector(
                    onTap: () => Get.to(
                      () => AlbumPage(),
                      arguments: user.id,
                      transition: Transition.rightToLeft,
                      curve: Curves.linear,
                      duration: const Duration(milliseconds: 500),
                    ),
                    child: ListTile(
                      title: Text(
                        user.name!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "nunito",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email: ${user.email!}",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontFamily: "nunito",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Company: ${user.company!.name}",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontFamily: "nunito",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Address: ${user.address!.street}, ${user.address!.city}, ${user.address!.zipcode}",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontFamily: "nunito",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _editUser(context, user),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () =>
                                userController.deleteUsers(user.id!),
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
        onPressed: () => _addNewUser(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editUser(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController =
            TextEditingController(text: user.name);
        final TextEditingController emailController =
            TextEditingController(text: user.email);

        return AlertDialog(
          title: const Text(
            "Edit User",
            style: TextStyle(
                fontFamily: "nunito",
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  style: const TextStyle(
                    fontFamily: "nunito",
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: "nunito",
                      )),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
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
                userController.editUser(
                  User(
                    id: user.id,
                    name: nameController.text,
                    email: emailController.text,
                    username: user.username,
                    address: user.address,
                    phone: user.phone,
                    website: user.website,
                    company: user.company,
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

  void _addNewUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController emailController = TextEditingController();

        return AlertDialog(
          title: const Text("Add New User"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
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
                final newUser = User(
                  id: userController.users.length + 1,
                  // Assign a unique ID
                  name: nameController.text,
                  email: emailController.text,
                  address: Address(
                      street: "street",
                      suite: "suite",
                      city: "city",
                      zipcode: "zipcode",
                      geo: Geo(lat: "lat", lng: "lng")),
                  company: Company(
                      name: "name", catchPhrase: "catchPhrase", bs: "bs"),
                  phone: nameController.text,
                  username: nameController.text,
                  website: nameController.text,
                  // Add other fields as needed
                );
                userController.addUser(newUser);
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

class UserController extends GetxController {
  var users = <User>[].obs;

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      users.assignAll(data.map((json) => User.fromJson(json)).toList());
    } else {
      throw Exception("Failed to load users");
    }
  }

  Future<void> deleteUsers(int id) async {
    deleteDialog(() async {
      Get.back();
      easyLoading();

      final response = await http
          .delete(Uri.parse("https://jsonplaceholder.typicode.com/users/$id"));

      if (response.statusCode == 200) {
        users.removeWhere((user) => user.id == id);
        Get.back();
      } else {
        Get.back();
        throw Exception("Failed to delete item $id");
      }
    });
  }

  Future<void> editUser(User user) async {
    final Map<String, dynamic> updatedUserJson = {
      "name": user.name,
      "email": user.email,
    };

    final response = await http.put(
      Uri.parse("https://jsonplaceholder.typicode.com/users/${user.id}"),
      body: jsonEncode(updatedUserJson),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      int index = users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        users[index] = user;
      }
    } else {
      throw Exception("Failed to update user ${user.id}");
    }
  }

  void addUser(User user) {
    users.insert(0, user);
  }
}

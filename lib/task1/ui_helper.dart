import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> deleteDialog(VoidCallback? onPressed) async {
  return Get.dialog(
    barrierDismissible: false,
    WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: const Text(
          "Delete",
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: "nunito",
          ),
        ),
        content: const Text(
          "This Data will be permanently deleted from your list.",
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.black54,
            fontFamily: "nunito",
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.green,
                fontFamily: "nunito",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.green,
                fontFamily: "nunito",
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> easyLoading() {
  return Get.dialog(
    barrierDismissible: false,
    WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Container(
          height: 65.0,
          width: 65.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(17.0),
          child: const CircularProgressIndicator(
            color: Colors.green,
            strokeWidth: 2.2,
          ),
        ),
      ),
    ),
  );
}

Future<void> showNetworkErrorDialog() {
  return Get.dialog(
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 1000),
    WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200.0,
              child: Image.asset("assets/images/no_connection.png"),
            ),
            const SizedBox(height: 32.0),
            const Text(
              "Whoops!",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: "nunito",
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Text(
              "No internet connection found.",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                fontFamily: "nunito",
                color: Colors.grey.shade900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              "Check your connection and try again.",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                fontFamily: "nunito",
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.none) {
                  snackbar("No Internet Connection",
                      "Please turn on wifi or mobile data.");
                } else {
                  Get.back();
                }
              },
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(
                  ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                backgroundColor: MaterialStatePropertyAll(Colors.white54),
                padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 30.0, vertical: 13.0),
                ),
              ),
              child: const Text(
                "Try Again",
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: "nunito",
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

snackbar(String title, String message) {
  Get.snackbar(
    "",
    "",
    titleText: Text(
      title,
      style: const TextStyle(
        fontFamily: "nunito",
        color: Colors.red,
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    messageText: Text(
      message,
      style: const TextStyle(
        fontFamily: "nunito",
        color: Colors.red,
        fontSize: 13.0,
        // fontWeight: FontWeight.bold,
      ),
    ),
    snackPosition: SnackPosition.TOP,
    padding: const EdgeInsets.all(10.0),
    margin: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
    backgroundColor: Colors.grey.shade300,
  );
}

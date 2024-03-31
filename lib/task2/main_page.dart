import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainController controller = Get.put(MainController());

  DateTime now = DateTime.now();

  int? todayDay1;
  int? tomorrowDay1;
  int? afterTomorrowDay1;

  int? todayDay2;
  int? tomorrowDay2;
  int? afterTomorrowDay2;

  @override
  void initState() {
    super.initState();
    todayDay1 = now.day;
    tomorrowDay1 = (now.add(const Duration(days: 1))).day;

    if (now.day == DateTime(now.year, now.month + 1, 0).day) {
      afterTomorrowDay1 = 1;
    } else {
      afterTomorrowDay1 = (now.add(const Duration(days: 2))).day;
    }

    todayDay2 = now.day;
    tomorrowDay2 = (now.add(const Duration(days: 1))).day;

    if (now.day == DateTime(now.year, now.month + 1, 0).day) {
      afterTomorrowDay2 = 1;
    } else {
      afterTomorrowDay2 = (now.add(const Duration(days: 2))).day;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != now) {
      now = picked;
    }
  }

  Widget customButton1(String text, int text1, int index) {
    return GestureDetector(
      onTap: () async {
        controller.setSelectedValue1(index);

        if (controller.selectedIndex1 == 3.obs) {
          _selectDate(Get.context!);
        }
      },
      child: Obx(
        () => Container(
          height: 70.0,
          decoration: BoxDecoration(
            color: (controller.selectedIndex1 == index.obs)
                ? Colors.blueAccent
                : Colors.white,
            border: Border.all(
              color: (controller.selectedIndex1 == index.obs)
                  ? Colors.blue
                  : Colors.grey.shade600,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: (controller.selectedIndex1 == index.obs)
                      ? Colors.white
                      : Colors.grey.shade600,
                  fontFamily: "nunito",
                ),
              ),
              index != 3
                  ? Text(
                      "$text1",
                      style: TextStyle(
                        color: (controller.selectedIndex1 == index.obs)
                            ? Colors.white
                            : Colors.grey.shade600,
                        fontFamily: "nunito",
                      ),
                    )
                  : Text(
                      now.day.toString(),
                      style: TextStyle(
                        color: (controller.selectedIndex1 == index.obs)
                            ? Colors.white
                            : Colors.grey.shade600,
                        fontFamily: "nunito",
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customButton2(String text, int text1, int index) {
    return GestureDetector(
      onTap: () async {
        controller.setSelectedValue2(index);

        if (controller.selectedIndex2 == 3.obs) {
          _selectDate(Get.context!);
        }
      },
      child: Obx(
        () => Container(
          height: 70.0,
          decoration: BoxDecoration(
            color: (controller.selectedIndex2 == index.obs)
                ? Colors.blueAccent
                : Colors.white,
            border: Border.all(
              color: (controller.selectedIndex2 == index.obs)
                  ? Colors.blue
                  : Colors.grey.shade600,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: (controller.selectedIndex2 == index.obs)
                      ? Colors.white
                      : Colors.grey.shade600,
                  fontFamily: "nunito",
                ),
              ),
              index != 3
                  ? Text(
                      "$text1",
                      style: TextStyle(
                        color: (controller.selectedIndex2 == index.obs)
                            ? Colors.white
                            : Colors.grey.shade600,
                        fontFamily: "nunito",
                      ),
                    )
                  : Text(
                      now.day.toString(),
                      style: TextStyle(
                        color: (controller.selectedIndex2 == index.obs)
                            ? Colors.white
                            : Colors.grey.shade600,
                        fontFamily: "nunito",
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  final List<String> morLbl = [
    "Select Time",
    "1:00 AM - 2:00AM",
    "2:00 AM - 3:00AM",
    "3:00 AM - 4:00AM",
    "4:00 AM - 5:00AM",
    "5:00 AM - 6:00AM",
    "6:00 AM - 7:00AM",
    "7:00 AM - 8:00AM",
    "8:00 AM - 9:00AM",
    "9:00 AM - 10:00AM",
    "10:00 AM - 11:00AM",
    "11:00 AM - 12:00AM",
    "12:00 AM - 1:00AM",
  ];
  String _defMobileLbl = "Select Time";

  List<DropdownMenuItem> mor() {
    List<DropdownMenuItem> code = [];
    for (int i = 0; i < morLbl.length; i++) {
      code.add(DropdownMenuItem(value: morLbl[i], child: Text(morLbl[i])));
    }

    return code;
  }

  final List<String> aftLbl = [
    "Select Time",
    "1:00 PM - 2:00PM",
    "2:00 PM - 3:00PM",
    "3:00 PM - 4:00PM",
    "4:00 PM - 5:00PM",
    "5:00 PM - 6:00PM",
    "6:00 PM - 7:00PM",
    "7:00 PM - 8:00PM",
    "8:00 PM - 9:00PM",
    "9:00 PM - 10:00PM",
    "10:00 PM - 11:00PM",
    "11:00 PM - 12:00PM",
    "12:00 PM - 1:00PM",
  ];
  String _defMobileLbl1 = "Select Time";

  List<DropdownMenuItem> aft() {
    List<DropdownMenuItem> code = [];
    for (int i = 0; i < aftLbl.length; i++) {
      code.add(DropdownMenuItem(value: aftLbl[i], child: Text(aftLbl[i])));
    }

    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        titleTextStyle: const TextStyle(
          fontFamily: "nunito",
          color: Colors.black,
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Collection Date & Time",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "nunito",
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: customButton1("Today", todayDay1!, 1)),
                  const SizedBox(width: 20.0),
                  Expanded(child: customButton1("Tomorrow", tomorrowDay1!, 2)),
                  const SizedBox(width: 20.0),
                  Expanded(
                      child:
                          customButton1("Select Date", afterTomorrowDay1!, 3)),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: _defMobileLbl,
                    items: mor(),
                    onChanged: (value) {
                      _defMobileLbl = value;
                    },
                    menuMaxHeight: 350,
                    iconEnabledColor: const Color(0xFF006A68),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 14.0),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF006A68), width: 2.0)),
                      labelText: "Morning",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFF006A68),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: DropdownButtonFormField(
                    value: _defMobileLbl1,
                    items: aft(),
                    onChanged: (value) {
                      _defMobileLbl = value;
                    },
                    menuMaxHeight: 350,
                    iconEnabledColor: const Color(0xFF006A68),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 14.0),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF006A68), width: 2.0)),
                      labelText: "Afternoon",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFF006A68),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            const Text(
              "Select Delivery Date & Time",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "nunito",
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: customButton2("Today", todayDay2!, 1)),
                  const SizedBox(width: 20.0),
                  Expanded(child: customButton2("Tomorrow", tomorrowDay2!, 2)),
                  const SizedBox(width: 20.0),
                  Expanded(
                      child:
                          customButton2("Select Date", afterTomorrowDay2!, 3)),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: _defMobileLbl,
                    items: mor(),
                    onChanged: (value) {
                      _defMobileLbl = value;
                    },
                    menuMaxHeight: 350,
                    iconEnabledColor: const Color(0xFF006A68),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 14.0),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF006A68), width: 2.0)),
                      labelText: "Morning",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFF006A68),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: DropdownButtonFormField(
                    value: _defMobileLbl1,
                    items: aft(),
                    onChanged: (value) {
                      _defMobileLbl1 = value;
                    },
                    menuMaxHeight: 350,
                    iconEnabledColor: const Color(0xFF006A68),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 14.0),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF006A68), width: 2.0)),
                      labelText: "Afternoon",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFF006A68),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter your code here")));
              },
              style: const ButtonStyle(
                minimumSize:
                    MaterialStatePropertyAll(Size(double.infinity, 50.0)),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                backgroundColor: MaterialStatePropertyAll(Colors.blueAccent),
              ),
              child: const Text("Continue"),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}

class MainController extends GetxController {
  RxInt selectedIndex1 = 1.obs;
  RxInt selectedIndex2 = 2.obs;

  void setSelectedValue1(int value) {
    selectedIndex1.value = value;
  }

  void setSelectedValue2(int value) {
    selectedIndex2.value = value;
  }
}

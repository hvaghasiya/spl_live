import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/game_mode_controller.dart';

class AddBidScreen extends GetView<GameModeController> {
  const AddBidScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("fjdsfgsjdf");
    return Scaffold(appBar: AppBar(title: const Text('ADD Bid')), body: SingleChildScrollView(child: Column(children: buildsangamtextFields())));
  }

  List<Widget> buildsangamtextFields() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              return Text(controller.selectedgameMode.value);
            }),
            Obx(() {
              return Text(controller.gameMode.value);
            }),
          ],
        ),
      ),
      if (controller.selectedgameMode.value == "Odd Even")
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return GestureDetector(
                onTap: () {
                  controller.selectedOddEven.value = "odd";
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: controller.selectedOddEven.value == "odd" ? Colors.green : Colors.transparent,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text("Odd", style: const TextStyle(fontSize: 16)),
                ),
              );
            }),
            SizedBox(width: 10),
            Obx(() {
              return GestureDetector(
                onTap: () {
                  controller.selectedOddEven.value = "even";
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: controller.selectedOddEven.value == "even" ? Colors.green : Colors.transparent,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text("Even", style: const TextStyle(fontSize: 16)),
                ),
              );
            }),
          ],
        ),

      buildTextFileds(),

      SizedBox(height: 20),
      if (!(controller.selectedgameMode.value == "Jodi Bulk" ||
          controller.selectedgameMode.value == "Single Ank Bulk" ||
          controller.selectedgameMode.value == "Single Pana Bulk" ||
          controller.selectedgameMode.value == "Double Pana Bulk"))
        TextButton(
          onPressed: controller.addBid,
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
          child: Text("Add", style: TextStyle(color: Colors.white)),
        ),
      SizedBox(height: 20),
      Obx(() {
        if ((controller.selectedgameMode.value == "Single Pana Bulk" || controller.selectedgameMode.value == "Double Pana Bulk") &&
            controller.selectedBidList.value.isEmpty) {
          return SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var item = controller.jsonData["single_digit"][index];
                return GestureDetector(
                  onTap: () {
                    controller.selectedBulkAnk.value = item;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                      child: Text(item, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                );
              },
              itemCount: controller.jsonData["single_digit"].length,
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
      Obx(() {
        if ((controller.selectedgameMode.value == "Jodi Bulk" ||
                controller.selectedgameMode.value == "Single Ank Bulk" ||
                controller.selectedgameMode.value == "Single Pana Bulk" ||
                controller.selectedgameMode.value == "Double Pana Bulk") &&
            controller.selectedBidList.value.isEmpty) {
          return BulkChoiceListWidget(
            choiceList: controller.getchoiceList(),
            validate: () {
              if (controller.pointTextEditingController.text.isEmpty) {
                Get.snackbar("Error", "Please enter a valid points");
                return false;
              }
              return true;
            },
            OnTapSave: (selectedlist) {
              if (selectedlist.isEmpty) {
                Get.snackbar("Error", "Please Select at least one Bid");
                return;
              }
              print("fsdkfjhgsfkjdhksdjh");
              print(selectedlist);
              controller.addBulkBid(selectedlist);
            },
          );
        } else {
          return const SizedBox();
        }
      }),

      SizedBox(height: 20),
      Obx(() {
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,`
          itemCount: controller.selectedBidList.value.length,
          itemBuilder: (context, index) {
            SeletedBidList selectedBid = controller.selectedBidList.value[index];
            var pana = "";
            print("fskhfgkfjdfhkdjf");
            print(controller.selectedgameMode.value);
            if (controller.selectedgameMode.value == "Half Sangam A") {
              pana = "${selectedBid.sangamopen}-${selectedBid.sangamclose}";
            } else if (controller.selectedgameMode.value == "Half Sangam B") {
              pana = "${selectedBid.sangamopen}-${selectedBid.sangamclose}";
            } else if (controller.selectedgameMode.value == "Full Sangam") {
              pana = "${selectedBid.sangamopen}-${selectedBid.sangamclose}";
            } else {
              pana = selectedBid.pana;
            }
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(pana), Text("point: ${selectedBid.points} "), Container()],
              ),
              trailing: IconButton(
                onPressed: () {
                  controller.deleteBid(index);
                },
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            );
          },
        );
      }),
    ];
  }

  Column buildSangamTextFileds() {
    var maxLength1 = 1;
    var maxLength2 = 1;
    var hintText1 = "";
    var hintText2 = "";
    var label1 = '';
    var label2 = '';
    if (controller.selectedgameMode.value == "Half Sangam B") {
      maxLength1 = 3;
      maxLength2 = 1;
      hintText1 = "Enter Pana";
      hintText2 = "Enter Digit";
      label1 = "Open Pana";
      label2 = "CLOse Digit";
    }
    if (controller.selectedgameMode.value == "Half Sangam A") {
      maxLength1 = 1;
      maxLength2 = 3;
      hintText2 = "Enter Pana";
      hintText1 = "Enter Digit";
      label1 = "Open Digit";
      label2 = "CLOse Pana";
    }
    if (controller.selectedgameMode.value == "Full Sangam") {
      maxLength1 = 3;
      maxLength2 = 3;
      hintText1 = "Enter Pana";
      hintText2 = "Enter Pana";
      label1 = "OPEN Pana";
      label2 = "CLOSE Pana";
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label1),
        TextField(
          maxLength: maxLength1,
          controller: controller.openTextEditingController,
          decoration: InputDecoration(hintText: hintText1),
          keyboardType: TextInputType.number,
        ),
        Text(label2),
        TextField(
          maxLength: maxLength2,
          controller: controller.closeTextEditingController,
          decoration: InputDecoration(hintText: hintText2),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  buildTextFileds() {
    var maxLength = 1;
    var hintText = "";
    if (controller.selectedgameMode.value == "Single Ank") {
      maxLength = 1;
      hintText = "Enter Single Ank";
    }
    if (controller.selectedgameMode.value == "Jodi") {
      maxLength = 2;
      hintText = "Enter Jodi";
    }
    if (controller.selectedgameMode.value == "Single Pana") {
      maxLength = 3;
      hintText = "Enter Single Pana";
    }
    if (controller.selectedgameMode.value == "Double Pana") {
      maxLength = 3;
      hintText = "Enter Double Pana";
    }
    if (controller.selectedgameMode.value == "Tripple Pana") {
      maxLength = 3;
      hintText = "Enter Tripple Pana";
    }
    if (controller.selectedgameMode.value == "Panel Group") {
      maxLength = 3;
      hintText = "Enter Panel Group";
    }
    if (controller.selectedgameMode.value == "Red Brackets") {
      maxLength = 2;
      hintText = "Enter Red Brackets";
    }
    if (controller.selectedgameMode.value == "Two Digits Panel") {
      maxLength = 2;
      hintText = "Enter Two Digits Panel";
    }
    if (controller.selectedgameMode.value == "Group Jodi") {
      maxLength = 2;
      hintText = "Enter Group Jodi";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          if (!(controller.selectedgameMode.value == "Jodi Bulk" ||
              controller.selectedgameMode.value == "Single Ank Bulk" ||
              controller.selectedgameMode.value == "Single Pana Bulk" ||
              controller.selectedgameMode.value == "Double Pana Bulk" ||
              controller.selectedgameMode.value == "Odd Even" ||
              controller.selectedgameMode.value == "Digits Based Jodi" ||
              controller.selectedgameMode.value == "Half Sangam A" ||
              controller.selectedgameMode.value == "Half Sangam B" ||
              controller.selectedgameMode.value == "Full Sangam"))
            TextField(
              maxLength: maxLength,
              controller: controller.ankTextEditingController,
              decoration: InputDecoration(hintText: hintText),
              keyboardType: TextInputType.number,
            ),
          if (controller.selectedgameMode.value == "Digits Based Jodi")
            TextField(
              maxLength: 1,
              controller: controller.leftAnkTextEditingController,
              decoration: InputDecoration(hintText: "Enter Left Ank"),
              keyboardType: TextInputType.number,
            ),
          if (controller.selectedgameMode.value == "Digits Based Jodi")
            TextField(
              maxLength: 1,
              controller: controller.rightAnkTextEditingController,
              decoration: InputDecoration(hintText: "Enter Right Ank"),
              keyboardType: TextInputType.number,
            ),
          buildSangamTextFileds(),
          TextField(
            controller: controller.pointTextEditingController,
            decoration: InputDecoration(hintText: "Enter Points"),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

class BulkChoiceListWidget extends StatefulWidget {
  final choiceList;

  final OnTapSave;
  final validate;

  const BulkChoiceListWidget({super.key, this.choiceList, this.OnTapSave, this.validate});

  @override
  State<BulkChoiceListWidget> createState() => _BulkChoiceListWidgetState();
}

class _BulkChoiceListWidgetState extends State<BulkChoiceListWidget> {
  List selectedlist = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6, // Adjust height as needed

      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                shrinkWrap: true,
                itemCount: widget.choiceList.length,
                itemBuilder: (context, index) {
                  var item = widget.choiceList[index];
                  return GestureDetector(
                    onTap: () {
                      if (widget.validate()) {
                        setState(() {
                          if (selectedlist.contains(item)) {
                            selectedlist.remove(item);
                          } else {
                            selectedlist.add(item);
                          }
                        });
                      }
                    },

                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: selectedlist.contains(item) ? Colors.blue : Colors.red),
                          ),
                          SizedBox(width: 10),
                          Text(item),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              widget.OnTapSave(selectedlist);
            },
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
            child: Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

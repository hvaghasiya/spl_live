import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/game_mode_controller.dart';

class GameModeScreen extends GetView<GameModeController> {
  const GameModeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameModeController>(
      init: GameModeController(),
      assignId: true,
      builder: (logic) {
        print(controller.openGameModeList.value.length);
        print(controller.closeGameModeList.value.length);
        return Scaffold(
          appBar: AppBar(title: const Text('Game Mode')),
          body: Column(
            children: [
              Center(
                child: SizedBox(
                  height: 50,
                  child: Obx(() {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.gameModeList.length,
                      itemBuilder: (context, index) {
                        final mode = controller.gameModeList[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: InkWell(
                            onTap: () {
                              controller.onModeChange(mode);
                            },
                            child: Obx(() {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                color: mode == controller.gameMode.value ? Colors.blue : Colors.grey,
                                // Ensure each item has a width
                                alignment: Alignment.center,
                                child: Text(
                                  controller.gameModeList[index],
                                  style: TextStyle(color: mode == controller.gameMode.value ? Colors.white : Colors.black),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              SizedBox(height: 20),
              Obx(() {
                return buildGameMode(controller.gameMode.value == "Open" ? controller.openGameModeList.value : controller.closeGameModeList.value);
              }),
            ],
          ),
        );
      },
    );
  }

  Wrap buildGameMode(List list) {
    return Wrap(
      runSpacing: 0.0,
      spacing: 0.0,
      children:
          list.map<Widget>((gameMode) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  controller.reset("All");
                  controller.onGameModeChange(gameMode);
                },
                child: Obx(() {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    color: gameMode == controller.selectedgameMode.value ? Colors.blue : Colors.grey,
                    child: Text(gameMode, style: TextStyle(color: Colors.white)),
                  );
                }),
              ),
            );
          }).toList(),
    );
  }
}

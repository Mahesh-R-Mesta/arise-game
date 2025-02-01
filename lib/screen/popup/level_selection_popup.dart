import 'package:arise_game/service/local_storage.dart';
import 'package:arise_game/util/widget/wooden_button.dart';
import 'package:flutter/material.dart';

class LevelSelection extends StatelessWidget {
  final BuildContext context;
  final Function(int) onLevelSelect;
  const LevelSelection({super.key, required this.context, required this.onLevelSelect});

  show() => showDialog(
      context: context,
      builder: (ctx) => LevelSelection(
          context: ctx,
          onLevelSelect: (level) {
            Navigator.of(ctx).pop();
            onLevelSelect.call(level);
          }));

  @override
  Widget build(BuildContext context) {
    final levelCompleted = LocalStorage.instance.maxLevelCompleted;
    return Center(
        child: Material(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  WoodenButton(text: "Level-1", size: Size(150, 50), onTap: () => onLevelSelect.call(1)),
                  Opacity(
                      opacity: levelCompleted >= 2 ? 1 : 0.5,
                      child: WoodenButton(text: "Level-2", size: Size(150, 50), onTap: () => levelCompleted >= 2 ? onLevelSelect.call(2) : null)),
                  Opacity(
                      opacity: levelCompleted >= 3 ? 1 : 0.5,
                      child: WoodenButton(text: "Level-3", size: Size(150, 50), onTap: () => levelCompleted >= 3 ? onLevelSelect.call(3) : null)),
                ],
              ),
            )));
  }
}

import 'package:feeling_note/datas/read_page_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const ActionButton({Key? key, required this.onPressed, required this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).primaryColor,
        elevation: 4.0,
        child: IconButton(
          onPressed: () {
            ref.watch(readPageStateProvider).setIsFabOpen = false;
            onPressed();
          },
          icon: icon,
        ),
      );
    });
  }
}

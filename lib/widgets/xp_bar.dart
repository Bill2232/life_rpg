import 'package:flutter/material.dart';

class XPBar extends StatelessWidget {
  final int xp;
  final int max;

  const XPBar({super.key, required this.xp, required this.max});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("XP: $xp / $max"),
        SizedBox(height: 6),
        LinearProgressIndicator(value: xp / max),
      ],
    );
  }
}

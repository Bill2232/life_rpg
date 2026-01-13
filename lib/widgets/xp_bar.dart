import 'package:flutter/material.dart';

class XPBar extends StatelessWidget {
  final int xp;
  final int max;

  const XPBar({super.key, required this.xp, required this.max});

  @override
  Widget build(BuildContext context) {
    final ratio = (max > 0 ? (xp / max) : 0.0).clamp(0.0, 1.0);
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: ratio,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Center(
            child: Text(
              "$xp / $max",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

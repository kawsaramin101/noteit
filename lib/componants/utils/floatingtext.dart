import 'package:flutter/material.dart';

void showFloatingText(BuildContext context, String message, {int time = 3}) {
  final overlay = Overlay.of(context);
  final screenHeight = MediaQuery.of(context).size.height;
  final bottomOffset = screenHeight * 0.20;

  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: bottomOffset,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 300),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((0.6 * 255).toInt()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(Duration(seconds: time)).then((_) {
    overlayEntry.remove();
  });
}

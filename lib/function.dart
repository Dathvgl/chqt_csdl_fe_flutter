import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String thousandDot(int num) {
  NumberFormat number = NumberFormat("#,##0");
  return number.format(num).replaceAll(",", ".");
}

void snackBar({
  required BuildContext context,
  required String text,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 1),
      backgroundColor: const Color(0xFFB71C1C),
    ),
  );
}

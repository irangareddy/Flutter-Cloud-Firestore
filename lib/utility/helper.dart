import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showSnackbar(BuildContext context, String message) async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1200),
      ));
    }

String getReleaseDate(Timestamp timestamp) {
    String convertedDate = DateFormat.yMMMd().format(timestamp.toDate());
    return convertedDate;
}

DateTime getDateTime(Timestamp timestamp) {
  return timestamp.toDate();
}
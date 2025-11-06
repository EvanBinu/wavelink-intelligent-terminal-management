import 'package:flutter/material.dart';

class NavigationHelper {
  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?> replaceWith<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }
}



import 'package:flutter/material.dart';

/// Lets child widgets switch the main bottom navigation tab.
class AppTabScope extends InheritedWidget {
  const AppTabScope({super.key, required this.selectTab, required super.child});

  final ValueChanged<int> selectTab;

  static AppTabScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppTabScope>();
  }

  @override
  bool updateShouldNotify(AppTabScope oldWidget) => false;
}

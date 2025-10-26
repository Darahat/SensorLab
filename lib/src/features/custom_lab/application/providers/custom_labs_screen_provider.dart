import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabControllerProvider = StateProvider<TabController?>((ref) => null);

final currentTabIndexProvider = StateProvider<int>((ref) {
  final controller = ref.watch(tabControllerProvider);
  return controller?.index ?? 0;
});

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final likeStateProvider = StateNotifierProvider.family<LikeStateNotifier, bool, String>((ref, imageName) {
  return LikeStateNotifier(imageName);
});

class LikeStateNotifier extends StateNotifier<bool> {
  final String imageName;
  LikeStateNotifier(this.imageName) : super(false) {
    _initState();
  }

  Future<void> _initState() async {
    if (!Hive.isBoxOpen('likes')) {
      await Hive.openBox<bool>('likes');
    }
    final box = Hive.box<bool>('likes');
    state = box.get(imageName) ?? false;
  }

  void toggleLike() {
    state = !state;
    if (Hive.isBoxOpen('likes')) {
      final box = Hive.box<bool>('likes');
      box.put(imageName, state);
    }
  }
}

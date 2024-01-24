import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final likeStateProvider = StateNotifierProvider.family<LikeStateNotifier, bool, String>((ref, imageName) {
  return LikeStateNotifier(imageName);
});

class LikeStateNotifier extends StateNotifier<bool> {
  final String imageName;
  LikeStateNotifier(this.imageName) : super(Hive.box<bool>('likes').get(imageName) ?? false);

  void toggleLike() {
    state = !state;
    Hive.box<bool>('likes').put(imageName, state);
  }
}
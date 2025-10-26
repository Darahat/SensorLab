import 'package:flutter_riverpod/flutter_riverpod.dart';

final customLabsScreenLoadingProvider = StateProvider<bool>((ref) => false);

final customLabsScreenErrorProvider = StateProvider<String?>((ref) => null);

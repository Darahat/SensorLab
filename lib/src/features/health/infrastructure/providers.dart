import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/services/hive_service.dart';
import 'package:sensorlab/src/features/health/domain/repositories/activity_session_repository.dart';
import 'package:sensorlab/src/features/health/domain/repositories/user_profile_repository.dart';
import 'package:sensorlab/src/features/health/infrastructure/repositories/activity_session_repository_impl.dart';
import 'package:sensorlab/src/features/health/infrastructure/repositories/user_profile_repository_impl.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return UserProfileRepositoryImpl(hiveService.userProfileBox);
});

final activitySessionRepositoryProvider = Provider<ActivitySessionRepository>((
  ref,
) {
  final hiveService = ref.watch(hiveServiceProvider);
  return ActivitySessionRepositoryImpl(hiveService.activitySessionBox);
});

/// HiveConstants is the carrier of hive boxes names
class HiveConstants {
  // Box for TextEntry model (typeId: 0)

  /// The file name for the local database.
  static const String databaseName = 'sensorlab/src.db';

  /// The version of the local database schema.
  static const int databaseVersion = 1;

  /// The Hive box used for general settings.
  static const String settingsBoxName = 'settings';

  /// table for user information saving and authentication
  static const String authBox = "user_auth_box";

  /// hive box for tasks
  static const String taskBox = "task_box";

  /// hive box for tasks
  static const String aiChatBox = "sensorlab/src_box";

  /// hive box for user to user chat
  static const String uTouChatBox = "uTou_chat_box";

  /// hive box for user profile
  static const String userProfileBox = "user_profile_box";

  /// hive box for activity session
  static const String activitySessionBox = "activity_session_box";
}

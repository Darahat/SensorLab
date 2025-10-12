// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'SensorLab';

  @override
  String get signInToContinue => '続行するにはサインインしてください';

  @override
  String get welcome => 'ようこそ';

  @override
  String get home => 'ホーム';

  @override
  String get cancel => 'キャンセル';

  @override
  String get done => '完了';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get search => '検索';

  @override
  String get settings => '設定';

  @override
  String get retry => '再試行';

  @override
  String get error => 'エラー';

  @override
  String get loading => '読み込み中';

  @override
  String get failedToLoadSettings => '設定の読み込みに失敗しました';

  @override
  String get appearance => '外観';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get switchBetweenLightAndDarkThemes => 'ライトとダークテーマを切り替える';

  @override
  String get system => 'システム';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get notificationsAndFeedback => '通知とフィードバック';

  @override
  String get notifications => '通知';

  @override
  String get receiveAppNotifications => 'アプリ通知を受信する';

  @override
  String get vibration => '振動';

  @override
  String get hapticFeedbackForInteractions => '操作時の触覚フィードバック';

  @override
  String get soundEffects => '効果音';

  @override
  String get audioFeedbackForAppActions => 'アプリの操作に対する音のフィードバック';

  @override
  String get sensorSettings => 'センサー設定';

  @override
  String get autoScan => '自動スキャン';

  @override
  String get automaticallyScanWhenOpeningScanner => 'スキャナーを開いたときに自動でスキャン';

  @override
  String get sensorUpdateFrequency => 'センサー更新頻度';

  @override
  String sensorUpdateFrequencySubtitle(int frequency) {
    return '$frequency ms 間隔';
  }

  @override
  String get privacyAndData => 'プライバシーとデータ';

  @override
  String get dataCollection => 'データ収集';

  @override
  String get allowAnonymousUsageAnalytics => '匿名の使用分析を許可する';

  @override
  String get privacyMode => 'プライバシーモード';

  @override
  String get enhancedPrivacyProtection => '強化されたプライバシー保護';

  @override
  String get appSupport => 'アプリサポート';

  @override
  String get showAds => '広告を表示';

  @override
  String get supportAppDevelopment => 'アプリ開発をサポート';

  @override
  String get resetSettings => '設定をリセット';

  @override
  String get resetAllSettingsToDefaultValues =>
      'すべての設定をデフォルト値にリセットします。この操作は元に戻せません。';

  @override
  String get resetToDefaults => 'デフォルトにリセット';

  @override
  String get chooseSensorUpdateFrequency => 'センサーの更新頻度を選択：';

  @override
  String get fastUpdate => '50 ms（高速）';

  @override
  String get normalUpdate => '100 ms（通常）';

  @override
  String get slowUpdate => '200 ms（低速）';

  @override
  String get verySlowUpdate => '500 ms（非常に低速）';

  @override
  String get apply => '適用';

  @override
  String get confirmReset => 'リセット確認';

  @override
  String get areYouSureResetSettings => '全ての設定をデフォルト値にリセットしてよろしいですか？';

  @override
  String get thisActionCannotBeUndone => 'この操作は元に戻せません。';

  @override
  String get reset => 'リセット';

  @override
  String get accelerometer => '加速度計';

  @override
  String get compass => 'コンパス';

  @override
  String get flashlight => '懐中電灯';

  @override
  String get gyroscope => 'ジャイロスコープ';

  @override
  String get health => '健康';

  @override
  String get humidity => '湿度';

  @override
  String get lightMeter => '光メーター';

  @override
  String get magnetometer => '磁力計';

  @override
  String get noiseMeter => '騒音計';

  @override
  String get proximity => '近接';

  @override
  String get heartRate => '心拍数';

  @override
  String get calorieBurn => '消費カロリー';

  @override
  String get scanner => 'スキャナー';

  @override
  String get qrCode => 'QRコード';

  @override
  String get barcode => 'バーコード';

  @override
  String get qrCodeScanner => 'QRコードスキャナー';

  @override
  String get barcodeScanner => 'バーコードスキャナー';

  @override
  String get scanResult => 'スキャン結果';

  @override
  String get plainText => 'プレーンテキスト';

  @override
  String get websiteUrl => 'ウェブサイト URL';

  @override
  String get emailAddress => 'メールアドレス';

  @override
  String get phoneNumber => '電話番号';

  @override
  String get smsMessage => 'SMS メッセージ';

  @override
  String get wifiNetwork => 'WiFi ネットワーク';

  @override
  String get contactInfo => '連絡先情報';

  @override
  String get location => '位置情報';

  @override
  String get product => '製品';

  @override
  String get calendarEvent => 'カレンダーイベント';

  @override
  String get quickResponseCode => 'クイック応答コード';

  @override
  String get europeanArticleNumber13 => 'ヨーロッパ記事番号（13桁）';

  @override
  String get europeanArticleNumber8 => 'ヨーロッパ記事番号（8桁）';

  @override
  String get universalProductCode12 => 'ユニバーサル製品コード（12桁）';

  @override
  String get universalProductCode8 => 'ユニバーサル製品コード（8桁）';

  @override
  String get code128 => 'コード128（可変長）';

  @override
  String get code39 => 'コード39（英数字）';

  @override
  String get code93 => 'コード93（英数字）';

  @override
  String get codabar => 'Codabar（特殊文字付き数字）';

  @override
  String get interleaved2of5 => 'インタリーブド2 of 5';

  @override
  String get dataMatrix => 'データマトリックス（2D）';

  @override
  String get aztecCode => 'アズテックコード（2D）';

  @override
  String get torchNotAvailableOnDevice => 'このデバイスではトーチは利用できません';

  @override
  String get failedToInitializeFlashlight => '懐中電灯の初期化に失敗しました';

  @override
  String get failedToToggleFlashlight => '懐中電灯の切り替えに失敗しました';

  @override
  String get cameraIsInUse => 'カメラが使用中です';

  @override
  String get torchNotAvailable => 'トーチは利用できません';

  @override
  String get failedToEnableTorch => 'トーチの有効化に失敗しました';

  @override
  String get failedToDisableTorch => 'トーチの無効化に失敗しました';

  @override
  String get intensityControlNotSupported =>
      '強度制御は torch_light パッケージでサポートされていません';

  @override
  String get failedToSetMode => 'モードの設定に失敗しました';

  @override
  String get failedToPerformQuickFlash => 'クイック フラッシュの実行に失敗しました';

  @override
  String get noCamerasFound => 'カメラが見つかりません';

  @override
  String get readyCoverCameraWithFinger => '準備完了：カメラを指で覆ってください';

  @override
  String get cameraError => 'カメラ エラー';

  @override
  String get placeFingerFirmlyOnCamera => '指をしっかりカメラに当ててください';

  @override
  String get pressFingerFirmlyOnCamera => '指をしっかりカメラに押してください';

  @override
  String get fingerMovedPlaceFirmlyOnCamera => '指が動きました。しっかりカメラに当ててください';

  @override
  String heartRateBpm(int bpm) {
    return '心拍数：$bpm BPM';
  }

  @override
  String get holdStill => 'じっとして…';

  @override
  String get adjustFingerPressure => '指の圧力を調整してください';

  @override
  String get flashError => 'フラッシュ エラー';

  @override
  String get editProfile => 'プロフィール編集';

  @override
  String get weightKg => '体重 (kg)';

  @override
  String get heightCm => '身長 (cm)';

  @override
  String get male => '男性';

  @override
  String get female => '女性';

  @override
  String get other => 'その他';

  @override
  String get saveProfile => 'プロフィールを保存';

  @override
  String get enterYourDetails => '情報を入力してください';

  @override
  String get initializationFailed => '初期化に失敗しました';
}

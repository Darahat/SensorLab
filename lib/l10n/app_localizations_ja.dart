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
  String get switchBetweenLightAndDarkThemes => 'ライトモードとダークモードを切り替える';

  @override
  String get system => 'システム';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get language => '言語';

  @override
  String get languageSubtitle => '好みの言語を選択してください';

  @override
  String get notificationsAndFeedback => '通知とフィードバック';

  @override
  String get notifications => '通知';

  @override
  String get receiveAppNotifications => 'アプリの通知を受け取る';

  @override
  String get vibration => 'バイブレーション';

  @override
  String get hapticFeedbackForInteractions => '操作に対する触覚フィードバック';

  @override
  String get soundEffects => 'サウンド効果';

  @override
  String get audioFeedbackForAppActions => '操作に対する音声フィードバック';

  @override
  String get sensorSettings => 'センサー設定';

  @override
  String get autoScan => '自動スキャン';

  @override
  String get automaticallyScanWhenOpeningScanner => 'スキャナーを開いたときに自動的にスキャンする';

  @override
  String get sensorUpdateFrequency => 'センサー更新頻度';

  @override
  String sensorUpdateFrequencySubtitle(int frequency) {
    return '${frequency}ms 間隔';
  }

  @override
  String get privacyAndData => 'プライバシーとデータ';

  @override
  String get dataCollection => 'データ収集';

  @override
  String get allowAnonymousUsageAnalytics => '匿名の利用分析を許可する';

  @override
  String get privacyMode => 'プライバシーモード';

  @override
  String get enhancedPrivacyProtection => '強化プライバシー保護';

  @override
  String get appSupport => 'アプリサポート';

  @override
  String get showAds => '広告を表示';

  @override
  String get supportAppDevelopment => 'アプリ開発を支援する';

  @override
  String get resetSettings => '設定をリセット';

  @override
  String get resetAllSettingsToDefaultValues => 'すべての設定をデフォルト値に戻します。この操作は元に戻せません。';

  @override
  String get resetToDefaults => 'デフォルトに戻す';

  @override
  String get chooseSensorUpdateFrequency => 'センサーの更新頻度を選択してください：';

  @override
  String get fastUpdate => '50ms（高速）';

  @override
  String get normalUpdate => '100ms（標準）';

  @override
  String get slowUpdate => '200ms（低速）';

  @override
  String get verySlowUpdate => '500ms（非常に低速）';

  @override
  String get apply => '適用';

  @override
  String get confirmReset => 'リセットを確認';

  @override
  String get areYouSureResetSettings => 'すべての設定を既定値に戻してもよろしいですか？';

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
  String get lightMeter => '照度計';

  @override
  String get magnetometer => '磁力計';

  @override
  String get noiseMeter => '騒音計';

  @override
  String get proximity => '近接';

  @override
  String get speedMeter => '速度計';

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
  String get wifiNetwork => 'Wi-Fi ネットワーク';

  @override
  String get contactInfo => '連絡先情報';

  @override
  String get location => '位置情報';

  @override
  String get product => '製品';

  @override
  String get calendarEvent => 'カレンダーイベント';

  @override
  String get quickResponseCode => 'QR コード';

  @override
  String get europeanArticleNumber13 => '欧州記事番号 (13 桁)';

  @override
  String get europeanArticleNumber8 => '欧州記事番号 (8 桁)';

  @override
  String get universalProductCode12 => 'ユニバーサル商品コード (12 桁)';

  @override
  String get universalProductCode8 => 'ユニバーサル商品コード (8 桁)';

  @override
  String get code128 => 'コード 128（可変長）';

  @override
  String get code39 => 'コード 39（英数字）';

  @override
  String get code93 => 'コード 93（英数字）';

  @override
  String get codabar => 'Codabar（特殊文字付き数字）';

  @override
  String get interleaved2of5 => 'インターリーブ 2 of 5';

  @override
  String get dataMatrix => 'Data Matrix (2D)';

  @override
  String get aztecCode => 'Aztec コード (2D)';

  @override
  String get torchNotAvailableOnDevice => 'このデバイスでは懐中電灯が利用できません';

  @override
  String get failedToInitializeFlashlight => '懐中電灯の初期化に失敗しました';

  @override
  String get failedToToggleFlashlight => '懐中電灯の切り替えに失敗しました';

  @override
  String get cameraIsInUse => 'カメラが使用中です';

  @override
  String get torchNotAvailable => '懐中電灯が利用できません';

  @override
  String get failedToEnableTorch => '懐中電灯を有効にできませんでした';

  @override
  String get failedToDisableTorch => '懐中電灯を無効にできませんでした';

  @override
  String get intensityControlNotSupported => 'torch_light パッケージでは強度制御をサポートしていません';

  @override
  String get failedToSetMode => 'モード設定に失敗しました';

  @override
  String get failedToPerformQuickFlash => 'クイックフラッシュの実行に失敗しました';

  @override
  String get noCamerasFound => 'カメラが見つかりません';

  @override
  String get readyCoverCameraWithFinger => '準備完了 — カメラを指で覆ってください';

  @override
  String get cameraError => 'カメラエラー';

  @override
  String get placeFingerFirmlyOnCamera => 'カメラの上に指をしっかり置いてください';

  @override
  String get pressFingerFirmlyOnCamera => 'カメラの上に指をしっかり押し当ててください';

  @override
  String get fingerMovedPlaceFirmlyOnCamera => '指が動きました — しっかり置き直してください';

  @override
  String heartRateBpm(int bpm) {
    return '心拍数: $bpm BPM';
  }

  @override
  String get holdStill => '動かないでください…';

  @override
  String get adjustFingerPressure => '指の圧力を調整してください';

  @override
  String get flashError => 'フラッシュエラー';

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
  String get enterYourDetails => '詳細を入力してください';

  @override
  String get initializationFailed => '初期化に失敗しました';

  @override
  String get allYourSensorsInOnePlace => 'すべてのセンサーを一か所に';

  @override
  String get noSensorsAvailable => '使用可能なセンサーがありません';

  @override
  String get active => 'アクティブ';

  @override
  String get moveYourDevice => 'デバイスを動かしてください';

  @override
  String get accelerationUnit => '加速度 (m/s²)';

  @override
  String get axis => '軸';

  @override
  String get current => '現在';

  @override
  String get max => '最大';

  @override
  String get xAxis => 'X';

  @override
  String get yAxis => 'Y';

  @override
  String get zAxis => 'Z';

  @override
  String get calibrate => 'キャリブレーション';

  @override
  String get calibrating => 'キャリブレーション中…';

  @override
  String get magneticHeading => '磁気方位';

  @override
  String get highAccuracy => '高精度';

  @override
  String get compassError => 'コンパスエラー';

  @override
  String get resetSession => 'セッションをリセット';

  @override
  String get flashlightNotAvailable => '懐中電灯が利用できません';

  @override
  String get initializingFlashlight => '懐中電灯を初期化中…';

  @override
  String get deviceDoesNotHaveFlashlight => 'デバイスに懐中電灯がないかアクセスできません';

  @override
  String get tryAgain => 'もう一度';

  @override
  String get quickFlash => 'クイックフラッシュ';

  @override
  String get turnOff => 'オフ';

  @override
  String get turnOn => 'オン';

  @override
  String get intensityControl => '強度制御';

  @override
  String currentIntensity(String intensity) {
    return '現在: $intensity';
  }

  @override
  String get flashlightModes => '懐中電灯モード';

  @override
  String get normal => '通常';

  @override
  String get strobe => 'ストロボ';

  @override
  String get sos => 'SOS';

  @override
  String get sessionStatistics => 'セッション統計';

  @override
  String get sessionTime => 'セッション時間';

  @override
  String get toggles => '切替';

  @override
  String get onTime => 'オン時間';

  @override
  String get batteryUsage => 'バッテリー使用量';

  @override
  String get batteryUsageWarning => 'バッテリー使用警告';

  @override
  String flashlightOnFor(String time) {
    return '懐中電灯は $time 間オン状態です。省エネのためオフをご検討ください。';
  }

  @override
  String get usageTips => '使用のヒント';

  @override
  String get normalMode => '通常モード';

  @override
  String get normalModeDescription => '標準的な懐中電灯操作';

  @override
  String get strobeMode => 'ストロボモード';

  @override
  String get strobeModeDescription => '点滅ライトで注目を集める';

  @override
  String get sosMode => 'SOSモード';

  @override
  String get sosModeDescription => '緊急信号（… --- …）';

  @override
  String get battery => 'バッテリー';

  @override
  String get batteryTip => 'バッテリー消費を抑えるためにモニタリングしてください';

  @override
  String get intensity => '強度';

  @override
  String get intensityTip => '明るさを調整して電力を節約';

  @override
  String get pressButtonToGetLocation => 'ボタンを押して位置を取得';

  @override
  String get addressWillAppearHere => '住所がここに表示されます';

  @override
  String get locationServicesDisabled => '位置情報サービスが無効です';

  @override
  String get locationPermissionDenied => '位置情報の許可が拒否されました';

  @override
  String get locationPermissionsPermanentlyDenied => '位置情報の許可が永久に拒否されました';

  @override
  String errorGettingLocation(String error) {
    return '位置の取得エラー: $error';
  }

  @override
  String failedToGetAddress(String error) {
    return '住所の取得に失敗しました: $error';
  }

  @override
  String get noAppToOpenMaps => '地図を開くアプリがありません';

  @override
  String get geolocator => 'ジオロケーター';

  @override
  String accuracy(String accuracy) {
    return '精度: $accuracy';
  }

  @override
  String get pleaseEnableLocationServices => '位置情報サービスを有効にしてください';

  @override
  String get pleaseGrantLocationPermissions => '位置情報の許可を付与してください';

  @override
  String get locating => '位置情報取得中…';

  @override
  String get getCurrentLocation => '現在の位置を取得';

  @override
  String get openInMaps => '地図で開く';

  @override
  String get aboutGeolocator => 'ジオロケーターについて';

  @override
  String get geolocatorDescription => 'このツールは、端末の GPS を使って現在の位置を表示します。\n\n機能:\n• 緯度/経度の正確な座標\n• 精度の推定\n• 逆ジオコーディングによる住所取得\n• 地図で位置を表示\n\n最良の結果を得るには:\n• 位置情報サービスを有効にする\n• 空が見える場所に移動する\n• 住所検索のためインターネット接続を有効にする';

  @override
  String get ok => 'OK';

  @override
  String get tracking => '追跡中';

  @override
  String get waitingForGps => 'GPS待機中...';

  @override
  String get maxSpeed => '最高速度';

  @override
  String get avgSpeed => '平均速度';

  @override
  String get motionIntensity => 'モーション強度';

  @override
  String get liveSensorGraph => 'ライブセンサーグラフ (X = 赤, Y = 緑, Z = 青)';

  @override
  String get angularVelocity => '角速度 (rad/s)';

  @override
  String get healthTracker => 'ヘルストラッカー';

  @override
  String helloUser(String name) {
    return 'こんにちは、$nameさん！';
  }

  @override
  String readyToTrackSession(String activity) {
    return '$activity のセッションを記録しますか？';
  }

  @override
  String get bmi => 'BMI';

  @override
  String get bmr => '基礎代謝 (BMR)';

  @override
  String get steps => 'ステップ数';

  @override
  String get distance => '距離';

  @override
  String get duration => '時間';

  @override
  String get activityType => 'アクティビティタイプ';

  @override
  String get stop => '停止';

  @override
  String get resume => '再開';

  @override
  String get start => '開始';

  @override
  String get pause => '一時停止';

  @override
  String get liveSensorData => 'リアルタイムセンサーデータ';

  @override
  String get avgIntensity => '平均強度';

  @override
  String get peakIntensity => 'ピーク強度';

  @override
  String get movements => '動き';

  @override
  String get caloriesBurned => '消費カロリー';

  @override
  String bmrPerDay(String bmr) {
    return '基礎代謝: $bmr cal/日';
  }

  @override
  String get profileSettings => 'プロフィール設定';

  @override
  String get name => '名前';

  @override
  String get age => '年齢';

  @override
  String get weight => '体重';

  @override
  String get height => '身長';

  @override
  String get heartRateMonitor => '心拍数モニタ';

  @override
  String get toggleFlash => 'フラッシュ切り替え';

  @override
  String quietEnvironmentNeeded(String seconds) {
    return '静かな環境が必要です ($seconds 秒)';
  }

  @override
  String get estimatedHeartRate => '推定心拍数';

  @override
  String get flashOff => 'フラッシュオフ';

  @override
  String get flashOn => 'フラッシュオン';

  @override
  String get stableMeasurement => '安定測定';

  @override
  String get resetData => 'データリセット';

  @override
  String get noHumiditySensor => '湿度センサーが検出されません';

  @override
  String get noHumiditySensorDescription => 'ほとんどのスマホには湿度センサーがありません。デモ用にシミュレーションデータを表示しています。';

  @override
  String get checkAgain => '再確認';

  @override
  String get measuring => '測定中';

  @override
  String get stopped => '停止';

  @override
  String get singleReading => '単一読み取り';

  @override
  String get continuous => '連続';

  @override
  String get comfortAssessment => '快適性評価';

  @override
  String get readings => '読み取り';

  @override
  String get average => '平均';

  @override
  String get realTimeHumidityLevels => 'リアルタイム湿度レベル';

  @override
  String get humidityLevelGuide => '湿度レベルガイド';

  @override
  String get veryDry => '非常に乾燥';

  @override
  String get dry => '乾燥';

  @override
  String get comfortable => '快適';

  @override
  String get humid => '湿度高め';

  @override
  String get veryHumid => '非常に湿度高い';

  @override
  String get proximitySensor => '近接センサー';

  @override
  String get permissionRequired => '許可が必要です';

  @override
  String get sensorNotAvailable => 'センサーが利用できません';

  @override
  String get grantPermission => '許可を与える';

  @override
  String get permissionGranted => '許可が付与されました';

  @override
  String get microphonePermissionDenied => 'マイクの許可が拒否されました';

  @override
  String get microphonePermissionPermanentlyDenied => 'マイクの許可が永久に拒否されました。ノイズメーターを使用するには、デバイス設定で有効にしてください。';

  @override
  String get openSettings => '設定を開く';

  @override
  String get microphoneAccessNeeded => 'マイクアクセスが必要です';

  @override
  String get microphoneAccessDescription => '音声レベルを正確に測定および分析するには、デバイスのマイクへのアクセスが必要です。音声は記録または保存されることはありません。';

  @override
  String get measureNoiseLevels => 'リアルタイムでノイズレベルを測定';

  @override
  String get analyzeAcoustics => '音響環境を分析';

  @override
  String get generateReports => '詳細なレポートを生成';

  @override
  String get allowMicrophoneAccess => 'マイクアクセスを許可';

  @override
  String get audioNotRecorded => '音声は記録または保存されません';

  @override
  String get inactive => '非アクティブ';

  @override
  String get monitor => 'モニタ';

  @override
  String get totalReadings => '読み取り数合計';

  @override
  String get near => '近い';

  @override
  String get far => '遠い';

  @override
  String get proximityActivityTimeline => '近接アクティビティ履歴';

  @override
  String get howProximitySensorWorks => '近接センサーの仕組み';

  @override
  String get scanBarcode => 'バーコードをスキャン';

  @override
  String get positionBarcodeInFrame => 'バーコードをフレーム内に配置してください';

  @override
  String get scanningForBarcodes => 'UPC、EAN、コード128、コード39などをスキャン中';

  @override
  String get scanQrCode => 'QR コードをスキャン';

  @override
  String get positionQrCodeInFrame => 'QR コードをフレーム内に配置してください';

  @override
  String get scanningForQrCodes => 'QR コード、Data Matrix、PDF417、Aztec コードをスキャン中';

  @override
  String scannedOn(String timestamp) {
    return 'スキャン日時: $timestamp';
  }

  @override
  String get content => '内容';

  @override
  String get quickActions => 'クイック操作';

  @override
  String get technicalDetails => '技術詳細';

  @override
  String get format => '形式';

  @override
  String get description => '説明';

  @override
  String get dataLength => 'データ長';

  @override
  String get scanType => 'スキャンタイプ';

  @override
  String get contentType => 'コンテンツタイプ';

  @override
  String get copyAll => 'すべてコピー';

  @override
  String get share => '共有';

  @override
  String get scanAnother => '別をスキャン';

  @override
  String get copiedToClipboard => 'クリップボードにコピー済み';

  @override
  String get contentCopied => '内容をクリップボードにコピーしました';

  @override
  String get cannotOpenUrl => 'URL を開けません';

  @override
  String get chooseScannerType => 'スキャナー種別を選択';

  @override
  String get selectScannerDescription => 'スキャンしたいコードの種類を選んでください';

  @override
  String get commonUses => '一般的な用途：';

  @override
  String get scanningTips => 'スキャンのヒント';

  @override
  String get scanningTipsDescription => 'デバイスを安定させ、コードがフレーム内で明るく鮮明に見えるようにしてください。';

  @override
  String get minStat => '最小';

  @override
  String get maxStat => '最大';

  @override
  String get gender => '性別';

  @override
  String get selectActivity => 'アクティビティを選択';

  @override
  String get walking => '歩く';

  @override
  String get running => '走る';

  @override
  String get cycling => 'サイクリング';

  @override
  String get sitting => '座る';

  @override
  String get standing => '立つ';

  @override
  String get stairs => '階段';

  @override
  String get workout => 'ワークアウト';

  @override
  String get environment => '環境';

  @override
  String get navigation => 'ナビゲーション';

  @override
  String get motion => 'モーション';

  @override
  String get magnetic => '磁気';

  @override
  String get device => 'デバイス';

  @override
  String get utility => 'ユーティリティ';

  @override
  String get menu => 'メニュー';

  @override
  String get kmh => 'km/h';

  @override
  String get moving => '移動中';

  @override
  String get stationary => '停止中';

  @override
  String get feet => 'フィート';

  @override
  String get inches => 'インチ';

  @override
  String get productBarcodes => '商品バーコード';

  @override
  String get isbnNumbers => 'ISBN番号';

  @override
  String get upcCodes => 'UPCコード';

  @override
  String get eanCodes => 'EANコード';

  @override
  String get code128_39 => 'Code 128/39';

  @override
  String get websiteUrls => 'ウェブサイトURL';

  @override
  String get wifiPasswords => 'WiFiパスワード';

  @override
  String get contactInformation => '連絡先情報';

  @override
  String get locationCoordinates => '位置座標';

  @override
  String get calendarEvents => 'カレンダーイベント';

  @override
  String get nearDetection => '近距離検出';

  @override
  String get objectDetectedClose => 'センサーの近くで物体を検出';

  @override
  String get usuallyWithin5cm => '通常、センサーから5cm以内に何かがある場合';

  @override
  String get farDetection => '遠距離検出';

  @override
  String get noObjectDetected => '近くに物体が検出されません';

  @override
  String get clearAreaAroundSensor => 'センサー周辺のエリアをクリア';

  @override
  String get tooDryIrritation => '乾燥しすぎ - 皮膚や呼吸器の刺激を引き起こす可能性があります';

  @override
  String get somewhatDryHumidifier => 'やや乾燥 - 加湿器の使用を検討してください';

  @override
  String get idealHumidityLevel => '快適さと健康に理想的な湿度レベル';

  @override
  String get somewhatHumidSticky => 'やや湿度が高い - べたつく感じがするかもしれません';

  @override
  String get tooHumidMold => '湿度が高すぎます - カビの繁殖を促進する可能性があります';

  @override
  String get flashlightOn => 'フラッシュライト オン';

  @override
  String get flashlightOff => 'フラッシュライト オフ';

  @override
  String get meters => 'メートル';

  @override
  String get realTimeLightLevels => 'リアルタイム照度レベル';

  @override
  String get lightLevelGuide => '照度レベルガイド';

  @override
  String get darkLevel => '暗い';

  @override
  String get dimLevel => '薄暗い';

  @override
  String get indoorLevel => '屋内';

  @override
  String get officeLevel => 'オフィス';

  @override
  String get brightLevel => '明るい';

  @override
  String get daylightLevel => '日光';

  @override
  String get darkRange => '0-10 lux';

  @override
  String get dimRange => '10-200 lux';

  @override
  String get indoorRange => '200-500 lux';

  @override
  String get officeRange => '500-1000 lux';

  @override
  String get brightRange => '1000-10000 lux';

  @override
  String get daylightRange => '10000+ lux';

  @override
  String get darkExample => '夜、月明かりなし';

  @override
  String get dimExample => '月明かり、ろうそく';

  @override
  String get indoorExample => 'リビングルーム照明';

  @override
  String get officeExample => 'オフィスワークスペース';

  @override
  String get brightExample => '明るい部屋、曇りの日';

  @override
  String get daylightExample => '直射日光';

  @override
  String get grantSensorPermission => '近接センサーにアクセスするためのセンサー権限を許可してください';

  @override
  String get deviceNoProximitySensor => 'デバイスには近接センサーがありません';

  @override
  String get proximitySensorLocation => '近接センサーは通常イヤピース付近に位置し、通話中に画面を消すために使用されます。';

  @override
  String get pausedCameraInUse => '一時停止 - カメラが他の機能で使用中';

  @override
  String generalError(String error) {
    return 'エラー: $error';
  }

  @override
  String currentMode(String mode) {
    return '現在のモード: $mode';
  }

  @override
  String get noiseLevelGuide => '騒音レベルガイド';

  @override
  String get quiet => '静か';

  @override
  String get moderate => '適度';

  @override
  String get loud => '大きい';

  @override
  String get veryLoud => '非常に大きい';

  @override
  String get dangerous => '危険';

  @override
  String get whisperLibrary => '囁き声、図書館';

  @override
  String get normalConversation => '普通の会話';

  @override
  String get trafficOffice => '交通、オフィス';

  @override
  String get motorcycleShouting => 'オートバイ、叫び声';

  @override
  String get rockConcertChainsaw => 'ロックコンサート、チェーンソー';

  @override
  String get qrBarcodeScanner => 'QR/バーコードスキャナ';

  @override
  String get scannedData => 'スキャンデータ';

  @override
  String get copy => 'コピー';

  @override
  String get clear => 'クリア';

  @override
  String get pageNotFound => 'ページが見つかりません';

  @override
  String get goHome => 'ホームに戻る';

  @override
  String pageNotFoundMessage(String uri) {
    return 'ページが見つかりません: $uri';
  }

  @override
  String get more => '詳細';

  @override
  String get theme => 'テーマ';

  @override
  String get about => 'について';

  @override
  String get allSettings => 'すべての設定';

  @override
  String get getNotifiedAboutSensorReadings => 'センサー読み取り値の通知を受け取る';

  @override
  String get themeChangeRequiresRestart => 'テーマの変更にはアプリの再起動が必要です';

  @override
  String get quickSettings => 'クイック設定';

  @override
  String get darkModeActive => 'ダークモード有効';

  @override
  String get lightModeActive => 'ライトモード有効';

  @override
  String get sensorData => 'センサーデータ';

  @override
  String get stepsLabel => '歩数';

  @override
  String get accelX => '加速度X';

  @override
  String get accelY => '加速度Y';

  @override
  String get accelZ => '加速度Z';

  @override
  String get gyroX => 'ジャイロX';

  @override
  String get gyroY => 'ジャイロY';

  @override
  String get gyroZ => 'ジャイロZ';

  @override
  String get qrScannerSubtitle => 'QRコード、Data Matrix、PDF417、Aztecコードをスキャン';

  @override
  String get barcodeScannerSubtitle => 'UPC、EAN、Code 128などの商品バーコードをスキャン';

  @override
  String get activity => 'アクティビティ';

  @override
  String get startTracking => 'トラッキング開始';

  @override
  String get stopTracking => 'トラッキング停止';

  @override
  String get trackingActive => 'トラッキング中';

  @override
  String get sessionPaused => 'セッション一時停止';

  @override
  String get updateYourPersonalInformation => '個人情報を更新する';

  @override
  String get personalInformation => '個人情報';

  @override
  String get physicalMeasurements => '身体測定';

  @override
  String get enterYourFullName => 'フルネームを入力してください';

  @override
  String get pleaseEnterYourName => '名前を入力してください';

  @override
  String get enterYourAge => '年齢を入力してください';

  @override
  String get pleaseEnterYourAge => '年齢を入力してください';

  @override
  String get pleaseEnterValidNumber => '有効な数値を入力してください';

  @override
  String get selectYourGender => '性別を選択してください';

  @override
  String get enterYourWeightInKg => '体重をkgで入力してください';

  @override
  String get pleaseEnterYourWeight => '体重を入力してください';

  @override
  String get enterYourHeightInCm => '身長をcmで入力してください';

  @override
  String get pleaseEnterYourHeight => '身長を入力してください';

  @override
  String get pedometer => '歩数計';

  @override
  String get dailyGoal => '1日の目標';

  @override
  String get stepsToGo => '残り';

  @override
  String get goalReached => '目標達成！';

  @override
  String get calories => 'カロリー';

  @override
  String get pace => 'ペース';

  @override
  String get cadence => 'ケイデンス';

  @override
  String get setDailyGoal => '1日の目標を設定';

  @override
  String get resetSessionConfirmation => '現在のセッションをリセットしてもよろしいですか？すべての進捗が失われます。';

  @override
  String get barometer => '気圧計';

  @override
  String get waitingForSensor => 'センサー待機中...';

  @override
  String get clearWeather => '晴天';

  @override
  String get cloudyWeather => '曇天';

  @override
  String get stableWeather => '安定天候';

  @override
  String get pressureRising => '上昇中';

  @override
  String get pressureFalling => '下降中';

  @override
  String get pressureSteady => '安定';

  @override
  String get maximum => '最大';

  @override
  String get minimum => '最小';

  @override
  String get altitude => '高度';

  @override
  String get altimeter => '高度計';

  @override
  String get altimeterWaiting => '高度計データを待っています...';

  @override
  String get aboveSeaLevel => '海抜';

  @override
  String get climbing => '上昇中';

  @override
  String get descending => '下降中';

  @override
  String get stable => '安定';

  @override
  String get usingGpsOnly => 'GPSのみ使用';

  @override
  String get usingBarometerOnly => '気圧計のみ使用';

  @override
  String get usingFusedData => '統合データ使用';

  @override
  String get dataSource => 'データソース';

  @override
  String get sensorReadings => 'センサー読み取り値';

  @override
  String get gpsAltitude => 'GPS高度';

  @override
  String get baroAltitude => '気圧高度';

  @override
  String get pressure => '気圧';

  @override
  String get statistics => '統計';

  @override
  String get gain => '上昇';

  @override
  String get loss => '下降';

  @override
  String get calibrateAltimeter => '高度計を校正';

  @override
  String get calibrateDescription => '校正のために現在の既知の高度を入力してください';

  @override
  String get knownAltitude => '既知の高度';

  @override
  String get calibrationComplete => '校正完了';

  @override
  String get statsReset => '統計をリセット';

  @override
  String get vibrationMeter => '振動計';

  @override
  String get vibrationWaiting => '振動データを待っています...';

  @override
  String get vibrationMagnitude => '振動の大きさ';

  @override
  String get vibrationLevel => '振動レベル';

  @override
  String get realtimeWaveform => 'リアルタイム波形';

  @override
  String get pattern => 'パターン';

  @override
  String get frequency => '周波数';

  @override
  String get axisBreakdown => '軸別内訳';

  @override
  String get advancedMetrics => '高度なメトリクス';

  @override
  String get rms => 'RMS';

  @override
  String get peakToPeak => 'ピークツーピーク';

  @override
  String get crestFactor => 'クレストファクター';

  @override
  String get acousticAnalyzer => '音響アナライザー';

  @override
  String get acousticAnalyzerTitle => '音響アナライザー';

  @override
  String get acousticEnvironment => '音響環境';

  @override
  String get noiseLevel => '騒音レベル';

  @override
  String get decibelUnit => 'dB';

  @override
  String get presetSelectTitle => 'プリセットを選択';

  @override
  String get presetSelectSubtitle => '音響分析のタイプを選択';

  @override
  String get presetSleep => '睡眠';

  @override
  String get presetSleepTitle => '睡眠環境を分析';

  @override
  String get presetSleepDuration => '8時間';

  @override
  String get presetSleepDescription => '睡眠の質を改善するために夜間の寝室のノイズを監視';

  @override
  String get presetWork => '作業';

  @override
  String get presetWorkTitle => 'オフィス環境を監視';

  @override
  String get presetWorkDuration => '1時間';

  @override
  String get presetWorkDescription => '職場の騒音レベルを追跡し、気を散らすものを特定';

  @override
  String get presetFocus => '集中';

  @override
  String get presetFocusTitle => '集中セッション分析';

  @override
  String get presetFocusDuration => '30分';

  @override
  String get presetFocusDescription => '学習または集中セッションの環境を分析';

  @override
  String get presetCustom => 'カスタム';

  @override
  String get presetSleepAnalysis => '睡眠分析';

  @override
  String get presetWorkEnvironment => '作業環境';

  @override
  String get presetFocusSession => '集中セッション';

  @override
  String get presetCustomRecording => 'カスタム録音';

  @override
  String get monitoringTitle => 'モニタリング';

  @override
  String get monitoringActive => 'モニタリング中';

  @override
  String get monitoringStopped => 'モニタリング停止';

  @override
  String get monitoringProgress => 'モニタリング進捗';

  @override
  String get monitoringCurrentLevel => '現在のレベル';

  @override
  String get monitoringLiveChart => 'ライブチャート';

  @override
  String get monitoringEnvironment => '環境監視中';

  @override
  String get recordingStart => '録音開始';

  @override
  String get recordingStop => '録音停止';

  @override
  String get recordingCompleted => '録音完了';

  @override
  String get reportGeneratedSuccess => 'レポートが正常に生成されました';

  @override
  String get stopRecordingTooltip => '録音を停止';

  @override
  String get stopRecordingConfirmTitle => '録音を停止しますか？';

  @override
  String get stopRecordingConfirmMessage => '現在の録音を停止してもよろしいですか？';

  @override
  String get continueRecording => '録音を続ける';

  @override
  String get reportsTitle => 'レポート';

  @override
  String get reportsEmpty => 'レポートなし';

  @override
  String get reportsEmptyDescription => 'レポートが見つかりません。分析を開始して作成してください。';

  @override
  String reportsSelectedCount(int count) {
    return '$count個選択';
  }

  @override
  String get reportExportCSV => 'CSVをエクスポート';

  @override
  String get reportExportAll => 'すべてエクスポート';

  @override
  String get reportDelete => '削除';

  @override
  String get reportDeleteSelected => '選択したものを削除';

  @override
  String get reportDeleteConfirmTitle => 'レポートを削除しますか？';

  @override
  String reportDeleteConfirmMessage(int count) {
    return '選択したレポートを削除してもよろしいですか？';
  }

  @override
  String get reportDeleteSuccess => 'レポートが正常に削除されました';

  @override
  String get reportFilterByPreset => 'プリセットでフィルター';

  @override
  String get reportFilterAll => 'すべて';

  @override
  String get reportStartAnalysis => '分析を開始';

  @override
  String get csvCopiedToClipboard => 'CSVをクリップボードにコピー';

  @override
  String get reportDetailTitle => 'レポート詳細';

  @override
  String get reportQualityTitle => '品質';

  @override
  String get reportQualityScore => '品質スコア';

  @override
  String get reportAverage => '平均';

  @override
  String get reportPeak => 'ピーク';

  @override
  String get reportHourlyBreakdown => '時間別内訳';

  @override
  String get reportNoiseEvents => '騒音イベント';

  @override
  String get reportNoEventsTitle => 'イベントなし';

  @override
  String get reportNoEventsMessage => 'このセッション中に騒音イベントは検出されませんでした';

  @override
  String get reportShare => '共有';

  @override
  String get reportRecommendations => '推奨事項';

  @override
  String get reportDuration => '期間';

  @override
  String get reportEvents => 'イベント';

  @override
  String durationHours(int hours) {
    return '時間';
  }

  @override
  String durationMinutes(int minutes) {
    return '分';
  }

  @override
  String durationSeconds(int seconds) {
    return '秒';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours時間$minutes分';
  }

  @override
  String get qualityExcellent => '優秀';

  @override
  String get qualityGood => '良好';

  @override
  String get qualityFair => '普通';

  @override
  String get qualityPoor => '悪い';

  @override
  String get unitDecibels => 'dB';

  @override
  String get unitHours => '時間';

  @override
  String get unitMinutes => '分';

  @override
  String get unitSeconds => '秒';

  @override
  String get actionOk => 'OK';

  @override
  String get actionContinue => '続ける';

  @override
  String get actionStop => '停止';

  @override
  String get actionStart => '開始';

  @override
  String get actionView => '表示';

  @override
  String get actionExport => 'エクスポート';

  @override
  String get actionShare => '共有';

  @override
  String get viewHistoricalReports => '過去のレポートを表示';

  @override
  String get csvHeaderID => 'ID';

  @override
  String get csvHeaderStartTime => '開始時刻';

  @override
  String get csvHeaderEndTime => '終了時刻';

  @override
  String get csvHeaderDuration => '期間（分）';

  @override
  String get csvHeaderPreset => 'プリセット';

  @override
  String get csvHeaderAverageDB => '平均dB';

  @override
  String get csvHeaderMinDB => '最小dB';

  @override
  String get csvHeaderMaxDB => '最大dB';

  @override
  String get csvHeaderEvents => 'イベント';

  @override
  String get csvHeaderQualityScore => '品質スコア';

  @override
  String get csvHeaderQuality => '品質';

  @override
  String get csvHeaderRecommendation => '推奨事項';

  @override
  String get sleepAnalysis => '睡眠分析';

  @override
  String get workEnvironment => '作業環境';

  @override
  String get focusSession => '集中セッション';

  @override
  String get recordingComplete => '録音完了';

  @override
  String get presetName => 'プリセット名';

  @override
  String get averageDecibels => '平均デシベル';

  @override
  String get peakDecibels => 'ピークデシベル';

  @override
  String get environmentQuality => '環境品質';

  @override
  String get viewReport => 'レポートを表示';

  @override
  String get noiseMeterGuide => '騒音計ガイド';

  @override
  String get environmentAnalyzer => '環境アナライザー';

  @override
  String get environmentAnalyzerSubtitle => 'プリセットベースの音響分析';

  @override
  String get acousticReportsSubtitle => '保存された分析と履歴を表示';

  @override
  String get exportReports => 'レポートのエクスポート';

  @override
  String get exportChooseMethod => 'レポートのエクスポート方法を選択してください：';

  @override
  String get exportCopyToClipboard => 'クリップボードにコピー';

  @override
  String get exportSaveAsFile => 'ファイルとして保存';

  @override
  String get exportSuccess => 'エクスポート成功';

  @override
  String exportSuccessMessage(int count) {
    return '$count件のレポートが正常にエクスポートされました！';
  }

  @override
  String get savedTo => '保存先：';

  @override
  String get deletePreset => 'プリセットを削除しますか？';

  @override
  String deletePresetMessage(String title) {
    return '\"$title\"を削除しますか？この操作は元に戻せません。';
  }

  @override
  String get acousticReport => '音響レポート';

  @override
  String get createCustomPreset => 'カスタムプリセットを作成';

  @override
  String get durationMustBeGreaterThanZero => '期間は0より大きい必要があります';

  @override
  String get allPresets => 'すべてのプリセット';

  @override
  String get consistency => '一貫性';

  @override
  String get peakManagement => 'ピーク管理';

  @override
  String get level => 'レベル';

  @override
  String get avg => '平均';

  @override
  String get realtimeNoiseLevels => 'リアルタイム騒音レベル';

  @override
  String get decibelStatistics => 'デシベル統計';

  @override
  String get quietEnvironment => '静かな環境';

  @override
  String get moderateNoise => '中程度の騒音';

  @override
  String get loudEnvironment => 'うるさい環境';

  @override
  String get veryLoudCaution => '非常にうるさい - 注意';

  @override
  String get dangerousLevels => '危険なレベル';

  @override
  String get keyStatistics => '主要統計';

  @override
  String get noiseEvents => '騒音イベント';

  @override
  String get noInterruptionsDetected => '中断は検出されませんでした';

  @override
  String get environmentConsistentlyQuiet => '環境は一貫して静かでした';

  @override
  String get expertAdvice => '専門家のアドバイス';

  @override
  String get quickTips => 'クイックヒント';

  @override
  String dataPoints(int count) {
    return '$countポイント';
  }

  @override
  String get grantMicrophonePermission => '騒音レベルを測定するためにマイクの許可を付与してください';

  @override
  String get hourlyBreakdown => '時間別内訳';

  @override
  String get eventTimeline => 'イベントタイムライン';

  @override
  String get noEventsRecorded => '記録されたイベントはありません';

  @override
  String get sessionDetails => 'セッションの詳細';

  @override
  String get date => '日付';

  @override
  String get preset => 'プリセット';

  @override
  String get recommendation => '推奨事項';

  @override
  String get noInterruptions => '中断なし';

  @override
  String get quietQuiet => '静か (0-30 dB)';

  @override
  String get quietModerate => '中程度 (30-60 dB)';

  @override
  String get quietLoud => 'うるさい (60-85 dB)';

  @override
  String get quietVeryLoud => '非常にうるさい (85-100 dB)';

  @override
  String get quietDangerous => '危険 (100+ dB)';

  @override
  String get anErrorOccurred => 'エラーが発生しました。';

  @override
  String failedToLoadPresets(String error) {
    return 'プリセットの読み込みに失敗しました: $error';
  }

  @override
  String createdPreset(String title) {
    return '\"$title\"を作成しました！';
  }

  @override
  String failedToSavePreset(String error) {
    return 'プリセットの保存に失敗しました: $error';
  }

  @override
  String get deleteReportsQuestion => 'レポートを削除しますか？';

  @override
  String get deleteReportsConfirmMessage => '選択したレポートを削除してもよろしいですか？この操作は元に戻せません。';

  @override
  String get reportsDeleted => 'レポートが削除されました';

  @override
  String get presetDetails => 'プリセット詳細';

  @override
  String get mustBeAtLeast3Chars => '3文字以上で入力してください';

  @override
  String get mustBeAtLeast10Chars => '10文字以上で入力してください';

  @override
  String get chooseIcon => 'アイコンを選択';

  @override
  String get chooseColor => '色を選択';

  @override
  String get customLabs => 'カスタムラボ';

  @override
  String get allLabs => 'すべてのラボ';

  @override
  String get myLabs => 'マイラボ';

  @override
  String get noLabsYet => 'まだラボがありません';

  @override
  String get createFirstLabMessage => '最初のカスタムラボを作成して始めましょう';

  @override
  String get noCustomLabsYet => 'まだカスタムラボがありません';

  @override
  String get tapPlusToCreateLab => '+ボタンをタップして最初のカスタムラボを作成';

  @override
  String get newLab => '新しいラボ';

  @override
  String get presetLabs => 'プリセットラボ';

  @override
  String get myCustomLabs => 'マイカスタムラボ';

  @override
  String get errorLoadingLabs => 'ラボの読み込みエラー';

  @override
  String get createLab => 'ラボを作成';

  @override
  String get editLab => 'ラボを編集';

  @override
  String get deleteLab => 'ラボを削除';

  @override
  String get labName => 'ラボ名';

  @override
  String get labNameHint => '例：動作分析';

  @override
  String get descriptionHint => 'このラボが測定する内容を説明してください';

  @override
  String get recordingIntervalMs => '記録間隔（ms）';

  @override
  String get recordingIntervalSec => '記録間隔（秒）';

  @override
  String get recordingIntervalHint => '1';

  @override
  String get intervalMustBeBetween => '間隔は0.1〜10秒の範囲で指定してください';

  @override
  String get pleaseEnterInterval => '間隔を入力してください';

  @override
  String get pleaseEnterLabName => 'ラボ名を入力してください';

  @override
  String get labColor => 'ラボの色';

  @override
  String get selectSensors => 'センサーを選択';

  @override
  String get sensors => 'センサー';

  @override
  String get interval => '間隔';

  @override
  String get created => '作成日';

  @override
  String get sessions => 'セッション';

  @override
  String get notes => 'メモ';

  @override
  String get export => 'エクスポート';

  @override
  String get chooseAtLeastOneSensor => '記録する少なくとも1つのセンサーを選択してください';

  @override
  String get labCreatedSuccessfully => 'ラボが正常に作成されました';

  @override
  String get labUpdatedSuccessfully => 'ラボが正常に更新されました';

  @override
  String get labDeletedSuccessfully => 'ラボが正常に削除されました';

  @override
  String deleteLabConfirm(String labName) {
    return '「$labName」を削除してもよろしいですか？';
  }

  @override
  String get cannotModifyPresetLabs => 'プリセットラボは変更できません';

  @override
  String get cannotDeletePresetLabs => 'プリセットラボは削除できません';

  @override
  String get pleaseSelectAtLeastOneSensor => '少なくとも1つのセンサーを選択してください';

  @override
  String sensorsCount(int count) {
    return '$count個のセンサー';
  }

  @override
  String intervalMs(int interval) {
    return '${interval}ms間隔';
  }

  @override
  String get presetBadge => 'プリセット';

  @override
  String get labDetails => 'ラボの詳細';

  @override
  String get sessionHistory => 'セッション履歴';

  @override
  String get startRecording => '記録を開始';

  @override
  String get stopRecording => '記録を停止';

  @override
  String get pauseRecording => '記録を一時停止';

  @override
  String get recordingStatus => '記録中';

  @override
  String get pausedStatus => '一時停止';

  @override
  String get completedStatus => '完了';

  @override
  String get failedStatus => '失敗';

  @override
  String get idleStatus => '待機中';

  @override
  String get elapsedTime => '経過時間';

  @override
  String get collectingSensorData => 'センサーデータを収集中...';

  @override
  String get stopRecordingQuestion => '記録を停止しますか？';

  @override
  String get stopRecordingConfirm => 'この記録セッションを停止して保存しますか？';

  @override
  String get continueRecordingAction => '記録を続ける';

  @override
  String get stopAndSave => '停止して保存';

  @override
  String get recordingSavedSuccessfully => '記録が正常に保存されました';

  @override
  String get failedToStartRecording => '記録セッションの開始に失敗しました';

  @override
  String get noRecordingSessionsYet => 'まだ記録セッションがありません';

  @override
  String get startRecordingToCreateSession => '記録を開始して最初のセッションを作成';

  @override
  String get errorLoadingSessions => 'セッションの読み込みエラー';

  @override
  String get sessionDetailsTitle => 'セッションの詳細';

  @override
  String get exportAndShare => 'エクスポートと共有';

  @override
  String get deleteSession => 'セッションを削除';

  @override
  String get deleteSessionConfirm => 'この記録セッションを削除してもよろしいですか？この操作は元に戻せません。';

  @override
  String get sessionDeletedSuccessfully => 'セッションが正常に削除されました';

  @override
  String get recordingTime => '記録時間';

  @override
  String get startTime => '開始時刻';

  @override
  String get endTime => '終了時刻';

  @override
  String get recordingData => '記録データ';

  @override
  String get dataPointsCount => 'データポイント';

  @override
  String get sensorsUsed => '使用されたセンサー';

  @override
  String get sessionExportedToCSV => 'セッションがCSVにエクスポートされました';

  @override
  String get sessionNotYetExported => 'セッションはまだエクスポートされていません';

  @override
  String get errorCheckingExportStatus => 'エクスポートステータスの確認エラー';

  @override
  String get dataPreview => 'データプレビュー';

  @override
  String get noDataPointsRecorded => 'データポイントが記録されていません';

  @override
  String showingDataPoints(int showing, int total) {
    return '$total個中$showing個のデータポイントを表示';
  }

  @override
  String get pointNumber => 'ポイント';

  @override
  String errorLoadingDataPoints(String error) {
    return 'データポイントの読み込みエラー: $error';
  }

  @override
  String get exportToCSV => 'CSVにエクスポート';

  @override
  String get exportingStatus => 'エクスポート中...';

  @override
  String exportedTo(String path) {
    return 'エクスポート先: $path';
  }

  @override
  String get sharingNotYetImplemented => '（共有は未実装）';

  @override
  String get failedToExportSession => 'セッションのエクスポートに失敗しました';

  @override
  String get exportedLabel => 'エクスポート済み';

  @override
  String get sensorAccelerometer => '加速度計';

  @override
  String get sensorGyroscope => 'ジャイロスコープ';

  @override
  String get sensorMagnetometer => '磁力計';

  @override
  String get sensorBarometer => '気圧計';

  @override
  String get sensorLightMeter => '光';

  @override
  String get sensorNoiseMeter => '騒音';

  @override
  String get sensorGPS => 'GPS';

  @override
  String get sensorProximity => '近接';

  @override
  String get sensorTemperature => '温度';

  @override
  String get sensorHumidity => '湿度';

  @override
  String get sensorPedometer => '歩数計';

  @override
  String get sensorCompass => 'コンパス';

  @override
  String get sensorAltimeter => '高度計';

  @override
  String get sensorSpeedMeter => '速度';

  @override
  String get sensorHeartBeat => '心拍数';

  @override
  String get environmentMonitor => '環境モニター';

  @override
  String get motionAnalysis => '動作分析';

  @override
  String get indoorQuality => '室内品質';

  @override
  String get outdoorExplorer => '屋外探検';

  @override
  String get vehicleDynamics => '車両ダイナミクス';

  @override
  String get healthTrackerLab => '健康トラッカー';
}

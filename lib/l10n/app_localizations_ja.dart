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
  String get altimeter => 'Altimeter';

  @override
  String get altimeterWaiting => 'Waiting for GPS and barometer data...';

  @override
  String get aboveSeaLevel => 'Above Sea Level';

  @override
  String get climbing => 'Climbing';

  @override
  String get descending => 'Descending';

  @override
  String get stable => 'Stable';

  @override
  String get usingGpsOnly => 'Using GPS data only';

  @override
  String get usingBarometerOnly => 'Using barometer data only';

  @override
  String get usingFusedData => 'Combining GPS and barometer for accuracy';

  @override
  String get dataSource => 'Data Source';

  @override
  String get sensorReadings => 'Sensor Readings';

  @override
  String get gpsAltitude => 'GPS Altitude';

  @override
  String get baroAltitude => 'Baro Altitude';

  @override
  String get pressure => 'Pressure';

  @override
  String get statistics => 'Statistics';

  @override
  String get gain => 'Gain';

  @override
  String get loss => 'Loss';

  @override
  String get calibrateAltimeter => 'Calibrate Altimeter';

  @override
  String get calibrateDescription => 'Enter your current known altitude in meters to calibrate the barometric sensor for better accuracy.';

  @override
  String get knownAltitude => 'Known Altitude';

  @override
  String get calibrationComplete => 'Calibration complete!';

  @override
  String get statsReset => 'Statistics reset!';

  @override
  String get vibrationMeter => 'Vibration Meter';

  @override
  String get vibrationWaiting => 'Waiting for accelerometer data...';

  @override
  String get vibrationMagnitude => 'Vibration Magnitude';

  @override
  String get vibrationLevel => 'Vibration Level';

  @override
  String get realtimeWaveform => 'Real-time Waveform';

  @override
  String get pattern => 'Pattern';

  @override
  String get frequency => 'Frequency';

  @override
  String get axisBreakdown => 'Axis Breakdown';

  @override
  String get advancedMetrics => 'Advanced Metrics';

  @override
  String get rms => 'RMS';

  @override
  String get peakToPeak => 'Peak-to-Peak';

  @override
  String get crestFactor => 'Crest Factor';

  @override
  String get acousticAnalyzer => 'Acoustic Analyzer';

  @override
  String get acousticAnalyzerTitle => 'Acoustic Environment Analyzer';

  @override
  String get acousticEnvironment => 'Acoustic Environment';

  @override
  String get noiseLevel => 'Noise Level';

  @override
  String get decibelUnit => 'dB';

  @override
  String get presetSelectTitle => 'Choose Recording Preset';

  @override
  String get presetSelectSubtitle => 'Select a preset to analyze your acoustic environment over time';

  @override
  String get presetSleep => 'Sleep';

  @override
  String get presetSleepTitle => 'Analyze Sleep Environment';

  @override
  String get presetSleepDuration => '8 hours';

  @override
  String get presetSleepDescription => 'Monitor bedroom noise throughout the night to improve sleep quality';

  @override
  String get presetWork => 'Work';

  @override
  String get presetWorkTitle => 'Monitor Office Environment';

  @override
  String get presetWorkDuration => '1 hour';

  @override
  String get presetWorkDescription => 'Track workplace noise levels and identify distractions';

  @override
  String get presetFocus => 'Focus';

  @override
  String get presetFocusTitle => 'Focus Session Analysis';

  @override
  String get presetFocusDuration => '30 minutes';

  @override
  String get presetFocusDescription => 'Analyze your study or focus session environment';

  @override
  String get presetCustom => 'Custom';

  @override
  String get presetSleepAnalysis => 'Sleep Analysis (8h)';

  @override
  String get presetWorkEnvironment => 'Work Environment (1h)';

  @override
  String get presetFocusSession => 'Focus Session (30m)';

  @override
  String get presetCustomRecording => 'Custom Recording';

  @override
  String get monitoringTitle => 'Monitoring';

  @override
  String get monitoringActive => 'Recording Active';

  @override
  String get monitoringStopped => 'Recording Stopped';

  @override
  String get monitoringProgress => 'Progress';

  @override
  String get monitoringCurrentLevel => 'Current Level';

  @override
  String get monitoringLiveChart => 'Live Monitoring';

  @override
  String get monitoringEnvironment => 'Monitoring acoustic environment...';

  @override
  String get recordingStart => 'Start Recording';

  @override
  String get recordingStop => 'Stop Recording';

  @override
  String get recordingCompleted => 'Recording completed';

  @override
  String get reportGeneratedSuccess => 'Report generated successfully!';

  @override
  String get stopRecordingTooltip => 'Stop Recording';

  @override
  String get stopRecordingConfirmTitle => 'Stop Recording?';

  @override
  String get stopRecordingConfirmMessage => 'Are you sure you want to stop the recording? The report will be generated with the current data.';

  @override
  String get continueRecording => 'Continue';

  @override
  String get reportsTitle => 'Acoustic Reports';

  @override
  String get reportsEmpty => 'No Reports Yet';

  @override
  String get reportsEmptyDescription => 'Start an acoustic analysis session to generate your first report';

  @override
  String reportsSelectedCount(int count) {
    return '$count Selected';
  }

  @override
  String get reportExportCSV => 'Export as CSV';

  @override
  String get reportExportAll => 'Export All';

  @override
  String get reportDelete => 'Delete';

  @override
  String get reportDeleteSelected => 'Delete Selected';

  @override
  String get reportDeleteConfirmTitle => 'Delete Reports?';

  @override
  String reportDeleteConfirmMessage(int count) {
    return 'Are you sure you want to delete $count report(s)? This action cannot be undone.';
  }

  @override
  String get reportDeleteSuccess => 'Reports deleted';

  @override
  String get reportFilterByPreset => 'Filter by Preset';

  @override
  String get reportFilterAll => 'All Presets';

  @override
  String get reportStartAnalysis => 'Start Analysis';

  @override
  String get csvCopiedToClipboard => 'CSV data copied to clipboard!';

  @override
  String get reportDetailTitle => 'Acoustic Report';

  @override
  String get reportQualityTitle => 'Environment Quality';

  @override
  String get reportQualityScore => 'Quality Score';

  @override
  String get reportAverage => 'Average';

  @override
  String get reportPeak => 'Peak';

  @override
  String get reportHourlyBreakdown => 'Hourly Breakdown';

  @override
  String get reportNoiseEvents => 'Noise Events';

  @override
  String get reportNoEventsTitle => 'No Interruptions Detected';

  @override
  String get reportNoEventsMessage => 'Your environment was consistently quiet';

  @override
  String get reportShare => 'Share Report';

  @override
  String get reportRecommendations => 'Recommendations';

  @override
  String get reportDuration => 'Duration';

  @override
  String get reportEvents => 'events';

  @override
  String durationHours(int hours) {
    return '${hours}h';
  }

  @override
  String durationMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String durationSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get qualityExcellent => 'Excellent';

  @override
  String get qualityGood => 'Good';

  @override
  String get qualityFair => 'Fair';

  @override
  String get qualityPoor => 'Poor';

  @override
  String get unitDecibels => 'dB';

  @override
  String get unitHours => 'hours';

  @override
  String get unitMinutes => 'minutes';

  @override
  String get unitSeconds => 'seconds';

  @override
  String get actionOk => 'OK';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionStop => 'Stop';

  @override
  String get actionStart => 'Start';

  @override
  String get actionView => 'View';

  @override
  String get actionExport => 'Export';

  @override
  String get actionShare => 'Share';

  @override
  String get viewHistoricalReports => 'View Historical Reports';

  @override
  String get csvHeaderID => 'ID';

  @override
  String get csvHeaderStartTime => 'Start Time';

  @override
  String get csvHeaderEndTime => 'End Time';

  @override
  String get csvHeaderDuration => 'Duration (min)';

  @override
  String get csvHeaderPreset => 'Preset';

  @override
  String get csvHeaderAverageDB => 'Average dB';

  @override
  String get csvHeaderMinDB => 'Min dB';

  @override
  String get csvHeaderMaxDB => 'Max dB';

  @override
  String get csvHeaderEvents => 'Events';

  @override
  String get csvHeaderQualityScore => 'Quality Score';

  @override
  String get csvHeaderQuality => 'Quality';

  @override
  String get csvHeaderRecommendation => 'Recommendation';

  @override
  String get sleepAnalysis => 'Sleep Analysis';

  @override
  String get workEnvironment => 'Work Environment';

  @override
  String get focusSession => 'Focus Session';
}

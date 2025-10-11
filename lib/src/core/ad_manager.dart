import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sensorlab/src/shared/widgets/create_interstitial_ad.dart'
    as ad_loader;
// import '../shared/widgets/create_interstitial_ad.dart' as ad_loader;

class AdManager {
  InterstitialAd? get currentInterstitial => ad_loader.interstitialAd;

  void loadInterstitial() {
    ad_loader.createInterstitialAd();
  }

  void disposeInterstitial() {
    ad_loader.disposeInterstitialAd();
  }

  void showInterstitialIfAvailable({required void Function() onComplete}) {
    final interstitial = currentInterstitial;
    if (interstitial != null) {
      try {
        interstitial.show();
      } catch (e) {
        debugPrint('Error showing interstitial: $e');
      }
    }
    onComplete();
  }
}

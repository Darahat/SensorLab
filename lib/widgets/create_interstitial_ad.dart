import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void createInterstitialAd() {
  InterstitialAd? _interstitialAd;

  InterstitialAd.load(
    adUnitId: 'ca-app-pub-5150231094870616/1646738097',
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        _interstitialAd = ad;
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            createInterstitialAd();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            createInterstitialAd();
          },
        );
      },
      onAdFailedToLoad: (error) {
        debugPrint('InterstitialAd failed to load: $error');
      },
    ),
  );
}

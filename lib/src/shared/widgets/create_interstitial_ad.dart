import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// A single shared interstitial ad instance for the app. This module
// exposes `interstitialAd` and `createInterstitialAd()` so screens can
// read the current ad and the loader will automatically reload after
// an ad is dismissed or fails to show.

InterstitialAd? interstitialAd;
String _getInterstitialAdUnitId() {
  // Use Google test ad unit IDs in debug to avoid invalid traffic.
  if (kDebugMode) {
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/1033173712';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/4411468910';
    return 'ca-app-pub-3940256099942544/1033173712';
  }

  // Production ad unit IDs: prefer values from .env (AD_UNIT_INTERSTITIAL_ANDROID / AD_UNIT_INTERSTITIAL_IOS)
  if (Platform.isAndroid) {
    final fromEnv = dotenv.env['AD_UNIT_INTERSTITIAL_ANDROID'];
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    return 'ca-app-pub-5150231094870616/1646738097';
  }
  if (Platform.isIOS) {
    final fromEnv = dotenv.env['AD_UNIT_INTERSTITIAL_IOS'];
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    return 'ca-app-pub-5150231094870616/XXXXXXXXXX';
  }
  return dotenv.env['AD_UNIT_INTERSTITIAL_ANDROID'] ??
      'ca-app-pub-5150231094870616/1646738097';
}

void createInterstitialAd() {
  // If we already have a loaded ad, don't load another.
  if (interstitialAd != null) return;
  final adUnitId = _getInterstitialAdUnitId();
  InterstitialAd.load(
    adUnitId: adUnitId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        interstitialAd = ad;

        interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            try {
              ad.dispose();
            } catch (_) {}
            interstitialAd = null;
            // Preload next ad
            createInterstitialAd();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            try {
              ad.dispose();
            } catch (_) {}
            interstitialAd = null;
            createInterstitialAd();
          },
          onAdImpression: (ad) {},
        );
      },
      onAdFailedToLoad: (error) {
        debugPrint(
          'InterstitialAd failed to load: $error (adUnitId: $adUnitId)',
        );
        interstitialAd = null;
      },
    ),
  );
}

void disposeInterstitialAd() {
  try {
    interstitialAd?.dispose();
  } catch (_) {}
  interstitialAd = null;
}

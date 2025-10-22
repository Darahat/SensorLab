import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> showInterstitialAdThenNavigate({
  required BuildContext context,
  required Widget screen,
  required InterstitialAd? interstitialAd,
  bool adsEnabled = true, // Add ads enabled parameter
}) async {
  // Only show ad if ads are enabled and interstitial ad is available
  if (adsEnabled && interstitialAd != null) {
    interstitialAd.show();
    await Future.delayed(const Duration(milliseconds: 800));
  }
  if (!context.mounted) {
    return;
  }
  if (Navigator.of(context).canPop()) {
    return;
  }
  if (!context.mounted) {
    return;
  }
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutQuart;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    ),
  );
}

/// Entity representing a single onboarding page
class OnboardingPage {
  final String title;
  final String description;
  final String animationAsset;
  final List<String> features;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.animationAsset,
    required this.features,
  });
}

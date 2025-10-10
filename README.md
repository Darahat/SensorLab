# all_sensors

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Environment and keys

This project reads runtime secrets (AdMob IDs, API keys) from a `.env` file using `flutter_dotenv` and Android manifest placeholders.

- Copy `.env.example` to `.env` at the project root and fill your production keys.
- Do NOT commit `.env` or any real keys to version control.

Android:

- `ADMOB_APP_ID` is injected into the Android manifest via `manifestPlaceholders` in `android/app/build.gradle.kts`. You can set it in `key.properties` or as an environment variable `ADMOB_APP_ID` when building.

For development, the app uses Google's test ad unit IDs automatically when running in debug mode.

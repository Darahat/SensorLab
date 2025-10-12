import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../../../../core/providers.dart';
import '../../models/flashlight_data.dart';

class FlashlightScreen extends ConsumerStatefulWidget {
  const FlashlightScreen({super.key});

  @override
  ConsumerState<FlashlightScreen> createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends ConsumerState<FlashlightScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize flashlight when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(flashlightProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final flashlightData = ref.watch(flashlightProvider);
    final flashlightNotifier = ref.read(flashlightProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Builder(builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.flashlight),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => flashlightNotifier.resetSession(),
              tooltip: l10n.resetSession,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Availability Status
              if (!flashlightData.isAvailable || !flashlightData.isInitialized)
                Card(
                  color: Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          !flashlightData.isAvailable
                              ? Icons.flash_off
                              : Icons.hourglass_empty,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          !flashlightData.isAvailable
                              ? l10n.flashlightNotAvailable
                              : l10n.initializingFlashlight,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!flashlightData.isAvailable) ...[
                          const SizedBox(height: 8),
                          Text(
                            l10n.deviceDoesNotHaveFlashlight,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => flashlightNotifier.initialize(),
                            child: Text(l10n.tryAgain),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

              // Main Flashlight Control
              if (flashlightData.isAvailable && flashlightData.isInitialized) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              flashlightData.stateIcon,
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              flashlightData.statusDescription,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Main Flashlight Button
                        GestureDetector(
                          onTap: () => flashlightNotifier.toggleFlashlight(),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  flashlightData.isOn
                                      ? Color(
                                        flashlightData.stateColor,
                                      ).withOpacity(0.3)
                                      : colorScheme.surfaceVariant,
                              border: Border.all(
                                color: Color(flashlightData.stateColor),
                                width: 4,
                              ),
                              boxShadow:
                                  flashlightData.isOn
                                      ? [
                                        BoxShadow(
                                          color: Color(
                                            flashlightData.stateColor,
                                          ).withOpacity(0.4),
                                          blurRadius: 30,
                                          spreadRadius: 10,
                                        ),
                                      ]
                                      : null,
                            ),
                            child: Icon(
                              flashlightData.isOn
                                  ? Icons.flash_on
                                  : Icons.flash_off,
                              size: 80,
                              color: Color(flashlightData.stateColor),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Quick Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => flashlightNotifier.quickFlash(),
                              icon: const Icon(Icons.flash_auto),
                              label: Text(l10n.quickFlash),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed:
                                  () => flashlightNotifier.toggleFlashlight(),
                              icon: Icon(
                                flashlightData.isOn
                                    ? Icons.flash_off
                                    : Icons.flash_on,
                              ),
                              label: Text(
                                flashlightData.isOn ? l10n.turnOff : l10n.turnOn,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    flashlightData.isOn
                                        ? Colors.red
                                        : Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Intensity Control (iOS only)
                if (flashlightData.supportsIntensity)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.intensityControl,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.brightness_low),
                              Expanded(
                                child: Slider(
                                  value: flashlightData.intensity,
                                  onChanged:
                                      (value) =>
                                          flashlightNotifier.setIntensity(value),
                                  divisions: 10,
                                  label: flashlightData.formattedIntensity,
                                ),
                              ),
                              const Icon(Icons.brightness_high),
                            ],
                          ),
                          Center(
                            child: Text(
                              l10n.currentIntensity(flashlightData.formattedIntensity),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Flashlight Modes
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.flashlightModes,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildModeButton(
                                l10n.normal,
                                FlashlightMode.normal,
                                Icons.flash_on,
                                flashlightData.mode == FlashlightMode.normal,
                                () => flashlightNotifier.setMode(
                                  FlashlightMode.normal,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildModeButton(
                                l10n.strobe,
                                FlashlightMode.strobe,
                                Icons.offline_bolt,
                                flashlightData.mode == FlashlightMode.strobe,
                                () => flashlightNotifier.setMode(
                                  FlashlightMode.strobe,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildModeButton(
                                l10n.sos,
                                FlashlightMode.sos,
                                Icons.sos,
                                flashlightData.mode == FlashlightMode.sos,
                                () => flashlightNotifier.setMode(
                                  FlashlightMode.sos,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info, color: Colors.blue),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Current mode: ${flashlightData.modeDescription}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Session Statistics
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.sessionStatistics,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                l10n.sessionTime,
                                flashlightData.formattedSessionDuration,
                                Icons.timer,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildStatCard(
                                l10n.toggles,
                                '${flashlightData.toggleCount}',
                                Icons.touch_app,
                                Colors.purple,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                l10n.onTime,
                                flashlightData.formattedTotalOnTime,
                                Icons.lightbulb,
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildStatCard(
                                l10n.batteryUsage,
                                flashlightData.batteryUsageDescription.split(
                                  ' ',
                                )[0],
                                Icons.battery_alert,
                                Color(flashlightData.batteryUsageColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Battery Warning
                if (flashlightData.shouldShowBatteryWarning)
                  Card(
                    color: Colors.red.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.battery_alert, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.batteryUsageWarning,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  l10n.flashlightOnFor(flashlightData.formattedTotalOnTime),
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Usage Tips
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.usageTips,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildTipItem(
                          '💡',
                          l10n.normalMode,
                          l10n.normalModeDescription,
                        ),
                        _buildTipItem(
                          '⚡',
                          l10n.strobeMode,
                          l10n.strobeModeDescription,
                        ),
                        _buildTipItem(
                          '🆘',
                          l10n.sosMode,
                          l10n.sosModeDescription,
                        ),
                        _buildTipItem(
                          '🔋',
                          l10n.battery,
                          l10n.batteryTip,
                        ),
                        if (flashlightData.supportsIntensity)
                          _buildTipItem(
                            '🌟',
                            l10n.intensity,
                            l10n.intensityTip,
                          ),
                      ],
                    ),
                  ),
                ),
              ],

              // Error Message
              if (flashlightData.errorMessage != null)
                Card(
                  color: Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            flashlightData.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildModeButton(
    String label,
    FlashlightMode mode,
    IconData icon,
    bool isSelected,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
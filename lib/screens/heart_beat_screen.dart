import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../src/features/heart_beat/models/heart_beat_data.dart';
import '../src/features/heart_beat/providers/heart_beat_provider.dart';

class HeartRateScreen extends ConsumerWidget {
  const HeartRateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heartBeatData = ref.watch(heartBeatProvider);
    final heartBeatNotifier = ref.read(heartBeatProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Rate Monitor'),
        actions: [
          IconButton(
            icon: Icon(
              heartBeatData.isFlashOn ? Icons.flash_on : Icons.flash_off,
            ),
            onPressed: () => heartBeatNotifier.toggleFlash(),
            tooltip: 'Toggle flash',
          ),
        ],
      ),
      body:
          heartBeatData.isInitialized
              ? Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        if (heartBeatNotifier.cameraController != null &&
                            heartBeatNotifier
                                .cameraController!
                                .value
                                .isInitialized)
                          CameraPreview(heartBeatNotifier.cameraController!),
                        Column(
                          children: [
                            _buildEnvironmentWarning(
                              context,
                              heartBeatData,
                              heartBeatNotifier,
                            ),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  heartBeatData.statusMessage,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildHeartRateDisplay(
                    context,
                    heartBeatData,
                    heartBeatNotifier,
                  ),
                ],
              )
              : _buildLoadingScreen(heartBeatData),
    );
  }

  Widget _buildEnvironmentWarning(
    BuildContext context,
    HeartBeatData data,
    HeartBeatNotifier notifier,
  ) {
    if (!data.showSoundWarning) return const SizedBox.shrink();

    final remaining = data.warningTimeRemaining;

    return AnimatedOpacity(
      opacity: data.showSoundWarning ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.amber[700]?.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Quiet environment needed ($remaining s)',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => notifier.dismissWarning(),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeartRateDisplay(
    BuildContext context,
    HeartBeatData data,
    HeartBeatNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color getBpmColor() {
      switch (data.uiStatus) {
        case HeartRateUIStatus.error:
          return colorScheme.error;
        case HeartRateUIStatus.warning:
          return colorScheme.onSurface.withOpacity(0.6);
        case HeartRateUIStatus.measuring:
          return data.isNormalRate ? Colors.green : Colors.orange;
        default:
          return colorScheme.onSurface.withOpacity(0.6);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Estimated Heart Rate', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            data.bpmWithUnit,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: getBpmColor(),
            ),
          ),
          if (data.bpm > 0) ...[
            const SizedBox(height: 8),
            Text(
              data.rateCategory,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => notifier.toggleFlash(),
                icon: Icon(data.isFlashOn ? Icons.flash_off : Icons.flash_on),
                label: Text(data.isFlashOn ? 'Flash Off' : 'Flash On'),
              ),
              ElevatedButton.icon(
                onPressed: () => notifier.reset(),
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              ),
            ],
          ),
          if (data.isStableMeasurement) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Stable measurement',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingScreen(HeartBeatData data) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (data.status != HeartRateStatus.error)
            const CircularProgressIndicator(),
          if (data.status == HeartRateStatus.error)
            Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            data.statusMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: data.status == HeartRateStatus.error ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }
}

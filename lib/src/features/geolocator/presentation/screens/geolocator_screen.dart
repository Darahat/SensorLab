import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class GeolocatorPage extends StatefulWidget {
  const GeolocatorPage({super.key});

  @override
  _GeolocatorPageState createState() => _GeolocatorPageState();
}

class _GeolocatorPageState extends State<GeolocatorPage> {
  String _location = '';
  String _address = '';
  String _accuracy = '--';
  double? _latitude;
  double? _longitude;
  bool _isLoading = false;
  bool _permissionDenied = false;
  bool _serviceDisabled = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _permissionDenied = false;
      _serviceDisabled = false;
    });

    final l10n = AppLocalizations.of(context)!;

    try {
      // Check if location services are enabled
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _serviceDisabled = true;
          _location = l10n.locationServicesDisabled;
        });
        return;
      }

      // Check for location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _permissionDenied = true;
            _location = l10n.locationPermissionDenied;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _permissionDenied = true;
          _location = l10n.locationPermissionsPermanentlyDenied;
        });
        return;
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _location =
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
        _accuracy = "${position.accuracy.toStringAsFixed(2)} ${l10n.meters}";
      });

      // Get address from coordinates
      await _getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _location = l10n.errorGettingLocation(e.toString());
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lon) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        lat,
        lon,
      );
      final Placemark place = placemarks[0];

      setState(() {
        _address =
            "${place.street ?? ''}\n"
            "${place.locality ?? ''}, ${place.postalCode ?? ''}\n"
            "${place.country ?? ''}";
      });
    } catch (e) {
      setState(() {
        _address = l10n.failedToGetAddress(e.toString());
      });
    }
  }

  Future<void> _openInMaps() async {
    if (_latitude == null || _longitude == null) return;

    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$_latitude,$_longitude',
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication, // Opens in browser/maps app
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.noAppToOpenMaps),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorGettingLocation(e.toString()),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    // Initialize localized strings if empty
    if (_location.isEmpty) {
      _location = l10n.pressButtonToGetLocation;
    }
    if (_address.isEmpty) {
      _address = l10n.addressWillAppearHere;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          l10n.geolocator,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark
            ? Colors.deepPurple.shade800
            : Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [Colors.deepPurple.shade900, Colors.indigo.shade900]
                : [Colors.deepPurple.shade100, Colors.indigo.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Location Icon
              Icon(
                Icons.location_on,
                size: 80,
                color: isDark ? Colors.amber : Colors.deepPurple,
              ),
              const SizedBox(height: 30),

              // Location Data Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.deepPurple.shade700 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Coordinates
                    Row(
                      children: [
                        Icon(
                          Icons.gps_fixed,
                          color: isDark ? Colors.amber : Colors.deepPurple,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _location,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    // Accuracy
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: isDark ? Colors.greenAccent : Colors.green,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          l10n.accuracy(_accuracy),
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Address
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.home,
                          color: isDark ? Colors.blueAccent : Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _address,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Action Buttons
              if (_permissionDenied || _serviceDisabled)
                Column(
                  children: [
                    Text(
                      _serviceDisabled
                          ? l10n.pleaseEnableLocationServices
                          : l10n.pleaseGrantLocationPermissions,
                      style: TextStyle(
                        color: isDark ? Colors.amber : Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

              ElevatedButton.icon(
                onPressed: _isLoading ? null : _getCurrentLocation,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.gps_fixed),
                label: Text(
                  _isLoading ? l10n.locating : l10n.getCurrentLocation,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.amber : Colors.deepPurple,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              if (_latitude != null && _longitude != null)
                ElevatedButton.icon(
                  onPressed: _openInMaps,
                  icon: const Icon(Icons.map),
                  label: Text(l10n.openInMaps),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.deepPurple.shade600
                        : Colors.white,
                    foregroundColor: isDark ? Colors.white : Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.aboutGeolocator),
        content: Text(l10n.geolocatorDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}

import 'package:all_in_one_sensor_toolkit/widgets/show_interstitial_ad_than_navigate.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconsax/iconsax.dart';
import 'package:all_in_one_sensor_toolkit/screens/geolocator_screen.dart';
import 'package:all_in_one_sensor_toolkit/models/sensor_card.dart';
import 'package:all_in_one_sensor_toolkit/screens/light_meter_screen.dart';
import 'package:all_in_one_sensor_toolkit/screens/compass_screen.dart';
import 'package:all_in_one_sensor_toolkit/screens/noise_meter_screen.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:all_in_one_sensor_toolkit/widgets/sensor_search_delegate.dart';
import 'package:all_in_one_sensor_toolkit/widgets/sensor_grid_item.dart';
import 'package:all_in_one_sensor_toolkit/widgets/create_interstitial_ad.dart';
import 'package:all_in_one_sensor_toolkit/widgets/show_settings.dart';
import 'package:all_in_one_sensor_toolkit/widgets/sensors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  InterstitialAd? _interstitialAd;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    createInterstitialAd();
    _animationController.forward();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _animationController.forward(from: 0);
    }
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isRefreshing = false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _interstitialAd?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  int _selectedTabIndex = 0;

  // Get unique categories
  List<String> get _categories {
    final allCategories = sensors.map((s) => s.category).toSet().toList();
    return ['All'] + allCategories; // Add 'All' as first tab
  }

  // Get filtered sensors based on selected tab
  List<SensorCard> get _filteredSensors {
    if (_selectedTabIndex == 0) return sensors; // Show all for 'All' tab

    final selectedCategory = _categories[_selectedTabIndex];
    return sensors
        .where((sensor) => sensor.category == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categories = _getUniqueCategories();

    return DefaultTabController(
      length: categories.length + 1,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                floating: true,
                snap: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true, // This ensures the title stays centered
                  titlePadding: const EdgeInsets.only(bottom: 100),
                  title: const Text(
                    'Sensor Toolkit',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  background: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            isDark
                                ? [
                                  Colors.deepPurple.shade900,
                                  Colors.indigo.shade900,
                                ]
                                : [Colors.deepPurple, Colors.indigoAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Iconsax.search_normal,
                      color:
                          isDark ? Colors.white : Colors.white.withOpacity(0.9),
                    ),
                    onPressed:
                        () => showSearch(
                          context: context,
                          delegate: SensorSearchDelegate(sensors: sensors),
                        ),
                  ),
                  IconButton(
                    icon: Icon(
                      Iconsax.setting_2,
                      color:
                          isDark ? Colors.white : Colors.white.withOpacity(0.9),
                    ),
                    onPressed: () => showSettings(context),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      isScrollable: true,
                      onTap:
                          (index) => setState(() => _selectedTabIndex = index),
                      tabs: [
                        const Tab(text: 'All'),
                        ...categories.map((category) => Tab(text: category)),
                      ],
                      indicatorColor:
                          isDark ? Colors.white : Colors.white.withOpacity(0.8),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      labelColor: Colors.amberAccent,
                      unselectedLabelColor:
                          isDark
                              ? Colors.white.withOpacity(0.6)
                              : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: LiquidPullToRefresh(
            onRefresh: _handleRefresh,
            showChildOpacityTransition: false,
            color: isDark ? Colors.deepPurple.shade300 : Colors.deepPurple,
            height: 150,
            animSpeedFactor: 2,
            springAnimationDurationInMilliseconds: 800,
            child: TabBarView(
              children: [
                // 'All' tab
                _buildSensorGrid(sensors),
                // Category tabs
                ...categories.map((category) {
                  final categorySensors =
                      sensors
                          .where((sensor) => sensor.category == category)
                          .toList();
                  return _buildSensorGrid(categorySensors);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSensorGrid(List<SensorCard> sensorsToShow) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverAnimatedOpacity(
            opacity: _fadeAnimation.value,
            duration: const Duration(milliseconds: 500),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return ScaleTransition(
                  scale: _scaleAnimation,
                  child: SensorGridItem(
                    sensor: sensorsToShow[index],
                    sensorStatus: "NEW",
                    onTap: () {
                      _animationController.forward(from: 0);
                      showInterstitialAdThenNavigate(
                        context: context,
                        screen: sensorsToShow[index].screen,
                        interstitialAd: _interstitialAd,
                      );
                    },
                  ),
                );
              }, childCount: sensorsToShow.length),
            ),
          ),
        ),
      ],
    );
  }

  List<String> _getUniqueCategories() {
    return sensors.map((s) => s.category).toSet().toList();
  }
}

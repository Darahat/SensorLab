import 'package:sensorlab/widgets/show_interstitial_ad_than_navigate.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/screens/geolocator_screen.dart';
import 'package:sensorlab/models/sensor_card.dart';
import 'package:sensorlab/screens/light_meter_screen.dart';
import 'package:sensorlab/screens/compass_screen.dart';
import 'package:sensorlab/screens/noise_meter_screen.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sensorlab/widgets/sensor_search_delegate.dart';
import 'package:sensorlab/widgets/sensor_grid_item.dart';
import 'package:sensorlab/widgets/create_interstitial_ad.dart';
import 'package:sensorlab/widgets/show_settings.dart';
import 'package:sensorlab/widgets/sensors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  InterstitialAd? _interstitialAd;
  bool _isRefreshing = false;
  int _selectedTabIndex = 0;
  late TabController _tabController; // Added explicit TabController

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

    // Initialize ads
    createInterstitialAd();

    // Initialize tab controller after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _animationController.forward();
          // Trigger a refresh when the screen loads
          _handleRefresh();
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize tab controller here to ensure proper context
    final categories = _getUniqueCategories();
    _tabController = TabController(
      length: categories.length + 1,
      vsync: this,
      initialIndex: _selectedTabIndex,
    );
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    }
  }

  Future<void> _handleRefresh() async {
    if (!mounted) return;

    setState(() {
      _isRefreshing = true;
    });

    // Reset animation
    _animationController.reset();
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _animationController.forward();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose(); // Dispose the tab controller
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categories = _getUniqueCategories();

    return Scaffold(
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
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 100),
                title: const Text(
                  'Sensors Lab',
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
                    controller: _tabController, // Use the controller
                    isScrollable: true,
                    onTap: (index) {
                      if (mounted) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      }
                    },
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
            controller: _tabController, // Use the same controller
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
    );
  }

  Widget _buildSensorGrid(List<SensorCard> sensorsToShow) {
    return sensorsToShow.isEmpty
        ? Center(
          child: Text(
            'No sensors available',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        )
        : CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 1.1,
                              ),
                          itemCount: sensorsToShow.length,
                          itemBuilder: (context, index) {
                            return SensorGridItem(
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
                            );
                          },
                        ),
                      ),
                    );
                  },
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

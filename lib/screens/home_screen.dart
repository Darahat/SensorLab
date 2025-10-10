import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconsax/iconsax.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sensorlab/models/sensor_card.dart';
import 'package:sensorlab/widgets/create_interstitial_ad.dart';
import 'package:sensorlab/widgets/sensor_grid_item.dart';
import 'package:sensorlab/widgets/sensor_search_delegate.dart';
import 'package:sensorlab/widgets/sensors.dart';
import 'package:sensorlab/widgets/show_interstitial_ad_than_navigate.dart';
import 'package:sensorlab/widgets/show_settings.dart';

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
  TabController? _tabController; // Nullable — created in didChangeDependencies

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
    // read the shared instance (may be null until loaded)
    _interstitialAd = interstitialAd;

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
    // Initialize tab controller here to ensure proper context. If a controller
    // already exists (didChangeDependencies can be called multiple times),
    // dispose it first to avoid leaking listeners.
    final categories = _getUniqueCategories();
    if (mounted) {
      if (_tabController != null) {
        try {
          _tabController!.removeListener(_handleTabChange);
          _tabController!.dispose();
        } catch (_) {}
      }

      // Safely clamp the initial index to an integer within range
      var initialIndex = _selectedTabIndex;
      if (initialIndex < 0) initialIndex = 0;
      if (initialIndex > categories.length) initialIndex = categories.length;

      _tabController = TabController(
        length: categories.length + 1,
        vsync: this,
        initialIndex: initialIndex,
      );
      _tabController!.addListener(_handleTabChange);
    }
  }

  void _handleTabChange() {
    if (_tabController == null) return;
    if (_tabController!.indexIsChanging) {
      setState(() {
        _selectedTabIndex = _tabController!.index;
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
    try {
      if (_tabController != null) {
        _tabController!.removeListener(_handleTabChange);
        _tabController!.dispose(); // Dispose the tab controller
      }
    } catch (_) {}
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
    if (sensorsToShow.isEmpty) {
      return Center(
        child: Text(
          'No sensors available',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      );
    }

    // Clamp animation values so initial builds don't show NaN or negative scale
    final safeOpacity = (_fadeAnimation.value).clamp(0.0, 1.0);
    final safeScale = (_scaleAnimation.value).clamp(0.0, 2.0);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: safeOpacity,
                  child: Transform.scale(
                    scale: safeScale,
                    child: const SizedBox.shrink(),
                  ),
                );
              },
            ),
          ),
        ),

        // Actual grid as a SliverGrid to avoid nested scrollables
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return SensorGridItem(
                sensor: sensorsToShow[index],
                sensorStatus: "NEW",
                onTap: () {
                  _animationController.forward(from: 0);
                  // Use the shared interstitial instance; if it's null, the
                  // show helper will navigate immediately.
                  _interstitialAd = interstitialAd;
                  showInterstitialAdThenNavigate(
                    context: context,
                    screen: sensorsToShow[index].screen,
                    interstitialAd: _interstitialAd,
                  );
                },
              );
            }, childCount: sensorsToShow.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
          ),
        ),
      ],
    );
  }

  List<String> _getUniqueCategories() {
    // Preserve original order while removing duplicates
    final seen = <String>{};
    final result = <String>[];
    for (final s in sensors) {
      if (seen.add(s.category)) result.add(s.category);
    }
    return result;
  }
}

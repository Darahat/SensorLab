import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/app_settings/provider/settings_provider.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/custom_labs_screen.dart';
import 'package:sensorlab/src/shared/models/sensor_card.dart';
import 'package:sensorlab/src/shared/widgets/create_interstitial_ad.dart';
import 'package:sensorlab/src/shared/widgets/sensor_search_delegate.dart';
import 'package:sensorlab/src/shared/widgets/sensors.dart';
import 'package:sensorlab/src/shared/widgets/show_interstitial_ad_than_navigate.dart';
import 'package:sensorlab/src/shared/widgets/show_settings.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  InterstitialAd? _interstitialAd;
  int _selectedTabIndex = 0;
  TabController? _tabController;

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
        curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    final categories = _getUniqueCategories(l10n);

    if (_tabController == null ||
        _tabController!.length != categories.length + 1) {
      _tabController?.dispose();
      _tabController = TabController(
        length: categories.length + 1,
        vsync: this,
        initialIndex: _selectedTabIndex.clamp(0, categories.length),
      );
      _tabController!.addListener(() {
        if (_tabController!.indexIsChanging) {
          setState(() {
            _selectedTabIndex = _tabController!.index;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _tabController?.dispose();
    disposeInterstitialAd();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      createInterstitialAd();
      _interstitialAd = interstitialAd;
    }
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final sensorList = getSensors(l10n);
    final categories = _getUniqueCategories(l10n);

    final settingsAsync = ref.watch(settingsControllerProvider);
    final adsEnabled = settingsAsync.when(
      data: (settings) => settings.adsEnabled,
      loading: () => true,
      error: (_, __) => true,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (adsEnabled && _interstitialAd == null) {
        createInterstitialAd();
        _interstitialAd = interstitialAd;
      } else if (!adsEnabled && _interstitialAd != null) {
        disposeInterstitialAd();
        _interstitialAd = null;
      }
    });

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0E21)
          : const Color(0xFFF8F9FD),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildModernAppBar(context, isDark, l10n, sensorList),
          SliverToBoxAdapter(
            child: _buildCustomLabHeroCard(context, isDark, l10n),
          ),
          SliverToBoxAdapter(
            child: _buildQuickAccessSection(
              context,
              isDark,
              l10n,
              sensorList,
              adsEnabled,
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCategoryPills(context, isDark, categories),
          ),
          _buildModernSensorGrid(context, isDark, sensorList, adsEnabled),
        ],
      ),
    );
  }

  Widget _buildModernAppBar(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    List<SensorCard> sensorList,
  ) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF1A1F3A), const Color(0xFF0A0E21)]
                      : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(painter: _DotPatternPainter(isDark: isDark)),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Iconsax.activity5,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.appName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your Personal Lab Companion',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.8),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: IconButton(
            icon: const Icon(Iconsax.search_normal_1, color: Colors.white),
            onPressed: () => showSearch(
              context: context,
              delegate: SensorSearchDelegate(sensors: sensorList),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: IconButton(
            icon: const Icon(Iconsax.setting_2, color: Colors.white),
            onPressed: () => showSettings(context),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomLabHeroCard(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Material(
        elevation: 8,
        shadowColor: isDark
            ? Colors.deepPurple.withOpacity(0.3)
            : Colors.deepPurple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CustomLabsScreen()),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
                    : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _WavePatternPainter()),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Iconsax.star1,
                                    size: 14,
                                    color: Colors.amber.shade300,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'NEW FEATURE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Custom Labs',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Create your own sensor combinations and start recording custom experiments',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Get Started',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? const Color(0xFF6366F1)
                                          : const Color(0xFF667EEA),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Iconsax.arrow_right_3,
                                    size: 18,
                                    color: isDark
                                        ? const Color(0xFF6366F1)
                                        : const Color(0xFF667EEA),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Iconsax.microscope,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    List<SensorCard> sensorList,
    bool adsEnabled,
  ) {
    final quickAccessSensors = sensorList.take(4).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1A1F36),
                  letterSpacing: -0.3,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  if (_tabController != null) {
                    _tabController!.animateTo(0);
                  }
                },
                icon: Icon(
                  Iconsax.arrow_right_3,
                  size: 16,
                  color: isDark
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFF667EEA),
                ),
                label: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFF667EEA),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: quickAccessSensors.length,
              itemBuilder: (context, index) {
                final sensor = quickAccessSensors[index];
                return _buildQuickAccessCard(
                  context,
                  isDark,
                  sensor,
                  adsEnabled,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context,
    bool isDark,
    SensorCard sensor,
    bool adsEnabled,
  ) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        elevation: 2,
        shadowColor: isDark
            ? Colors.black.withOpacity(0.3)
            : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        color: isDark ? const Color(0xFF1E2139) : Colors.white,
        child: InkWell(
          onTap: () {
            _interstitialAd = interstitialAd;
            showInterstitialAdThenNavigate(
              context: context,
              screen: sensor.screen,
              interstitialAd: _interstitialAd,
              adsEnabled: adsEnabled,
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        sensor.color.withOpacity(0.2),
                        sensor.color.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(sensor.icon, size: 26, color: sensor.color),
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    sensor.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white.withOpacity(0.9)
                          : const Color(0xFF1A1F36),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPills(
    BuildContext context,
    bool isDark,
    List<String> categories,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 16),
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final category = isAll ? 'All' : categories[index - 1];
          final isSelected = _selectedTabIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
                _tabController?.animateTo(index);
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
                            : [
                                const Color(0xFF667EEA),
                                const Color(0xFF764BA2),
                              ],
                      )
                    : null,
                color: isSelected
                    ? null
                    : isDark
                    ? const Color(0xFF1E2139)
                    : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color:
                              (isDark
                                      ? const Color(0xFF6366F1)
                                      : const Color(0xFF667EEA))
                                  .withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isAll)
                    Icon(
                      Iconsax.category5,
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : isDark
                          ? Colors.white.withOpacity(0.6)
                          : const Color(0xFF1A1F36),
                    ),
                  if (isAll) const SizedBox(width: 8),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : isDark
                          ? Colors.white.withOpacity(0.6)
                          : const Color(0xFF1A1F36),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernSensorGrid(
    BuildContext context,
    bool isDark,
    List<SensorCard> sensorList,
    bool adsEnabled,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final categories = _getUniqueCategories(l10n);

    List<SensorCard> filteredSensors;
    if (_selectedTabIndex == 0) {
      filteredSensors = sensorList;
    } else {
      final category = categories[_selectedTabIndex - 1];
      filteredSensors = sensorList
          .where((sensor) => sensor.category == category)
          .toList();
    }

    if (filteredSensors.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.search_status,
                size: 64,
                color: isDark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noSensorsAvailable,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark
                      ? Colors.white.withOpacity(0.4)
                      : Colors.grey.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return _buildModernSensorCard(
            context,
            isDark,
            filteredSensors[index],
            adsEnabled,
          );
        }, childCount: filteredSensors.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
      ),
    );
  }

  Widget _buildModernSensorCard(
    BuildContext context,
    bool isDark,
    SensorCard sensor,
    bool adsEnabled,
  ) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final safeOpacity = _fadeAnimation.value.clamp(0.0, 1.0);
        final safeScale = _scaleAnimation.value.clamp(0.0, 2.0);

        return Opacity(
          opacity: safeOpacity,
          child: Transform.scale(
            scale: safeScale,
            child: Material(
              elevation: 4,
              shadowColor: isDark
                  ? Colors.black.withOpacity(0.3)
                  : sensor.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              color: isDark ? const Color(0xFF1E2139) : Colors.white,
              child: InkWell(
                onTap: () {
                  _animationController.forward(from: 0);
                  _interstitialAd = interstitialAd;
                  showInterstitialAdThenNavigate(
                    context: context,
                    screen: sensor.screen,
                    interstitialAd: _interstitialAd,
                    adsEnabled: adsEnabled,
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              sensor.color.withOpacity(0.2),
                              sensor.color.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: sensor.color.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(sensor.icon, size: 28, color: sensor.color),
                      ),
                      const Spacer(),
                      Text(
                        sensor.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1A1F36),
                          letterSpacing: -0.3,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: sensor.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          sensor.category,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: sensor.color,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<String> _getUniqueCategories(AppLocalizations l10n) {
    final sensorList = getSensors(l10n);
    final seen = <String>{};
    final result = <String>[];
    for (final s in sensorList) {
      if (seen.add(s.category)) {
        result.add(s.category);
      }
    }
    return result;
  }
}

class _DotPatternPainter extends CustomPainter {
  final bool isDark;

  _DotPatternPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(isDark ? 0.05 : 0.1)
      ..style = PaintingStyle.fill;

    const spacing = 30.0;
    final cols = (size.width / spacing).ceil();
    final rows = (size.height / spacing).ceil();

    for (var i = 0; i < cols; i++) {
      for (var j = 0; j < rows; j++) {
        final x = i * spacing;
        final y = j * spacing;
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPatternPainter oldDelegate) =>
      isDark != oldDelegate.isDark;
}

class _WavePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.6,
      size.width * 0.5,
      size.height * 0.7,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.7,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

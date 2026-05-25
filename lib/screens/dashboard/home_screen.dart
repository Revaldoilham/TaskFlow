// lib/screens/home/home_screen.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../controllers/today_controller.dart';
import '../../models/local_task_model.dart';
import 'package:taskflow/screens/create_task/create_task_screen.dart';
import 'package:taskflow/screens/profile/profile_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimCtrl;
  late AnimationController _ringAnimCtrl;
  late AnimationController _fabAnimCtrl;
  late Animation<double> _ringAnim;
  late Animation<double> _headerSlide;
  late Animation<double> _fabScale;

  final List<AnimationController> _cardCtrlList = [];
  final List<Animation<double>> _cardAnimList = [];

  int _selectedFilter = 0;
  final List<String> _filters = ['Semua', 'Focus', 'Risk', 'Timeline'];

  @override
  void initState() {
    super.initState();

    _headerAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerSlide = CurvedAnimation(
      parent: _headerAnimCtrl,
      curve: Curves.easeOut,
    );

    _ringAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _ringAnim = CurvedAnimation(
      parent: _ringAnimCtrl,
      curve: Curves.easeInOut,
    );

    _fabAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fabScale = CurvedAnimation(
      parent: _fabAnimCtrl,
      curve: Curves.elasticOut,
    );

    for (int i = 0; i < 8; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      _cardCtrlList.add(ctrl);
      _cardAnimList.add(
        CurvedAnimation(parent: ctrl, curve: Curves.easeOut),
      );
    }

    _startAnimations();
  }

  void _startAnimations() async {
    _headerAnimCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _ringAnimCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _fabAnimCtrl.forward();
    for (int i = 0; i < _cardCtrlList.length; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      if (mounted) _cardCtrlList[i].forward();
    }
  }

  @override
  void dispose() {
    _headerAnimCtrl.dispose();
    _ringAnimCtrl.dispose();
    _fabAnimCtrl.dispose();
    for (final c in _cardCtrlList) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TodayController ctrl = Get.put(TodayController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: ctrl.loadToday,
              color: AppColors.primary,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: AnimatedBuilder(
                      animation: _headerSlide,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, -30 * (1 - _headerSlide.value)),
                        child: Opacity(
                          opacity: _headerSlide.value,
                          child: child,
                        ),
                      ),
                      child: _buildHeader(ctrl),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: _buildFilterChips(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildContent(ctrl),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 120),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 28,
              right: 24,
              child: _buildFAB(),
            ),
          ],
        );
      }),
    );
  }

  // ─── HEADER ──────────────────────────────────────────────────────────────

  Widget _buildHeader(TodayController ctrl) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -30,
            child: _Circle(size: 200, opacity: 0.07),
          ),
          Positioned(
            bottom: -60,
            left: -20,
            child: _Circle(size: 170, opacity: 0.05),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DateBadge(),
                          const SizedBox(height: 10),
                          Text(
                            'TaskFlow',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kelola produktivitasmu hari ini',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.78),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _AvatarButton(),
                  ],
                ),
                const SizedBox(height: 24),
                _buildProgressCard(ctrl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(TodayController ctrl) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.22), width: 1),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _ringAnim,
            builder: (_, __) => _ProgressRing(
              progress: ctrl.dailyProgress * _ringAnim.value,
              size: 90,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress Hari Ini',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                _StatRow(
                  label: 'Total Task',
                  value: ctrl.totalToday.value.toString(),
                  valueColor: Colors.white,
                ),
                const SizedBox(height: 6),
                _StatRow(
                  label: 'Selesai',
                  value: ctrl.completedToday.value.toString(),
                  valueColor: const Color(0xFF86EFAC),
                ),
                const SizedBox(height: 6),
                _StatRow(
                  label: 'Belum',
                  value: ctrl.pendingToday.value.toString(),
                  valueColor: Colors.white.withOpacity(0.6),
                ),
                const SizedBox(height: 10),
                _MiniBar(progress: ctrl.dailyProgress),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── FILTER CHIPS ────────────────────────────────────────────────────────

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          _filters.length,
          (i) => Padding(
            padding: EdgeInsets.only(right: i < _filters.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  gradient: _selectedFilter == i
                      ? AppColors.primaryGradient
                      : null,
                  color: _selectedFilter == i ? null : Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: _selectedFilter == i
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Text(
                  _filters[i],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _selectedFilter == i
                        ? Colors.white
                        : const Color(0xFF7C7899),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── CONTENT ─────────────────────────────────────────────────────────────

  Widget _buildContent(TodayController ctrl) {
    int cardIdx = 0;

    Widget animateCard(Widget child) {
      final idx = cardIdx < _cardAnimList.length ? cardIdx : 0;
      cardIdx++;
      return AnimatedBuilder(
        animation: _cardAnimList[idx],
        builder: (_, __) => Transform.translate(
          offset: Offset(0, 20 * (1 - _cardAnimList[idx].value)),
          child: Opacity(opacity: _cardAnimList[idx].value, child: child),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // FOCUS TODAY
        _SectionHeader(title: 'Focus Today', icon: Icons.center_focus_strong_rounded),
        const SizedBox(height: 12),
        if (ctrl.focusTasks.isEmpty)
          _EmptyCard()
        else
          ...ctrl.focusTasks.map((t) => animateCard(
                _TaskCard(task: t, badge: _Badge.focus),
              )),

        const SizedBox(height: 24),

        // RISK TASK
        _SectionHeader(title: 'Risk Task', icon: Icons.warning_amber_rounded),
        const SizedBox(height: 12),
        if (ctrl.riskTasks.isEmpty)
          _EmptyCard()
        else
          ...ctrl.riskTasks.map((t) => animateCard(
                _TaskCard(task: t, badge: _Badge.risk),
              )),

        const SizedBox(height: 24),

        // DAILY TIMELINE
        _SectionHeader(title: 'Daily Timeline', icon: Icons.schedule_rounded),
        const SizedBox(height: 12),
        if (ctrl.timelineTasks.isEmpty)
          _EmptyCard()
        else
          ...ctrl.timelineTasks.map((t) => animateCard(
                _TimelineCard(task: t),
              )),

        const SizedBox(height: 24),

        // TODAY TASK
        _SectionHeader(title: 'Today Task', icon: Icons.task_alt_rounded),
        const SizedBox(height: 12),
        if (ctrl.todayTasks.isEmpty)
          _EmptyCard()
        else
          ...ctrl.todayTasks.map((t) => animateCard(
                _TaskCard(task: t, badge: _Badge.none),
              )),
      ],
    );
  }

  // ─── FAB ─────────────────────────────────────────────────────────────────

  Widget _buildFAB() {
    return ScaleTransition(
      scale: _fabScale,
      child: GestureDetector(
        onTap: () => Get.toNamed('/create-task'),
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.45),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'New Task',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── HELPER WIDGETS ──────────────────────────────────────────────────────────

class _Circle extends StatelessWidget {
  final double size;
  final double opacity;
  const _Circle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    final label =
        '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today_rounded,
              size: 12, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/profile'),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
        ),
        child: Center(
          child: Text(
            'R',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  const _ProgressRing({required this.progress, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(progress: progress),
        child: Center(
          child: Text(
            '${(progress * 100).toInt()}%',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = cx - 7;
    const stroke = 7.0;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = Colors.white.withOpacity(0.2);
    canvas.drawCircle(Offset(cx, cy), r, bgPaint);

    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

class _MiniBar extends StatelessWidget {
  final double progress;
  const _MiniBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return Stack(
        children: [
          Container(
            height: 4,
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOut,
            height: 4,
            width: constraints.maxWidth * progress,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      );
    });
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _StatRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: Colors.white.withOpacity(0.78),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {},
          child: Text(
            'Lihat semua',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

enum _Badge { focus, risk, none }

class _TaskCard extends StatelessWidget {

  final LocalTaskModel task;

  final _Badge badge;

  const _TaskCard({
    required this.task,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: () {

        Get.toNamed(
          '/task-detail',

          arguments: task,
        );
      },

      child: Container(
        margin: const EdgeInsets.only(
          bottom: 12,
        ),

        padding: const EdgeInsets.all(
          18,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            22,
          ),

          boxShadow:
              AppColors.cardShadow,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // HEADER

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                _PriorityDot(
                  badge: badge,
                ),

                const SizedBox(
                  width: 10,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Text(
                        task.title,

                        style:
                            GoogleFonts
                                .plusJakartaSans(
                          fontSize: 15,

                          fontWeight:
                              FontWeight
                                  .w700,

                          color:
                              AppColors
                                  .textPrimary,
                        ),
                      ),

                      if (task
                          .description
                          .isNotEmpty) ...[

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          task.description,

                          style:
                              GoogleFonts
                                  .plusJakartaSans(
                            fontSize:
                                12.5,

                            color:
                                AppColors
                                    .textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                if (badge !=
                    _Badge.none)

                  _BadgePill(
                    badge: badge,
                  ),
              ],
            ),

            const SizedBox(
              height: 14,
            ),

            // PROGRESS

            if (badge !=
                _Badge.none)

              _ProgressBar(
                badge: badge,
              ),

            const SizedBox(
              height: 10,
            ),

            // FOOTER

            Row(
              children: [

                Icon(
                  badge ==
                          _Badge
                              .risk
                      ? Icons
                          .warning_amber_rounded
                      : Icons
                          .schedule_rounded,

                  size: 14,

                  color: badge ==
                          _Badge
                              .risk
                      ? const Color(
                          0xFFE74C3C,
                        )
                      : AppColors
                          .textHint,
                ),

                const SizedBox(
                  width: 5,
                ),

                Text(
                  task.deadline !=
                          null

                      ? '${task.deadline!.day}/${task.deadline!.month}/${task.deadline!.year}'

                      : 'No Deadline',

                  style:
                      GoogleFonts
                          .plusJakartaSans(
                    fontSize: 11.5,

                    fontWeight:
                        FontWeight
                            .w500,

                    color: badge ==
                            _Badge
                                .risk
                        ? const Color(
                            0xFFE74C3C,
                          )
                        : AppColors
                            .textHint,
                  ),
                ),

                const Spacer(),

                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        AppColors
                            .primary
                            .withOpacity(
                      0.08,
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      50,
                    ),
                  ),

                  child: Text(
                    'Detail',

                    style:
                        GoogleFonts
                            .plusJakartaSans(
                      fontSize: 10,

                      fontWeight:
                          FontWeight
                              .w700,

                      color:
                          AppColors
                              .primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityDot extends StatelessWidget {
  final _Badge badge;
  const _PriorityDot({required this.badge});

  @override
  Widget build(BuildContext context) {
    final color = badge == _Badge.risk
        ? const Color(0xFFE74C3C)
        : badge == _Badge.focus
            ? const Color(0xFFF39C12)
            : const Color(0xFF27AE60);
    return Container(
      width: 9,
      height: 9,
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  final _Badge badge;
  const _BadgePill({required this.badge});

  @override
  Widget build(BuildContext context) {
    final isFocus = badge == _Badge.focus;
    final bg = isFocus
        ? const Color(0xFFFFF3E0)
        : const Color(0xFFFFEBEE);
    final text = isFocus ? 'FOCUS' : 'RISK';
    final color = isFocus
        ? const Color(0xFFE07A00)
        : const Color(0xFFC0392B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: color,
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final _Badge badge;
  const _ProgressBar({required this.badge});

  @override
  Widget build(BuildContext context) {
    final pct = badge == _Badge.risk ? 0.2 : 0.6;
    final color = badge == _Badge.risk
        ? const Color(0xFFE74C3C)
        : AppColors.primary;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: pct,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${(pct * 100).toInt()}%',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final LocalTaskModel task;
  const _TimelineCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${task.startTime ?? '--:--'}\n${task.endTime ?? '--:--'}',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 11,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              task.title,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.08),
                  AppColors.primary.withOpacity(0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 28,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada data',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Task kamu akan muncul di sini',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
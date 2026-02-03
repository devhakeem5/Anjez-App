import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../home_controller.dart';

class DailyOverviewWidget extends StatefulWidget {
  const DailyOverviewWidget({super.key});

  @override
  State<DailyOverviewWidget> createState() => _DailyOverviewWidgetState();
}

class _DailyOverviewWidgetState extends State<DailyOverviewWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              // Card 1: Today's Tasks
              _buildOverviewCard(
                context,
                title: 'مهام اليوم',
                count: homeController.todayTasksCount,
                subtitle: 'يجب إنجازها اليوم',
                icon: Icons.today_rounded,
                color: Theme.of(context).primaryColor,
                onTap: () =>
                    Get.toNamed(Routes.todayTasks)?.then((_) => homeController.loadTasks()),
              ),
              // Card 2: In Progress
              _buildOverviewCard(
                context,
                title: 'جاري التنفيذ',
                count: homeController.inProgressCount,
                subtitle: 'مهام بدأت العمل عليها',
                icon: Icons.pending_actions_rounded,
                color: Colors.orange.shade700,
                onTap: () =>
                    Get.toNamed(Routes.inProgressTasks)?.then((_) => homeController.loadTasks()),
              ),
              // Card 3: Completed This Month
              _buildOverviewCard(
                context,
                title: 'مكتملة هذا الشهر',
                count: homeController.completedThisMonthCount,
                subtitle: '', // Custom handling below
                icon: Icons.task_alt_rounded,
                color: Colors.green.shade700,
                onTap: () =>
                    Get.toNamed(Routes.completedTasks)?.then((_) => homeController.loadTasks()),
                customSubtitle: Obx(
                  () => Text(
                    'مع أكثر من ${homeController.completedSubtasksThisMonth.value} مهمة فرعية',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Simple Dot Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
    BuildContext context, {
    required String title,
    required RxInt count,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    Widget? customSubtitle,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      '${count.value}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (customSubtitle != null)
                    customSubtitle
                  else
                    Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}

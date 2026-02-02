import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../stats/controller/stats_controller.dart';

class DailyOverviewWidget extends StatelessWidget {
  const DailyOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject stats controller if not present, or find it
    // Better to put in binding, but for now safe check
    if (!Get.isRegistered<StatsController>()) {
      Get.put(StatsController());
    }

    final StatsController statsController = Get.find<StatsController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50), // Dark aesthetics like requested
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Overview',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() {
                    final completed = statsController.completedToday.value;
                    // Total tasks for today calculation:
                    // Home controller has 'todayTasks'.
                    // However, 'todayTasks' in home might be filtered.
                    // Ideally we should use raw count or just rely on what's visible + completed.
                    // For accuracy, let's look at homeController._originalTodayTasks if exposed or just todayTasks length?
                    // Home controller exposes filtered todayTasks.
                    // Let's assume for simplicity: Completed (from DB) vs "Pending + Completed" from stats?
                    // Actually, let's just use "You completed X tasks today". Simpler and robust.

                    return Text(
                      '$completed Tasks \nCompleted',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    );
                  }),
                ],
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bar_chart_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar (Decorative or real)
          // Let's make it motivational
          const Text(
            'Keep up the good work!',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

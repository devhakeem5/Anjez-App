import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/modules/stats/view/stats_view.dart';

import '../../routes/app_routes.dart';
import '../category/view/category_list_view.dart';
import 'home_controller.dart';
import 'widgets/daily_overview_widget.dart';
import 'widgets/empty_state_widget.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/section_header_widget.dart';
import 'widgets/task_item_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async => controller.loadTasks(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80.0), // FAB space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DailyOverviewWidget(),
                const SizedBox(height: 16),
                _buildTodaySection(),
                _buildOngoingSection(),
                _buildUpcomingSection(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.addTask);
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 16,
      title: Obx(() {
        if (controller.isSearching.value) {
          return TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search tasks...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey.shade400),
            ),
            style: const TextStyle(color: Colors.black87),
            onChanged: controller.setSearchText,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${controller.userName.value}!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              DateFormat('EEEE, d MMMM').format(DateTime.now()),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        );
      }),
      actions: [
        Obx(() {
          if (controller.isSearching.value) {
            return IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () {
                controller.toggleSearch();
              },
            );
          }
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  controller.toggleSearch();
                },
              ),
              IconButton(
                icon: const Icon(Icons.bar_chart, color: Colors.black),
                onPressed: () {
                  Get.to(() => const StatsView());
                },
              ),
              IconButton(
                icon: const Icon(Icons.category_outlined, color: Colors.black),
                onPressed: () {
                  Get.to(() => const CategoryListView());
                },
              ),
              IconButton(
                icon: Icon(
                  controller.hasActiveFilters ? Icons.filter_list_alt : Icons.filter_list,
                  color: controller.hasActiveFilters ? Colors.deepPurple : Colors.black,
                ),
                onPressed: () {
                  Get.bottomSheet(const FilterBottomSheet(), isScrollControlled: true);
                },
              ),
            ],
          );
        }),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTodaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeaderWidget(title: 'Today\'s Tasks'),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()),
            );
          }
          if (controller.todayTasks.isEmpty) {
            return const EmptyStateWidget(
              message: 'No tasks for today. Enjoy your day!',
              icon: Icons.wb_sunny_outlined,
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.todayTasks.length,
            itemBuilder: (context, index) {
              return TaskItemWidget(
                task: controller.todayTasks[index],
                onTap: (id) {
                  Get.toNamed(
                    Routes.taskDetails,
                    arguments: id,
                  )?.then((_) => controller.loadTasks());
                },
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildOngoingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeaderWidget(title: 'Ongoing'),
        Obx(() {
          if (!controller.isLoading.value && controller.ongoingTasks.isEmpty) {
            return const SizedBox.shrink(); // Hide section if empty? Or show empty state.
            // Let's show empty state for now to be clear
            return const EmptyStateWidget(message: 'No ongoing tasks.', icon: Icons.timelapse);
          }

          return SizedBox(
            height: 140, // Horizontal list height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.ongoingTasks.length,
              itemBuilder: (context, index) {
                final task = controller.ongoingTasks[index];
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 12),
                  child: TaskItemWidget(
                    task: task,
                    onTap: (id) => Get.toNamed(
                      Routes.taskDetails,
                      arguments: id,
                    )?.then((_) => controller.loadTasks()),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildUpcomingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeaderWidget(title: 'Upcoming'),
        Obx(() {
          if (!controller.isLoading.value && controller.upcomingTasks.isEmpty) {
            return const EmptyStateWidget(
              message: 'No upcoming tasks.',
              icon: Icons.calendar_today_outlined,
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.upcomingTasks.length,
            itemBuilder: (context, index) {
              return TaskItemWidget(
                task: controller.upcomingTasks[index],
                onTap: (id) => Get.toNamed(
                  Routes.taskDetails,
                  arguments: id,
                )?.then((_) => controller.loadTasks()),
              );
            },
          );
        }),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                children: const [_NameScreen(), _CategorySelectionScreen(), _SummaryScreen()],
              ),
            ),
            // Progress Indicator (Optional, but nice for UX)
            // Obx(() => Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children:List.generate(3, (index) => Container(
            //     margin: const EdgeInsets.all(4),
            //     width: 10, height: 10,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: controller.currentPage.value == index ? Colors.deepPurple : Colors.grey.shade300
            //     ),
            //   )),
            // )),
            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _NameScreen extends GetView<OnboardingController> {
  const _NameScreen();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Welcome!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'What should we call you?',
            style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodySmall?.color),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          TextField(
            controller: controller.nameController,
            onChanged: controller.updateName,
            decoration: const InputDecoration(
              labelText: 'Your Name (Optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: controller.nextPage,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Next'),
          ),
          TextButton(onPressed: controller.skipName, child: const Text('Skip')),
        ],
      ),
    );
  }
}

class _CategorySelectionScreen extends GetView<OnboardingController> {
  const _CategorySelectionScreen();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          const Text(
            'What do you want to achieve?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Select categories to start with.',
            style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodySmall?.color),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: controller.defaultCategories.map((category) {
                  final isSelected = controller.isCategorySelected(category);
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => controller.toggleCategory(category),
                    selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Row(
            children: [
              TextButton(onPressed: controller.previousPage, child: const Text('Back')),
              const Spacer(),
              ElevatedButton(
                onPressed: controller.nextPage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Next'),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SummaryScreen extends GetView<OnboardingController> {
  const _SummaryScreen();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Icon(Icons.check_circle_outline, size: 80, color: Theme.of(context).primaryColor),
          const SizedBox(height: 24),
          Obx(
            () => Text(
              'You\'re all set, ${controller.userName.value.isEmpty ? 'Friend' : controller.userName.value}!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'We have set up your workspace with the following categories:',
            style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodySmall?.color),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Obx(
            () => Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: controller.selectedCategories
                  .map(
                    (c) => Chip(
                      label: Text(c),
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You can always change this later in settings.',
            style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Row(
            children: [
              TextButton(onPressed: controller.previousPage, child: const Text('Back')),
              const Spacer(),
              ElevatedButton(
                onPressed: controller.completeOnboarding,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                ),
                child: const Text('Get Started'),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

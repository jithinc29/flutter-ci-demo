import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/providers/navigation_provider.dart';
import '../providers/auth_providers.dart';
import '../widgets/home_header.dart';
import '../widgets/promotional_banner.dart';
import '../widgets/stay_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  String _getUserName(String? email) {
    if (email == null || email.isEmpty) return 'Guest';
    final namePart = email.split('@').first;
    // Capitalize first letter
    return namePart.isNotEmpty
        ? namePart[0].toUpperCase() + namePart.substring(1)
        : 'Guest';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final userName = _getUserName(user?.email);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section
          HomeHeader(
            userName: userName,
            points: 0,
            onSearchTap: () {
              // Navigate to search page via bottom navigation
              ref.read(navigationIndexProvider.notifier).state = 1;
            },
            onPointsTap: () {
              // Handle points tap
            },
          ),
          // Content Section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Promotional Banner
                  const PromotionalBanner(),
                  // Your Stays Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your stays',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Stay Card
                        StayCard(
                          dateRange: '17-18 Jun 2025',
                          hotelName: 'Kimpton - Miami',
                          hotelInitial: 'K',
                          onTap: () {
                            // Handle stay card tap
                          },
                        ),
                        const SizedBox(height: 16),
                        // Club Member Benefits Button
                        OutlinedButton(
                          onPressed: () {
                            // Handle button tap
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            side: BorderSide(
                              color: Colors.blue.shade400,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Enjoy your Club Member benefits',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'vanban_thongbao_card.dart';
import 'meal_registration_card.dart';
import 'chamcong_today_card.dart';
import 'facebook_post_card.dart';

class TrangchuContent extends StatelessWidget {
  const TrangchuContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MealRegistrationCard()
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 16),
          const ChamcongTodayCard()
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 16),
          const FacebookPostCard()
              .animate()
              .fadeIn(delay: 300.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 16),
          const VanbanThongbaoCard()
              .animate()
              .fadeIn(delay: 450.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }
}

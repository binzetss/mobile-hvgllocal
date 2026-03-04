import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../data/models/meal_menu_model.dart';
import '../../providers/dangky_com_provider.dart';
import '../../providers/meal_menu_provider.dart';
import '../common/app_dialogs.dart';

class MealRegistrationCard extends StatefulWidget {
  const MealRegistrationCard({super.key});

  @override
  State<MealRegistrationCard> createState() => _MealRegistrationCardState();
}

class _MealRegistrationCardState extends State<MealRegistrationCard> {
  Timer? _syncTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DangkyComProvider>().loadTodayRegistrations();
    });

    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        context.read<DangkyComProvider>().loadTodayRegistrations();
      }
    });
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }

  Future<void> _toggleLunch() async {
    final provider = context.read<DangkyComProvider>();
    final error = await provider.toggleLunch();
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    } else {
      showSuccessDialog(
        context,
        title: provider.isLunchRegistered ? 'Đăng ký thành công' : 'Đã hủy',
        message: provider.isLunchRegistered
            ? 'Bạn đã đăng ký suất ăn trưa.'
            : 'Đã hủy đăng ký suất ăn trưa.',
      );
    }
  }

  Future<void> _toggleDinner() async {
    final provider = context.read<DangkyComProvider>();
    final error = await provider.toggleDinner();
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    } else {
      showSuccessDialog(
        context,
        title: provider.isDinnerRegistered ? 'Đăng ký thành công' : 'Đã hủy',
        message: provider.isDinnerRegistered
            ? 'Bạn đã đăng ký suất ăn tối.'
            : 'Đã hủy đăng ký suất ăn tối.',
      );
    }
  }

  void _showMenuDialog() async {
    final provider = Provider.of<MealMenuProvider>(context, listen: false);

    provider.fetchTodayMenu();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer<MealMenuProvider>(
        builder: (context, menuProvider, _) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppColors.primaryGradient,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.utensils,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thực đơn hôm nay',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Menu hàng ngày',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (menuProvider.isLoading)
                    const _MealMenuShimmer()
                  else if (menuProvider.hasError)
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.circleExclamation,
                            size: 40,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            menuProvider.errorMessage ?? 'Có lỗi xảy ra',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else if (menuProvider.currentMenu != null)
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          _buildMealSection(
                            title: 'Trưa',
                            icon: FontAwesomeIcons.cloudSun,
                            iconColor: const Color(0xFFFFA726),
                            session: menuProvider.currentMenu!.lunch,
                          ),
                          const SizedBox(height: 20),

                          _buildMealSection(
                            title: 'Tối',
                            icon: FontAwesomeIcons.moon,
                            iconColor: const Color(0xFF5C6BC0),
                            session: menuProvider.currentMenu!.dinner,
                          ),
                        ],
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

  Widget _buildMealSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required MealSession session,
  }) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF38383A) : AppColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FaIcon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...session.mainDishes.map(
            (dish) => _buildDishItem(dish, FontAwesomeIcons.utensils),
          ),
          if (session.sideDishes.isNotEmpty) ...[
            const SizedBox(height: 4),
            ...session.sideDishes.map(
              (dish) => _buildDishItem(dish, FontAwesomeIcons.leaf),
            ),
          ],
          ...session.soups.map(
            (soup) => _buildDishItem(soup, FontAwesomeIcons.bowlFood),
          ),
        ],
      ),
    );
  }

  Widget _buildDishItem(String dish, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 12,
            color: AppColors.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              dish,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dangky = context.watch<DangkyComProvider>();
    final isLunch = dangky.isLunchRegistered;
    final isDinner = dangky.isDinnerRegistered;
    final now = DateTime.now();
    final isPastDeadline = now.hour >= 8;
    final isDark = context.isDark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.5),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.primaryGradient,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.utensils,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Đăng ký suất ăn',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'Đăng ký trước 08:00',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (isPastDeadline) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Hết giờ',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: _showMenuDialog,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.bowlFood,
                        size: 11,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        size: 8,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (!isPastDeadline) ...[

            Row(
              children: [
                Expanded(
                  child: _buildMealButton(
                    label: isLunch ? 'Hủy Trưa' : 'Trưa',
                    icon: isLunch ? FontAwesomeIcons.xmark : FontAwesomeIcons.check,
                    isRegistered: isLunch,
                    isLoading: dangky.isLoadingLunch,
                    onTap: dangky.isLoadingLunch ? null : _toggleLunch,
                    mealIcon: FontAwesomeIcons.cloudSun,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMealButton(
                    label: isDinner ? 'Hủy Tối' : 'Tối',
                    icon: isDinner ? FontAwesomeIcons.xmark : FontAwesomeIcons.check,
                    isRegistered: isDinner,
                    isLoading: dangky.isLoadingDinner,
                    onTap: dangky.isLoadingDinner ? null : _toggleDinner,
                    mealIcon: FontAwesomeIcons.moon,
                  ),
                ),
              ],
            ),
            if (isLunch || isDinner) ...[
              const SizedBox(height: 12),
              _buildRegisteredSummary(isLunch, isDinner),
            ],
          ] else ...[

            if (!isLunch && !isDinner)
              _buildNotRegisteredInfo()
            else
              Row(
                children: [
                  if (isLunch)
                    Expanded(
                      child: _buildStatusChip(
                        'Trưa',
                        FontAwesomeIcons.cloudSun,
                      ),
                    ),
                  if (isLunch && isDinner) const SizedBox(width: 12),
                  if (isDinner)
                    Expanded(
                      child: _buildStatusChip(
                        'Tối',
                        FontAwesomeIcons.moon,
                      ),
                    ),

                  if (isLunch && !isDinner || !isLunch && isDinner)
                    const Expanded(child: SizedBox()),
                ],
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildRegisteredSummary(bool isLunch, bool isDinner) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success.withValues(alpha: 0.1),
            AppColors.success.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const FaIcon(
              FontAwesomeIcons.circleCheck,
              size: 14,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Đã đăng ký: ${isLunch ? "Trưa" : ""}${isLunch && isDinner ? ", " : ""}${isDinner ? "Tối" : ""}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, IconData mealIcon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(mealIcon, size: 14, color: AppColors.success),
          const SizedBox(width: 6),
          const FaIcon(
            FontAwesomeIcons.circleCheck,
            size: 12,
            color: AppColors.success,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotRegisteredInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline_rounded, size: 14, color: Colors.grey[500]),
          const SizedBox(width: 8),
          Text(
            'Không đăng ký hôm nay',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealButton({
    required String label,
    required IconData icon,
    required bool isRegistered,
    required bool isLoading,
    required VoidCallback? onTap,
    required IconData mealIcon,
  }) {
    final isDisabled = onTap == null && !isLoading;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            gradient: isDisabled
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFBDBDBD),
                      const Color(0xFFBDBDBD).withValues(alpha: 0.8),
                    ],
                  )
                : isRegistered
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.error,
                          AppColors.error.withValues(alpha: 0.8),
                        ],
                      )
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppColors.primaryGradient,
                      ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: (isRegistered ? AppColors.error : AppColors.primary)
                          .withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              else ...[
                FaIcon(mealIcon, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                FaIcon(icon, size: 10, color: Colors.white),
              ],
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
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

class _MealMenuShimmer extends StatelessWidget {
  const _MealMenuShimmer();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE8EAED);
    final highlightColor = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFF8F9FA);
    final sectionBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final sectionBorder = isDark ? const Color(0xFF38383A) : const Color(0xFFE4E6EB);
    final barColor = isDark ? const Color(0xFF2C2C2E) : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          children: [
            _buildSkeletonSection(sectionBg, sectionBorder, barColor),
            const SizedBox(height: 16),
            _buildSkeletonSection(sectionBg, sectionBorder, barColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonSection(Color sectionBg, Color sectionBorder, Color barColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: sectionBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: sectionBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 48,
                height: 16,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRow(1.0, barColor),
          _buildRow(0.75, barColor),
          _buildRow(0.85, barColor),
          _buildRow(0.55, barColor),
        ],
      ),
    );
  }

  Widget _buildRow(double widthFactor, Color barColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: FractionallySizedBox(
              widthFactor: widthFactor,
              alignment: Alignment.centerLeft,
              child: Container(
                height: 14,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

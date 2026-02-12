import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import 'huy_hieu_danhmuc.dart';

class DocumentHeader extends StatelessWidget {
  final String categoryName;
  final bool isNew;

  const DocumentHeader({
    super.key,
    required this.categoryName,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CategoryBadge(categoryName: categoryName),
        ),
        if (isNew)
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.star,
                  size: 10,
                  color: Colors.white,
                ),
                SizedBox(width: 4),
                Text(
                  'MỚI',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

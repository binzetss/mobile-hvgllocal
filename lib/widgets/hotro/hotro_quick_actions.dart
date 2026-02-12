import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/services/hotro_service.dart';

class HotroQuickActions extends StatelessWidget {
  const HotroQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final service = HotroService();

    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: FontAwesomeIcons.phone,
            label: 'Gọi điện',
            color: const Color(0xFF2E7D32),
            bgColor: const Color(0xFFE8F5E9),
            onTap: () => service.makePhoneCall('21101'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _QuickActionButton(
            icon: FontAwesomeIcons.comments,
            label: 'Chat Zalo',
            color: const Color(0xFF1976D2),
            bgColor: const Color(0xFFE3F2FD),
            onTap: () => service.openZalo('0905027776'),
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: FaIcon(icon, size: 22, color: color),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/lichkham_provider.dart';
import '../../core/constants/app_colors.dart';

class LichkhamFilters extends StatelessWidget {
  const LichkhamFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          _DateRangeFilter(),
          const SizedBox(height: 12),
          _RoomFilter(),
        ],
      ),
    );
  }
}

class _DateRangeFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LichkhamProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EAF0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.calendarDay,
                  size: 14,
                  color: Color(0xFF1565C0),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Khoảng thời gian',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DateRangeButton(
                  label: 'Hôm nay',
                  days: 1,
                  isSelected: provider.selectedDateRange == 1,
                  onTap: () => context.read<LichkhamProvider>().updateDateRange(1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DateRangeButton(
                  label: '7 ngày',
                  days: 7,
                  isSelected: provider.selectedDateRange == 7,
                  onTap: () => context.read<LichkhamProvider>().updateDateRange(7),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DateRangeButton(
                  label: 'Tùy chọn',
                  days: 0,
                  isSelected: provider.selectedDateRange == 0,
                  onTap: () => context.read<LichkhamProvider>().updateDateRange(0),
                ),
              ),
            ],
          ),
          if (provider.selectedDateRange == 0) ...[
            const SizedBox(height: 12),
            _CustomDatePicker(),
          ],
        ],
      ),
    );
  }
}

class _DateRangeButton extends StatelessWidget {
  final String label;
  final int days;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateRangeButton({
    required this.label,
    required this.days,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE8EAF0),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
      ),
    );
  }
}

class _CustomDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LichkhamProvider>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _DateField(
              label: 'Từ ngày',
              date: provider.startDate,
              onTap: () async {
                final date = await _pickDate(
                  context,
                  provider.startDate,
                );
                if (date != null) {
                  context.read<LichkhamProvider>().setStartDate(date);
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _DateField(
              label: 'Đến ngày',
              date: provider.endDate,
              onTap: () async {
                final date = await _pickDate(
                  context,
                  provider.endDate,
                );
                if (date != null) {
                  context.read<LichkhamProvider>().setEndDate(date);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _pickDate(BuildContext context, DateTime initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1A1A1A),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE8EAF0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy').format(date),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LichkhamProvider>();

    if (provider.rooms.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EAF0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.doorOpen,
                  size: 14,
                  color: Color(0xFF1565C0),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Chọn phòng khám',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: provider.selectedRoom,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE8EAF0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE8EAF0)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            items: [
              const DropdownMenuItem(value: 'all', child: Text('Tất cả phòng khám')),
              ...provider.rooms.map(
                (room) => DropdownMenuItem(value: room, child: Text(room)),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                context.read<LichkhamProvider>().selectRoom(value);
              }
            },
          ),
        ],
      ),
    );
  }
}

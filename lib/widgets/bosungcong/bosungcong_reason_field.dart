import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/bosung_chamcong_model.dart';

class BosungcongReasonField extends StatelessWidget {
  final TextEditingController controller;

  const BosungcongReasonField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
                FontAwesomeIcons.commentDots,
                size: 12,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Lý do',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return BosungReasons.reasons;
            }
            return BosungReasons.reasons.where((option) =>
                option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (String selection) {
            controller.text = selection;
          },
          fieldViewBuilder: (context, fieldController, focusNode, onFieldSubmitted) {
            controller.text = fieldController.text;
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.2),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: fieldController,
                focusNode: focusNode,
                maxLines: 3,
                onChanged: (value) {
                  controller.text = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Chọn hoặc nhập lý do...',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: AppColors.textHint,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                  height: 1.4,
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  constraints: const BoxConstraints(maxHeight: 240),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: AppColors.border.withValues(alpha: 0.1),
                    ),
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.circleCheck,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

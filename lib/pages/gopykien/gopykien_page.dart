import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/common/app_dialogs.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/gopykien_model.dart';
import '../../providers/gopykien_provider.dart';
import '../../widgets/gopykien/gopykien_header.dart';
import '../../widgets/gopykien/gopykien_form_card.dart';
import '../../widgets/gopykien/gopykien_submit_button.dart';

class GopyKienPage extends StatefulWidget {
  const GopyKienPage({super.key});

  @override
  State<GopyKienPage> createState() => _GopyKienPageState();
}

class _GopyKienPageState extends State<GopyKienPage> {
  final _feedbackController = TextEditingController();
  String _selectedCategory = 'Góp ý chung';

  final List<String> _categories = [
    'Góp ý chung',
    'Chức năng app',
    'Giao diện',
    'Hiệu suất',
    'Dịch vụ bệnh viện',
    'Khác',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CommonAppBar(title: 'Góp ý và đánh giá'),
      body: Consumer<GopyKienProvider>(
        builder: (context, provider, _) {
          if (provider.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showSuccessDialog(
                context,
                title: 'Cảm ơn bạn!',
                message:
                    'Góp ý của bạn đã được gửi thành công.\nChúng tôi sẽ xem xét và phản hồi sớm nhất.',
              );
              _feedbackController.clear();
              setState(() => _selectedCategory = 'Góp ý chung');
              provider.reset();
            });
          }

          if (provider.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showErrorDialog(
                context,
                message: provider.errorMessage ?? 'Gửi góp ý thất bại',
              );
              provider.clearError();
            });
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const GopyKienHeader(),
                  const SizedBox(height: 24),
                  GopyKienFormCard(
                    selectedCategory: _selectedCategory,
                    categories: _categories,
                    onCategoryChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                    feedbackController: _feedbackController,
                  ),
                  const SizedBox(height: 24),
                  GopyKienSubmitButton(
                    isSubmitting: provider.isSubmitting,
                    onPressed: () => _handleSubmit(provider),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleSubmit(GopyKienProvider provider) {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập nội dung góp ý'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    provider.submitFeedback(
      GopyKienModel(
        name: 'User',
        category: _selectedCategory,
        content: _feedbackController.text.trim(),
      ),
    );
  }
}

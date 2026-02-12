import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/bosung_chamcong_model.dart';
import '../../providers/xacthuc_provider.dart';
import '../../providers/bosung_chamcong_provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/common/app_dialogs.dart';
import '../../widgets/bosungcong/bosungcong_info_field.dart';
import '../../widgets/bosungcong/bosungcong_dropdown_field.dart';
import '../../widgets/bosungcong/bosungcong_session_selector.dart';
import '../../widgets/bosungcong/bosungcong_reason_field.dart';
import '../../widgets/bosungcong/bosungcong_date_picker.dart';
import '../../widgets/bosungcong/bosungcong_submit_button.dart';

class BosungcongPage extends StatefulWidget {
  const BosungcongPage({super.key});

  @override
  State<BosungcongPage> createState() =>
      _BosungcongPageState();
}

class _BosungcongPageState
    extends State<BosungcongPage> {
  final _formKey = GlobalKey<FormState>();
  final _lyDoController = TextEditingController();

  String _selectedLoai = BosungTypes.types.first;
  SessionType _selectedBuoi = SessionType.morning;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _lyDoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<XacthucProvider>();
    final userName = authProvider.user?.hoVaTen ?? 'Chưa xác định';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CommonAppBar(title: 'Bổ Sung Công'),
      body: Consumer<BosungChamcongProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BosungcongInfoField(
                    label: 'Họ và tên',
                    value: userName,
                    icon: FontAwesomeIcons.user,
                  ),
                  const SizedBox(height: 16),
                  BosungcongDropdownField(
                    label: 'Loại',
                    value: _selectedLoai,
                    items: BosungTypes.types,
                    icon: FontAwesomeIcons.briefcase,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedLoai = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  BosungcongSessionSelector(
                    selectedSession: _selectedBuoi,
                    onSessionChanged: (session) {
                      setState(() => _selectedBuoi = session);
                    },
                  ),
                  const SizedBox(height: 16),
                  BosungcongDatePicker(
                    selectedDate: _selectedDate,
                    onDateChanged: (date) {
                      setState(() => _selectedDate = date);
                    },
                  ),
                  const SizedBox(height: 16),
                  BosungcongReasonField(
                    controller: _lyDoController,
                  ),
                  const SizedBox(height: 32),
                  BosungcongSubmitButton(
                    isLoading: provider.isLoading,
                    onPressed: () => _submitForm(provider, userName),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _submitForm(
    BosungChamcongProvider provider,
    String userName,
  ) async {
    final lyDo = _lyDoController.text.trim();
    if (lyDo.isEmpty) {
      showErrorDialog(
        context,
        message: 'Vui lòng nhập hoặc chọn lý do',
      );
      return;
    }

    final success = await provider.addSupplementaryAttendance(
      hoVaTen: userName,
      loai: _selectedLoai,
      buoi: _selectedBuoi,
      ngayBoSung: _selectedDate,
      lyDo: lyDo,
    );

    if (success && mounted) {
      showSuccessDialog(
        context,
        title: 'Thành công!',
        message: 'Đăng ký bổ sung công thành công.',
        autoCloseDuration: const Duration(milliseconds: 1500),
      );
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) Navigator.pop(context, true);
      });
    } else if (mounted) {
      showErrorDialog(
        context,
        message: provider.error ?? 'Đăng ký thất bại',
      );
    }
  }
}

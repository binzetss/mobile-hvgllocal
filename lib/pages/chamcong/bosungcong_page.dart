import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../data/models/bosung_chamcong_model.dart';
import '../../providers/xacthuc_provider.dart';
import '../../providers/bosung_chamcong_provider.dart';
import '../../providers/navigation_provider.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<XacthucProvider>().refreshUserNameIfNeeded();
      }
    });
  }

  @override
  void dispose() {
    _lyDoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    if (isDesktop) return _buildWebLayout();
    return _buildMobileLayout();
  }

  Widget _buildMobileLayout() {
    final authProvider = context.watch<XacthucProvider>();
    final hoVaTen = authProvider.user?.hoVaTen;
    final userName = (hoVaTen != null && hoVaTen.isNotEmpty)
        ? hoVaTen
        : authProvider.user?.maSo ?? 'Chưa xác định';

    return Scaffold(
      backgroundColor: context.bgColor,
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

  Widget _buildWebLayout() {
    final authProvider = context.watch<XacthucProvider>();
    final hoVaTen = authProvider.user?.hoVaTen;
    final userName = (hoVaTen != null && hoVaTen.isNotEmpty)
        ? hoVaTen
        : authProvider.user?.maSo ?? 'Chưa xác định';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          _WebBreadcrumb(
            onBack: () => context.read<NavigationProvider>().setIndex(3),
          ),
          // Form
          Expanded(
            child: Consumer<BosungChamcongProvider>(
              builder: (context, provider, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: _WebFormCard(
                        formKey: _formKey,
                        userName: userName,
                        selectedLoai: _selectedLoai,
                        selectedBuoi: _selectedBuoi,
                        selectedDate: _selectedDate,
                        lyDoController: _lyDoController,
                        isLoading: provider.isLoading,
                        onLoaiChanged: (v) {
                          if (v != null) setState(() => _selectedLoai = v);
                        },
                        onBuoiChanged: (s) => setState(() => _selectedBuoi = s),
                        onDateChanged: (d) => setState(() => _selectedDate = d),
                        onSubmit: () => _submitForm(provider, userName),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
      );
      final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        if (isDesktop) {
          context.read<NavigationProvider>().setIndex(3);
        } else {
          Navigator.pop(context, true);
        }
      });
    } else if (mounted) {
      showErrorDialog(
        context,
        message: provider.error ?? 'Đăng ký thất bại',
      );
    }
  }
}

// ── Web-only helper widgets ───────────────────────────────────────────────────

class _WebBreadcrumb extends StatelessWidget {
  final VoidCallback onBack;
  const _WebBreadcrumb({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: isDark ? 0.6 : 0.85),
        border: Border(
          bottom: BorderSide(color: context.borderColor.withValues(alpha: 0.4)),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios_rounded,
                      size: 13, color: context.primaryColor),
                  const SizedBox(width: 4),
                  Text('Chấm công',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.primaryColor)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(Icons.chevron_right_rounded,
                size: 16, color: context.textSecondary),
          ),
          Text('Bổ Sung Công',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: context.textSecondary)),
        ],
      ),
    );
  }
}

class _WebFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String userName;
  final String selectedLoai;
  final SessionType selectedBuoi;
  final DateTime selectedDate;
  final TextEditingController lyDoController;
  final bool isLoading;
  final ValueChanged<String?> onLoaiChanged;
  final ValueChanged<SessionType> onBuoiChanged;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onSubmit;

  const _WebFormCard({
    required this.formKey,
    required this.userName,
    required this.selectedLoai,
    required this.selectedBuoi,
    required this.selectedDate,
    required this.lyDoController,
    required this.isLoading,
    required this.onLoaiChanged,
    required this.onBuoiChanged,
    required this.onDateChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.4),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: context.borderColor.withValues(alpha: 0.5)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1877F2), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1877F2).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const FaIcon(FontAwesomeIcons.clockRotateLeft,
                      size: 20, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Đăng ký bổ sung công',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: context.textPrimary,
                            letterSpacing: -0.4)),
                    const SizedBox(height: 2),
                    Text('Điền đầy đủ thông tin để gửi yêu cầu bổ sung',
                        style: TextStyle(
                            fontSize: 13,
                            color: context.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          // ── Form body
          Padding(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Họ tên + Loại
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: BosungcongInfoField(
                          label: 'Họ và tên',
                          value: userName,
                          icon: FontAwesomeIcons.user,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: BosungcongDropdownField(
                          label: 'Loại công',
                          value: selectedLoai,
                          items: BosungTypes.types,
                          icon: FontAwesomeIcons.briefcase,
                          onChanged: onLoaiChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Row 2: Ngày + Buổi
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: BosungcongDatePicker(
                          selectedDate: selectedDate,
                          onDateChanged: onDateChanged,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: BosungcongSessionSelector(
                          selectedSession: selectedBuoi,
                          onSessionChanged: onBuoiChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Lý do full width
                  BosungcongReasonField(controller: lyDoController),
                  const SizedBox(height: 28),
                  // Submit
                  SizedBox(
                    width: double.infinity,
                    child: BosungcongSubmitButton(
                      isLoading: isLoading,
                      onPressed: onSubmit,
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

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hvgl/data/models/phongban_model.dart';
import 'package:hvgl/providers/nhansu_provider.dart';
import 'package:provider/provider.dart';
import '../../data/models/nhansu_model.dart';
import 'nhansu_card.dart';
import 'skeleton_nhansu_card.dart';

class PhongbanSection extends StatefulWidget {
  final PhongbanModel department;
  final List<NhansuModel> staffList;
  // final bool isExpanded;
  // final VoidCallback onToggle;
  final int index;

  const PhongbanSection({
    super.key,
    required this.department,
     this.staffList = const [],
    // required this.isExpanded,
    // required this.onToggle,
    this.index = 0,
  });

  @override
  State<PhongbanSection> createState() => _PhongbanSectionState();
}

class _PhongbanSectionState extends State<PhongbanSection> {
  IconData _getDepartmentIcon() {
    final name = widget.department.tenKhoa.toLowerCase();

    if (name.contains('ban giám đốc')) return FontAwesomeIcons.userTie;
    if (name.contains('ban kiểm soát')) return FontAwesomeIcons.clipboard;
    if (name.contains('hội đồng thành viên')) return FontAwesomeIcons.users;
    if (name.contains('công đoàn')) return FontAwesomeIcons.handshake;

    if (name.contains('chưa phân loại')) return FontAwesomeIcons.question;
    if (name.contains('chuyên gia') || name.contains('cộng tác viên'))
      return FontAwesomeIcons.userGraduate;
    if (name.contains('khách hàng')) return FontAwesomeIcons.userGroup;
    if (name.contains('thuê ngoài') || name.contains('công nhật'))
      return FontAwesomeIcons.userClock;

    if (name.contains('khám sức khỏe')) return FontAwesomeIcons.heartPulse;
    if (name.contains('mua sắm')) return FontAwesomeIcons.cartShopping;
    if (name.contains('tổng kho')) return FontAwesomeIcons.warehouse;
    if (name.contains('tổ thư ký')) return FontAwesomeIcons.fileSignature;

    if (name.contains('khoa chẩn đoán hình ảnh')) return FontAwesomeIcons.xRay;
    if (name.contains('khoa chấn thương')) return FontAwesomeIcons.userDoctor;
    if (name.contains('khoa dinh dưỡng')) return FontAwesomeIcons.appleWhole;
    if (name.contains('khoa dược')) return FontAwesomeIcons.pills;
    if (name.contains('khoa hstc') || name.contains('chống độc'))
      return FontAwesomeIcons.truckMedical;
    if (name.contains('khoa khám bệnh')) return FontAwesomeIcons.stethoscope;
    if (name.contains('khoa kiểm soát nhiễm khuẩn'))
      return FontAwesomeIcons.shieldVirus;
    if (name.contains('khoa ngoại')) return FontAwesomeIcons.userDoctor;
    if (name.contains('khoa nhi')) return FontAwesomeIcons.baby;
    if (name.contains('khoa nội tim mạch')) return FontAwesomeIcons.heartPulse;
    if (name.contains('khoa nội')) return FontAwesomeIcons.heartPulse;
    if (name.contains('khoa phẫu thuật')) return FontAwesomeIcons.syringe;
    if (name.contains('khoa phcn') || name.contains('y học cổ truyền'))
      return FontAwesomeIcons.personWalking;
    if (name.contains('khoa phụ sản')) return FontAwesomeIcons.personPregnant;
    if (name.contains('khoa xét nghiệm')) return FontAwesomeIcons.flask;
    if (name.contains('liên chuyên khoa')) return FontAwesomeIcons.sitemap;

    if (name.contains('phòng bảo hiểm')) return FontAwesomeIcons.shieldHalved;
    if (name.contains('phòng công nghệ thông tin'))
      return FontAwesomeIcons.computer;
    if (name.contains('phòng công tác xã hội'))
      return FontAwesomeIcons.handHoldingHeart;
    if (name.contains('phòng đào tạo'))
      return FontAwesomeIcons.chalkboardUser;
    if (name.contains('phòng điều dưỡng')) return FontAwesomeIcons.userNurse;
    if (name.contains('phòng kế hoạch')) return FontAwesomeIcons.chartLine;
    if (name.contains('phòng quản lý tài sản'))
      return FontAwesomeIcons.building;
    if (name.contains('phòng quản trị')) return FontAwesomeIcons.fileLines;
    if (name.contains('phòng tài chính') || name.contains('kế toán'))
      return FontAwesomeIcons.sackDollar;
    if (name.contains('phòng vttbyt') || name.contains('ktht'))
      return FontAwesomeIcons.boxesStacked;

    return FontAwesomeIcons.hospital;
  }

  Color _getDepartmentColor() {
    final name = widget.department.tenKhoa.toLowerCase();
    if (name.contains('nội')) return const Color(0xFF2196F3);
    if (name.contains('ngoại')) return const Color(0xFF9C27B0);
    if (name.contains('sản')) return const Color(0xFFE91E63);
    if (name.contains('nhi')) return const Color(0xFFFF9800);
    if (name.contains('cấp cứu')) return const Color(0xFFF44336);
    if (name.contains('xét nghiệm')) return const Color(0xFF4CAF50);
    if (name.contains('hình ảnh')) return const Color(0xFF00BCD4);
    if (name.contains('dược')) return const Color(0xFF673AB7);
    if (name.contains('hành chính')) return const Color(0xFF757575);
    if (name.contains('tài chính')) return const Color(0xFF009688);
    return const Color(0xFF2196F3);
  }


  @override
  Widget build(BuildContext context) {
    final color = _getDepartmentColor();
    final icon = _getDepartmentIcon();
    final headStaff = widget.staffList.where((s) => s.isHead).firstOrNull;

    return Selector<NhansuProvider, bool>(
      selector: (context, provider) => provider.expandedDepartments.contains(widget.department.tenKhoa),
      builder: (context, isExpanded, child) => Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                final provider = context.read<NhansuProvider>();
                final deptKey = widget.department.tenKhoa;
                debugPrint('🔍 PhongbanSection: Tapping on "$deptKey"');

                provider.toggleDepartment(deptKey);

                if (provider.expandedDepartments.contains(deptKey)) {
                  debugPrint('🔍 Loading staff for "$deptKey"');
                  provider.loadStaffByIdDept(deptKey);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color.withValues(alpha: 0.2),
                            color.withValues(alpha: 0.12),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: color.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: FaIcon(icon, color: color, size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.department.tenKhoa,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (headStaff != null)
                                Flexible(
                                  child: _buildInfoChip(
                                    icon: FontAwesomeIcons.crown,
                                    text: headStaff.hoVaTen.split(' ').last,
                                    color: const Color(0xFFFF9800),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    AnimatedRotation(
                      turns: isExpanded ?  0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOutCubic,
                      child: FaIcon(
                        FontAwesomeIcons.chevronDown,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              child: isExpanded
                  ? Consumer<NhansuProvider>(builder: (context, value, child) {
                    bool isLoading = value.isLoadingDepartment(widget.department.tenKhoa);
                    List<NhansuModel> staffList = value.staffByDepartment[widget.department.tenKhoa] ?? [];

                    return Container(
                      color: Colors.grey[50],
                      child: Column(
                        children: [
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey[200],
                          ),
                          if (isLoading)
                            ListView.separated(
                              padding: const EdgeInsets.all(10),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, idx) {
                                return SkeletonNhansuCard(
                                  departmentColor: color,
                                );
                              },
                            )
                          else if (staffList.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Column(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.userSlash,
                                    color: Colors.grey[400],
                                    size: 28,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Chưa có nhân viên',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ListView.separated(
                              padding: const EdgeInsets.all(10),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: staffList.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, idx) {
                                final staff = staffList[idx];
                                return NhansuCard(
                                      staff: staff,
                                      departmentColor: color,
                                      index: idx,
                                    )
                                    .animate()
                                    .fadeIn(
                                      delay: Duration(milliseconds: 30 * idx),
                                      duration: const Duration(milliseconds: 20),
                                    )
                                    .slideX(
                                      begin: 0.04,
                                      end: 0,
                                      delay: Duration(milliseconds: 30 * idx),
                                      duration: const Duration(milliseconds: 20),
                                      curve: Curves.easeOutCubic,
                                    );
                              },
                            ),
                        ],
                      ),
                    );
                  },)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

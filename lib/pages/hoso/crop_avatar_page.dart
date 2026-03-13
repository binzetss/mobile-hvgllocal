import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:crop/crop.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/constants/app_colors.dart';

class CropAvatarPage extends StatefulWidget {
  final File imageFile;

  const CropAvatarPage({super.key, required this.imageFile});

  @override
  State<CropAvatarPage> createState() => _CropAvatarPageState();
}

class _CropAvatarPageState extends State<CropAvatarPage>
    with TickerProviderStateMixin {
  final _controller = CropController(aspectRatio: 1);
  bool _isCropping = false;
  double? _selectedRatio = 1;
  double _naturalRatio = 1;

  late AnimationController _pulseCtrl;
  late AnimationController _scanCtrl;
  late AnimationController _rotateCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();
    _loadNaturalRatio();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.1).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _scanAnim = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _scanCtrl.dispose();
    _rotateCtrl.dispose();
    super.dispose();
  }

  Future<void> _done() async {
    setState(() => _isCropping = true);
    try {
      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final cropped = await _controller.crop(pixelRatio: pixelRatio);
      if (cropped == null) {
        if (mounted) setState(() => _isCropping = false);
        return;
      }
      final byteData =
          await cropped.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/avatar_crop_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await file.writeAsBytes(bytes);
      if (mounted) Navigator.pop(context, file);
    } catch (_) {
      if (mounted) setState(() => _isCropping = false);
    }
  }

  Future<void> _loadNaturalRatio() async {
    final bytes = await widget.imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final img = frame.image;
    final ratio = img.width / img.height;
    if (mounted) setState(() => _naturalRatio = ratio);
  }

  void _setRatio(double? ratio) {
    setState(() {
      _selectedRatio = ratio;
      _controller.aspectRatio = ratio ?? _naturalRatio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [

                Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  height: 52,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed:
                            _isCropping ? null : () => Navigator.pop(context),
                        child: Text(
                          'Huỷ',
                          style: TextStyle(
                            color: _isCropping
                                ? Colors.white38
                                : Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Canh chỉnh ảnh',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _isCropping ? null : _done,
                        child: Text(
                          'Xong',
                          style: TextStyle(
                            color: _isCropping
                                ? Colors.white38
                                : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Crop(
                    controller: _controller,
                    backgroundColor: Colors.black,
                    dimColor: Colors.black.withValues(alpha: 0.6),
                    helper: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                    child: Image.file(widget.imageFile, fit: BoxFit.cover),
                  ),
                ),

                Container(
                  color: const Color(0xFF1A1A1A),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRatioBtn('Vuông', 1),
                      _buildRatioBtn('4:3', 4 / 3),
                      _buildRatioBtn('3:2', 3 / 2),
                      _buildRatioBtn('Tự do', null),
                    ],
                  ),
                ),
              ],
            ),

            if (_isCropping) _buildAiOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildAiOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [

                  AnimatedBuilder(
                    animation: _rotateCtrl,
                    builder: (_, _) => Transform.rotate(
                      angle: _rotateCtrl.value * 2 * math.pi,
                      child: CustomPaint(
                        size: const Size(110, 110),
                        painter: _ArcPainter(),
                      ),
                    ),
                  ),

                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, child) => Transform.scale(
                      scale: _pulseAnim.value,
                      child: child,
                    ),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.15),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, _) => Icon(
                      Icons.smart_toy_rounded,
                      size: 44,
                      color: Color.lerp(
                        AppColors.primary,
                        Colors.white,
                        (_pulseAnim.value - 0.85) / 0.25,
                      ),
                    ),
                  ),

                  ClipOval(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: AnimatedBuilder(
                        animation: _scanAnim,
                        builder: (_, _) => CustomPaint(
                          painter: _ScanLinePainter(
                            progress: _scanAnim.value,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _AnimatedDotsText(color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildRatioBtn(String label, double? ratio) {
    final selected = _selectedRatio == ratio;
    return GestureDetector(
      onTap: () => _setRatio(ratio),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.primary : Colors.white60,
              fontSize: 14,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? AppColors.primary : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    paint.color = AppColors.primary.withValues(alpha: 0.8);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi * 0.7,
      false,
      paint,
    );

    paint.color = AppColors.primary.withValues(alpha: 0.3);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.8,
      math.pi * 0.7,
      false,
      paint,
    );

    paint.color = AppColors.primary.withValues(alpha: 0.15);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 1.6,
      math.pi * 0.35,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScanLinePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ScanLinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * (progress + 1) / 2;

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0),
          color.withValues(alpha: 0.7),
          color.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(0, y - 1, size.width, 2));

    canvas.drawRect(Rect.fromLTWH(0, y - 1, size.width, 2), paint);

    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.15),
          color.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(0, y, size.width, 12));

    canvas.drawRect(Rect.fromLTWH(0, y, size.width, 12), glowPaint);
  }

  @override
  bool shouldRepaint(_ScanLinePainter old) => old.progress != progress;
}

class _AnimatedDotsText extends StatefulWidget {
  final Color color;
  const _AnimatedDotsText({required this.color});

  @override
  State<_AnimatedDotsText> createState() => _AnimatedDotsTextState();
}

class _AnimatedDotsTextState extends State<_AnimatedDotsText> {
  int _dots = 0;

  @override
  void initState() {
    super.initState();
    _tick();
  }

  void _tick() {
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _dots = (_dots + 1) % 4);
      _tick();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Đang phân tích${'.' * _dots}',
      style: TextStyle(
        color: widget.color,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }
}

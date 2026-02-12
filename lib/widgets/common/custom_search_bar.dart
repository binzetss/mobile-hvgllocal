import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final EdgeInsetsGeometry? padding;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Tìm kiếm...',
    this.onChanged,
    this.onClear,
    this.padding,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final effectivePadding = widget.padding ?? const EdgeInsets.all(16);
    final hasNoPadding = effectivePadding == EdgeInsets.zero;

    return Padding(
      padding: effectivePadding,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: hasNoPadding ? BorderRadius.zero : BorderRadius.circular(12),
          border: hasNoPadding
              ? Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                )
              : Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
        ),
        child: TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[600],
              size: 22,
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    onPressed: () {
                      widget.controller.clear();
                      if (widget.onClear != null) widget.onClear!();
                      if (widget.onChanged != null) widget.onChanged!('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:zo_animated_border/widget/zo_dual_border.dart';

class ToggleCircleButton extends StatefulWidget {
  final int initialValue; 
  final ValueChanged<int> onChanged;
  final double size;

  const ToggleCircleButton({
    super.key,
    this.initialValue = 0,
    required this.onChanged,
    this.size = 80,
  });

  @override
  State<ToggleCircleButton> createState() => _ToggleCircleButtonState();
}

class _ToggleCircleButtonState extends State<ToggleCircleButton> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _toggle() {
    setState(() {
      _value = _value == 1 ? 0 : 1;
      widget.onChanged(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _value == 1;

    return GestureDetector(
      onTap: _toggle,
      child: ZoDualBorder(
        glowOpacity: 0.45,
        borderWidth: 6,
        borderRadius: BorderRadius.circular(999),
        trackBorderColor: Colors.transparent,
        firstBorderColor:
            isActive ? Colors.green : Colors.red,
        secondBorderColor:
            isActive ? Colors.lightGreen : Colors.redAccent,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isActive ? Icons.check : Icons.close,
              key: ValueKey(isActive),
              size: widget.size * 0.45,
              color: isActive ? Colors.green : Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}

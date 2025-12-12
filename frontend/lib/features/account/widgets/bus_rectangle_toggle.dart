import 'package:aurabus/common/widgets/bus_rectangle.dart';
import 'package:aurabus/theme.dart';
import 'package:flutter/material.dart';

class SelectableBusRectangle extends StatefulWidget {
  final BusRectangle bus;

  const SelectableBusRectangle({required this.bus, super.key});

  @override
  SelectableBusRectangleState createState() => SelectableBusRectangleState();
}

class SelectableBusRectangleState extends State<SelectableBusRectangle> {
  bool isSelected = false;

  void _toggleSelection() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSelection,
      child: Container(
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: AppColors.primary, width: 3) : null,
          borderRadius: BorderRadius.circular(widget.bus.size * 6),
        ),
        child: widget.bus,
      ),
    );
  }
}

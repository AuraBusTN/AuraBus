import 'package:aurabus/common/widgets/bus_rectangle.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';
import 'package:aurabus/theme.dart';
import 'package:flutter/material.dart';

class SelectableBusRectangle extends StatelessWidget {
  final RouteInfo route;
  final double size;
  final bool isSelected;
  final VoidCallback onToggle;

  const SelectableBusRectangle({
    super.key,
    required this.route,
    required this.size,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bus = BusRectangle.fromRoute(route, size);

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 3)
              : null,
          borderRadius: BorderRadius.circular(size * 6),
        ),
        child: bus,
      ),
    );
  }
}

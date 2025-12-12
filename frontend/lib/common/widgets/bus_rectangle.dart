import 'package:aurabus/common/models/stop_data.dart' ;
import 'package:aurabus/common/models/stop_details.dart';
import 'package:aurabus/theme.dart';
import 'package:flutter/material.dart' hide Route;


class BusRectangle extends StatelessWidget {
  final String shortName;
  final Color color;
  final double size;

  const BusRectangle._({required this.shortName, required this.color, required this.size});

  factory BusRectangle.fromRoute(BusRoute route,double rectsize) {
    return BusRectangle._(
      shortName: route.routeShortName,
      color: route.routeColor,
      size: rectsize,
    );
  }

  factory BusRectangle.fromStopArrival(StopArrival stop, double rectsize) {
    return BusRectangle._(
      shortName: stop.routeShortName,
      color: stop.routeColor,
      size: rectsize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size*14,
      height: size*14,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size*4),
      ),
      child: Text(
        shortName,
        style: TextStyle(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.w700,
          fontSize: size*6,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DeviceConfig {
  final String name;
  final Size size;

  const DeviceConfig(this.name, this.size);
}

class TestDevices {
  static const List<DeviceConfig> all = [
    DeviceConfig('Galaxy Z Fold (Cover)', Size(320, 800)),

    DeviceConfig('iPhone SE / Small Android', Size(375, 667)),

    DeviceConfig('Pixel / iPhone Standard', Size(1080, 2400)),

    DeviceConfig('iPad / Tablet', Size(1536, 2048)),
    DeviceConfig('Tablet Landscape', Size(2048, 1536)),

    DeviceConfig('Desktop HD', Size(1920, 1080)),
    DeviceConfig('Large Desktop', Size(2560, 1440)),
  ];
}

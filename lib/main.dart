import 'package:flutter/material.dart';
import 'package:rentora/core/services/hive_service.dart';
import 'package:rentora/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hiveService = HiveService();
  await hiveService.init();
  runApp(MyApp());
}

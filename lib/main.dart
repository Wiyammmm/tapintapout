import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tapintapout/core/theme.dart';
import 'package:tapintapout/presentation/pages/loginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('myBox');

  runApp(const MyApp());
}

Future<void> _initializeHive() async {
  late Box box;
  List<String> tags = [];
  // Open the box
  box = await Hive.openBox('myBox');

  // Retrieve the tags list
  List<String>? storedTags = box.get('tags')?.cast<String>();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filipay',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const LoginPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intellectiq/screens/home/home.dart';
import 'package:intellectiq/utils/ai_util.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'design/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationDocumentsDirectory();
  await appDir.create(recursive: true);
  final dbPath = join(appDir.path, 'intellectiq.db');
  final db = await databaseFactoryIo.openDatabase(dbPath);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ApiKeyProvider(db),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Geist",
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.mainAppColor),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
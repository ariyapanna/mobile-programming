import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:frontend_mobile/pages/main/main_page.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const CatatIn());
}

class CatatIn extends StatelessWidget {
  const CatatIn({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catat.in',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      home: const MainPage(),
    );
  }
}
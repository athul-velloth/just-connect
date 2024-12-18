import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:justconnect/theme/just_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Ui/splash_screen.dart';
import 'constants/strings.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Strings.SUPABASE_URL,
    anonKey: Strings.SUPABASE_ANON_KEY,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: JustTheme().themeData,
      home: const SplashScreen(),
    );
  }
}
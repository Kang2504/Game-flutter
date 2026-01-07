import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glogic/screens/home.dart';
import 'package:glogic/screens/plays.dart';
import 'package:glogic/screens/signin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fefxftjltbjqxqmgvtdc.supabase.co',
    anonKey: 'sb_publishable_p6ZVBuLNqegs9vXI3F5fzw_MkA3KBPG',
  );
  final session = Supabase.instance.client.auth.currentSession;

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/signin',

      routes: {
        '/signup': (context) => SignupPage(),
        '/signin': (context) => LoginPage(),
        '/home': (context) => GameHomePage(),
        '/cases': (context) => CaseSelectionScreen(),
      },
    );
  }
}

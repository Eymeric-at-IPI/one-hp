import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:one_hp/providers/internet_provider.dart';
import 'package:one_hp/providers/sign_in_provider.dart';
import 'package:provider/provider.dart';
import './screens/splash_screen.dart';

/// Entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // TODO : utilité?
  await Firebase.initializeApp();
  runApp(const OnHp());
}

class OnHp extends StatelessWidget {
  const OnHp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => SignInProvider()
        ),
        ChangeNotifierProvider(
            create: (context) => InternetProvider()
        ),
      ],
      child: const MaterialApp(
        title: "One HP",
        home: SplashScreen(),
        debugShowCheckedModeBanner: true,
      ),
    );
  }
}
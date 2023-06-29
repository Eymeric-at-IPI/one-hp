import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'theme/style.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:one_hp/providers/internet_provider.dart';
import 'package:one_hp/providers/sign_in_provider.dart';
import 'package:provider/provider.dart';
import './screens/splash_screen.dart';

/// Entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const OnHp());
}

class OnHp extends StatelessWidget {
  const OnHp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appName = "One HP";

    return FlutterWebFrame(
      builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => SignInProvider()),
            ChangeNotifierProvider(create: (context) => InternetProvider()),
          ],
          child: MaterialApp(
            title: appName,
            theme: appTheme(),
            home: const SplashScreen(),
            debugShowCheckedModeBanner: true,
          ),
        );
      },
      maximumSize: const Size(475.0, 0),
      enabled: kIsWeb,
      backgroundColor: Colors.grey,
    );
  }
}

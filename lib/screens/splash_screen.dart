import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_hp/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:one_hp/providers/sign_in_provider.dart';

import '../utils/next_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    final signInProvider = context.read<SignInProvider>();

    Timer(const Duration(seconds: 2), () {
      signInProvider.isSignIn == false
          ? nextScreen(context, const LoginScreen())
          : nextScreen(context, const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Image(
            image: AssetImage(Config.appIcon),
            height: 80,
            width: 80,
          ),
        ),
      ),
    );
  }
}
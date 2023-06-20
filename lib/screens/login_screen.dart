import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:one_hp/providers/internet_provider.dart';
import 'package:one_hp/screens/home_screen.dart';
import 'package:one_hp/utils/config.dart';
import 'package:one_hp/utils/next_screen.dart';
import 'package:one_hp/utils/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../providers/sign_in_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController googleButtonController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.amber, // TODO color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 40,right: 40, top: 90, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: AssetImage(Config.appIcon),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Welcome to One HP !",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500
                      )
                    ),
                    SizedBox(height: 10),
                    Text(
                      "??? !",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue
                      )
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google SignIn
                  RoundedLoadingButton(
                      controller: googleButtonController,
                      onPressed: () {handleGoogleSignIn();},
                      successColor: Colors.red,
                      width: MediaQuery.of(context).size.width * 0.8,
                      elevation: 0,
                      borderRadius: 25,
                      color: Colors.red,
                      child: const Wrap(
                        children: [
                          Icon(
                            FontAwesomeIcons.google, // TODO : not loading ?
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Sign in with Google",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                            ),
                          )
                        ],
                      )
                  ),
                  // Phone number SignIn
                  RoundedLoadingButton(
                      controller: googleButtonController,
                      onPressed: () {handleGoogleSignIn();},
                      successColor: Colors.red,
                      width: MediaQuery.of(context).size.width * 0.8,
                      elevation: 0,
                      borderRadius: 25,
                      color: Colors.red,
                      child: const Wrap(
                        children: [
                          Icon(
                            FontAwesomeIcons.google, // TODO : not loading ?
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Sign in with Google",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                            ),
                          )
                        ],
                      )
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }

  Future handleGoogleSignIn() async {
    // TODO : refactor to not use build context
    final signInProvider = context.read<SignInProvider>();
    final internetProvider = context.read<InternetProvider>();

    await internetProvider.checkInternetConnection();

    if (!internetProvider.hasInternet) {
      openSnackbar(
          context,
          "Check your Internet connection",
          Colors.red
      );
      googleButtonController.reset();
      return;
    }

    await signInProvider.signInWithGoogle().then((value) {
      if (signInProvider.hasError) {
        openSnackbar(context, signInProvider.errorCode.toString(), Colors.red);
        googleButtonController.reset();
      } else {
        signInProvider.checkUserExists().then((value) async {
          if (value) {
            await signInProvider.getUserDataFromFirestore(signInProvider.uuid).then((value) => signInProvider
                .saveUserDataToSharedPreferences()
                .then((value) => signInProvider.setSignIn().then((value) {
                  googleButtonController.success();
                  handleAfterSignIn();
                })
            ));
          } else {
            signInProvider.saveUserDataToFirestore().then((value) => signInProvider
                .saveUserDataToSharedPreferences()
                .then((value) => signInProvider.setSignIn().then((value) {
                  googleButtonController.success();
                  handleAfterSignIn();
                })
            ));
          }
        });
      }
    });
  }

  handleAfterSignIn() {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      nextScreen(context, const HomeScreen());
    });
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:one_hp/providers/internet_provider.dart';
import 'package:one_hp/screens/home_screen.dart';
import 'package:one_hp/screens/phoneauth_screen.dart';
import 'package:one_hp/utils/config.dart';
import 'package:one_hp/utils/next_screen.dart';
import 'package:one_hp/utils/snack_bar.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../providers/sign_in_provider.dart';
import '../theme/custom_color_scheme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final PhoneController phoneNumberController = PhoneController(null);
  final RoundedLoadingButtonController googleButtonController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController phoneSignInButtonController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController phoneSignUpButtonController = RoundedLoadingButtonController();
  final MobileScannerController mobileScannerController = MobileScannerController();
  final RoundedLoadingButtonController qrCodeButtonController = RoundedLoadingButtonController();
  final TextEditingController otpTEController = TextEditingController();

  final scannedCode = "";

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomColors>()!;

    phoneNumberController.value = PhoneNumber.parse(
        '6505551234',
        destinationCountry: IsoCode.US
    );

    return Scaffold(
      key: _scaffoldKey,
      //backgroundColor: Colors.amber, // TODO color
      body: SafeArea(
        //child: Expanded(
          child: Column(
            children: [
              // Account Connexion
              Expanded(
                child:
                  Container(
                    color: customTheme.interfaceColors.pink,
                    child: Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Connecte toi !",
                            style: TextStyle(
                                fontSize: customTheme.fontSize.title,
                                color: customTheme.interfaceColors.grey
                            ),
                          ),
                          const SizedBox(height: 50),
                          Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Phone
                                // TODO Style
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
                                  child: PhoneFormField(
                                    controller: phoneNumberController,
                                    textInputAction: TextInputAction.next,
                                    shouldFormat: true,
                                    countrySelectorNavigator: const CountrySelectorNavigator.dialog(),
                                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.phone),
                                      hintText: "650-555-1234",
                                      hintStyle: TextStyle(
                                          color: Colors.grey[600]
                                      ),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: Colors.red)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: Colors.grey)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: Colors.grey)
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Phone authentication
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40.0, 0, 12.0, 0),
                            child: Row(
                              children: [
                                // Phone number SignUp
                                Expanded(
                                    child: RoundedLoadingButton(
                                        controller: phoneSignUpButtonController,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Action impossible'),
                                                content: const Text(
                                                  "Pour cause d'affluence\nMerci de réessayer plus tard",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      letterSpacing: 1.0
                                                  ),
                                                ),
                                                actionsAlignment: MainAxisAlignment.center,
                                                actions: <Widget>[
                                                  OutlinedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                        return customTheme.interfaceColors.orange;
                                                      }),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text(
                                                      'OK',
                                                      style: TextStyle(
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          phoneSignUpButtonController.reset();
                                        },
                                        width: MediaQuery.of(context).size.width * 0.42,
                                        elevation: 0,
                                        borderRadius: 25,
                                        color: customTheme.interfaceColors.grey,
                                        child: Text(
                                          "Créer un compte",
                                          style: customTheme.buttonTheme.textStyle,
                                        )
                                    )
                                ),
                                // Phone number SignIn
                                Expanded(
                                    child: RoundedLoadingButton(
                                        controller: phoneSignInButtonController,
                                        onPressed: () {
                                          handlePhoneSignIn(phoneNumberController.value!);
                                          phoneSignInButtonController.reset();
                                        },
                                        successColor: Colors.red,
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        elevation: 0,
                                        borderRadius: 25,
                                        color: customTheme.interfaceColors.purple,
                                        child: Text(
                                          "Connexion",
                                          style: customTheme.buttonTheme.textStyle,
                                        )
                                    )
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Google SignIn
                          // TODO : bon logo google
                          RoundedLoadingButton(
                              controller: googleButtonController,
                              onPressed: () {
                                handleGoogleSignIn();
                              },
                              successColor: Colors.red,
                              width: MediaQuery.of(context).size.width * 0.65,
                              elevation: 0,
                              borderRadius: 25,
                              color: customTheme.interfaceColors.purple,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 5.0, color: const Color(0xFFFFFFFF)),
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const ClipOval(
                                      child: Image(
                                        image: AssetImage(Config.googleIco),
                                        height: 20,
                                        width: 20,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Connect toi avec Google",
                                    style: customTheme.buttonTheme.textStyle,
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              // Curve TOP
              Container(
                  color: customTheme.interfaceColors.grey,
                  child: ClipPath(
                    clipper: BottomLeftCornerClipper(),
                      child: Container(
                        width: double.infinity,
                        height: customTheme.backgroundCurveHeight,
                        color: customTheme.interfaceColors.pink,
                      )
                  )
              ),
              // Curve BOTTOM
              Container(
                color: customTheme.interfaceColors.pink,
                child: ClipPath(
                    clipper: TopRightCornerClipper(),
                    child: Container(
                      width: double.infinity,
                      height: customTheme.backgroundCurveHeight,
                      color: customTheme.interfaceColors.grey,
                    )
                ),
              ),
              // QRCode Connexion
              Expanded(
                  child: Container(
                    color: customTheme.interfaceColors.grey,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Scanne ton billet !",
                          style: TextStyle(
                              fontSize: customTheme.fontSize.title,
                              color: customTheme.interfaceColors.pink
                          ),
                        ),
                        const SizedBox(height: 60),
                        const Image(
                          image: AssetImage(Config.qrcodePlaceholder),
                          height: 180,
                          width: 180,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 40),
                        RoundedLoadingButton(
                            controller: qrCodeButtonController,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Action impossible'),
                                      content: const Text(
                                          'Votre appareil ne permet pas\ncette action\n',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            letterSpacing: 1.0
                                          ),
                                      ),
                                      actionsAlignment: MainAxisAlignment.center,
                                      actions: <Widget>[
                                        OutlinedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                                              return customTheme.interfaceColors.orange;
                                            }),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                              );
                              qrCodeButtonController.reset();
                            },
                            successColor: customTheme.interfaceColors.purple,
                            width: 220,
                            elevation: 0,
                            borderRadius: 25,
                            color: customTheme.interfaceColors.purple,
                            child: Text(
                              "Lancer le scan",
                              style: customTheme.buttonTheme.textStyle,
                            )
                        ),
                        //const SizedBox(height: 60),
                      ],
                    ),
                  )
              ),
            ],
          ),
        //)
      ),
    );
  }

  void _foundBarCode(BarcodeCapture barcodeCapture) {
    var barcode = barcodeCapture.barcodes[0];
      final String code = barcode.rawValue ?? "-";
      debugPrint('Barcode : $code');
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

    // TODO handle when user abort google auth
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

  Future handlePhoneSignIn(PhoneNumber mobile) async {
    final signInProvider = context.read<SignInProvider>();
    final internetProvider = context.read<InternetProvider>();
    await internetProvider.checkInternetConnection();

    if (!internetProvider.hasInternet ) {
      openSnackbar(
          context,
          "Check your internet connection",
          Colors.red
      );
      return;
    }

    // TODO valid number string
    if (!formKey.currentState!.validate()) return;

    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: mobile.international,
        verificationCompleted: (AuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException firebaseAuthException) {
          openSnackbar(
              context,
              firebaseAuthException.toString(),
              Colors.red
          );
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Code reçu par SMS"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Validation for +${mobile.countryCode} ${mobile.getFormattedNsn()}"),
                      const Text(
                        "(Try code is 123456)",
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                      const SizedBox(height: 10),
                      // TODO : rename app in otp sms body ?
                      TextField(
                        controller: otpTEController,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.code),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.grey)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.grey)
                            )
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final code = otpTEController.text.trim();

                          AuthCredential authCredential = PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: code
                          );

                          User user = (await FirebaseAuth.instance.signInWithCredential(authCredential)).user!;

                          // save the values
                          // TODO
                          signInProvider.phoneNumberUser(user, "", "");
                          // checking whether user exists,
                          signInProvider.checkUserExists().then((value) async {
                            if (value) {
                              // user exists
                              await signInProvider.getUserDataFromFirestore(signInProvider.uuid).then((value) =>
                                  signInProvider
                                      .saveUserDataToSharedPreferences()
                                      .then((value) =>
                                      signInProvider.setSignIn().then((value) {
                                        nextScreenReplace(context, const HomeScreen());
                                      })
                                  )
                              );
                            } else {
                              // user does not exist
                              /* TODO : erreur pas de user
                              await signInProvider.saveUserDataToFirestore().then((value) => signInProvider
                                  .saveUserDataToSharedPreferences().then((value) =>
                                  signInProvider
                                      .setSignIn().then((value) {
                                    nextScreenReplace(context, const HomeScreen());
                                  })
                              )$/
                              );*/
                            }
                          });
                        },
                        child: const Text("Confirm"),
                      )
                    ],
                  ),
                );
              });
        },
        codeAutoRetrievalTimeout: (String verification) {});
  }

  handleAfterSignIn() {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      nextScreen(context, const HomeScreen());
    });
  }
}

class BottomLeftCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double degToRad(num deg) => deg * (3.14159265359 / 180.0);

    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.height, size.height);
    path.arcTo(
        Rect.fromLTWH(
            0, -size.height,
            size.height*2, size.height*2
        ),
        degToRad(90),
        degToRad(90),
        true
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopRightCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double degToRad(num deg) => deg * (3.14159265359 / 180.0);

    var path = Path();
    path.lineTo(size.width-size.height, 0);
    path.arcTo(
        Rect.fromLTWH(
            size.width-(size.height*2), 0,
            (size.height*2), (size.height*2)
        ),
        degToRad(270),
        degToRad(90),
        true
    );
    path.lineTo(0, size.height);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
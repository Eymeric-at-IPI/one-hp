import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_hp/screens/login_screen.dart';
import 'package:one_hp/utils/next_screen.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';

import '../providers/internet_provider.dart';
import '../providers/sign_in_provider.dart';
import '../utils/config.dart';
import '../utils/snack_bar.dart';
import 'home_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final formKey = GlobalKey<FormState>();

  // TODO : number only ? Set fr
  PhoneController phoneNumberTEController = PhoneController(null); //TextEditingController();
  TextEditingController emailTEController = TextEditingController();
  TextEditingController nameTEController = TextEditingController();
  TextEditingController otpTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              nextScreenReplace(context, const LoginScreen());
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage(Config.appIcon),
                  height: 50,
                  width: 50,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Phone Login",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                // Name
                TextFormField(
                  validator: (value) {
                    // TODO : attention a !
                    return (value!.isEmpty)
                        ? "Name cannot be empty"
                        : null;
                  },
                  controller: nameTEController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.account_circle),
                    hintText: "Alian DUPONT",
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
                const SizedBox(height: 20),
                // Email
                TextFormField(
                  validator: (value) {
                    // TODO : attention a !
                    // TODO : security
                    return (value!.isEmpty)
                      ? "Email cannot be empty"
                      : null;
                  },
                  controller: emailTEController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: "Alian.DUPONT@gmail.com",
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
                const SizedBox(height: 20),
                // Phone
                PhoneFormField(
                  controller: phoneNumberTEController,
                  textInputAction: TextInputAction.next,
                  shouldFormat: true,
                  countrySelectorNavigator: const CountrySelectorNavigator.bottomSheet(),
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    hintText: "6 XX XX XX XX",
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
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      login(context, phoneNumberTEController.value!);
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Register")
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  Future login(BuildContext context, PhoneNumber mobile) async {
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



    print("Tel : $mobile");
    print("Tel getFormattedNsn : ${mobile.getFormattedNsn()}");
    print("Tel nsm : ${mobile.nsn}");
    print("Tel countryCode : ${mobile.countryCode}");
    print("Tel international : ${mobile.international}");
    print("Tel isoCode : ${mobile.isoCode}");

    final formattedPhoneNumber = "";
    //print("Tel : $mobile${formattedPhoneNumber.startsWith("+") ? " : start with +" : " -"}");
    //print("Tel : $mobile${formattedPhoneNumber.startsWith(RegExp(r'\d')) ? " : start with number" : " -"}");
    // TODO : if start with number : match \d\d\d\d\d\d\d\d\d\d ( put spacce on edit )
    // TODO : if start with + : match +\d\d\d\d\d\d\d\d\d\d\d ( put spacce on edit )

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
                  title: const Text("Enter Code"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Validation for +${mobile.countryCode} ${mobile.getFormattedNsn()}"),
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
                          signInProvider.phoneNumberUser(user, emailTEController.text, nameTEController.text);
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
                              await signInProvider.saveUserDataToFirestore().then((value) => signInProvider
                                  .saveUserDataToSharedPreferences().then((value) =>
                                    signInProvider
                                        .setSignIn().then((value) {
                                          nextScreenReplace(context, const HomeScreen());
                                        })
                                  )
                              );
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

}
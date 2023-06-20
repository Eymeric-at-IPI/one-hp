import 'package:flutter/material.dart';
import 'package:one_hp/providers/sign_in_provider.dart';
import 'package:one_hp/screens/login_screen.dart';
import 'package:one_hp/utils/next_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future getData() async {
    final signInProvider = context.read<SignInProvider>();
    signInProvider.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final signInProvider = context.read<SignInProvider>();
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage("${signInProvider.imageUrl}"),
              radius: 50,
            ),
            const SizedBox(height: 20),
            Text(
              "Welcome ${signInProvider.name}",
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${signInProvider.email}",
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${signInProvider.uuid}",
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Provider"
                ),
                const SizedBox(width: 5),
                Text(
                  "${signInProvider.provider}".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  signInProvider.userSignOut();
                  nextScreenReplace(context, const LoginScreen());
                },
                child: const Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white),
                )
            )
          ]
        )
      ),
    );
  }
}
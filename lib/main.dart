import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:shoppinglist/services/auth_service.dart';
import 'package:shoppinglist/ui/pages/home_page.dart';
import 'package:shoppinglist/ui/pages/login_page.dart';
import 'package:shoppinglist/ui/pages/unknown_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initialRoute = await AuthService.defineInitRoutePath();
  runApp(const MyApp());
}

var initialRoute = '/';

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> _authStateChange;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    _authStateChange =
        FirebaseAuth.instance.authStateChanges().listen((snapshot) {
      SchedulerBinding.instance!.addPostFrameCallback(
        (_) => _navigatorKey.currentState!.pushNamedAndRemoveUntil(
          snapshot != null ? HomePage.routeName : LoginPage.routeName,
          (route) => false,
        ),
      );
    });
  }

  @override
  void dispose() {
    _authStateChange.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case LoginPage.routeName:
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const LoginPage(),
            );
          case HomePage.routeName:
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  const HomePage(title: 'Shopping List'),
            );
          default:
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const UnknownPage(),
            );
        }
      },
      // routes: {
      //   CreateAccountPage.routeName: (context) => const CreateAccountPage(),
      //   LoginPage.routeName: (context) => const LoginPage(),
      //   HomePage.routeName: (context) => const HomePage(title: 'Shopping List'),
      // },
    );
  }
}

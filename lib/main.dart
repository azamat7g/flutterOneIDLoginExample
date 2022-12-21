import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String code = "??";

  String generateRandomString(int length) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  void startAuth() async {
    const clientID = __CLIENTID__;
    var state = generateRandomString(32);

    final url = Uri.https('sso.egov.uz', '/sso/oauth/Authorization.do', {
      'client_id': clientID,
      'response_type': 'one_code',
      'redirect_uri': "com.example.app://auth",
      'state': state,
      'scope': clientID,
    });

    final result = await FlutterWebAuth.authenticate(url: url.toString(), callbackUrlScheme: "com.example.app");

    setState(() => code = Uri.parse(result).queryParameters['code'] ?? "not found");

    /*** !!!! After that send CODE and STATE params to API for get user data !!!! ***/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("oAuth2 demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Code is: $code",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            TextButton(onPressed: startAuth, child: const Text("Login with OneID"))
          ],
        ),
      ),
    );
  }
}

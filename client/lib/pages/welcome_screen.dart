import 'package:client/pages/report_incident_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen_2.dart';
import 'SOS_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome Page"),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage())),
                    child: const Text("Login"))),
            Center(
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage2())),
                    child: const Text("Register"))),
            Center(
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SOSpage())),
                    child: const Text("SOS Page (Test)"))),
            Center(
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReportScreen())),
                    child: const Text("To Report Screen (Test)")))
          ],
        ));
  }
}
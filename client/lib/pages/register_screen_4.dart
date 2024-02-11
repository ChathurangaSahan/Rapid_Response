import 'package:flutter/material.dart';

class RegisterPage4 extends StatefulWidget {
  const RegisterPage4({super.key});

  @override
  State<RegisterPage4> createState() => _RegisterScreen4State();
}

class _RegisterScreen4State extends State<RegisterPage4> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          Text("Register"),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(
              Icons.person,
              size: 32,
            ),
          )
        ]),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                  labelText: "Select your username",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                  labelText: "Select a password",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextFormField(
              controller: _repasswordController,
              decoration: const InputDecoration(
                  labelText: "Re-enter password",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always)),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
            onPressed: () {
              print(_usernameController.text);
              print(_passwordController.text);
            },
            child: const Text("Register"))
      ]),
    );
  }
}

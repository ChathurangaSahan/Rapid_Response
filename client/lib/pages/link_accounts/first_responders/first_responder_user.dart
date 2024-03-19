import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:client/pages/utils/alert_dialogs.dart';

class AddUserPage extends StatefulWidget {
  final dynamic _user;
  const AddUserPage(this._user, {super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  dynamic _accessToken;
  dynamic _idToken;
  String? _profilePicUrl;
  bool _alreadySupervisee = false;
  bool _requestAlreadySent = false;

  recieveAccessToken() async {
    _accessToken = await UserSecureStorage.getAccessToken();
    final idToken = await UserSecureStorage.getIdToken();
    _idToken = JwtDecoder.decode(idToken!);
  }

  getProfilePicUrl() async {
    try {
      var response = await http.get(
          Uri.parse(
              "http://10.0.2.2:3000/api/profile-pic/profile-pic-url/${widget._user["_id"]}"),
          headers: {
            'Content-Type': 'application/json',
            if (_accessToken != null) 'x-auth-token': _accessToken,
          });
      if (response.statusCode == 200) {
        setState(() {
          _profilePicUrl = response.body;
        });
      } else if (response.statusCode == 404) {}
    } catch (error) {
      print("Error: $error");
    }
  }

  isSupervisee() async {
    try {
      var response = await http.get(
          Uri.parse(
              "http://10.0.2.2:3000/api/linked-accounts/supervisee/${widget._user["_id"]}"),
          headers: {
            'Content-Type': 'application/json',
            if (_accessToken != null) 'x-auth-token': _accessToken,
          });
      if (response.statusCode == 200) {
        setState(() {
          _alreadySupervisee = true;
        });
      } else if (response.statusCode == 404) {}
    } catch (error) {
      print("Error: $error");
    }
  }

  isRequestSent() async {
    try {
      var response = await http.get(
          Uri.parse(
              "http://10.0.2.2:3000/api/notification/search/request/${widget._user["_id"]}?type=supervisee-request"),
          headers: {
            'Content-Type': 'application/json',
            if (_accessToken != null) 'x-auth-token': _accessToken,
          });
      if (response.statusCode == 200) {
        _requestAlreadySent = true;
      } else if (response.statusCode == 404) {
        _requestAlreadySent = false;
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  sendRequest() async {
    try {
      var response = await http.post(
          Uri.parse("http://10.0.2.2:3000/api/notification/send"),
          headers: {
            'Content-Type': 'application/json',
            if (_accessToken != null) 'x-auth-token': _accessToken
          },
          body: jsonEncode({
            "from": _idToken["id"],
            "to": widget._user["_id"],
            "type": "supervisee-request",
            "title": "Add Supervisee Request",
            "body":
                "${_idToken["firstName"]} ${_idToken["lastName"]} sent add as supervisee request",
          }));
      if (response.statusCode == 200) {
        print("Notification send successfully");
        showNotificationSuccessDialog(
            widget._user["firstName"], widget._user["lastName"]);
      } else if (response.statusCode == 202) {
        print("Notification saved successfully. But no FCM token found");
        showNotificationSuccessDialog(
            widget._user["firstName"], widget._user["lastName"]);
      } else {
        print(response.statusCode);
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  void showRequestAlreadySentDialog() {
    showAlertDialog(
        context,
        "Request Already Sent",
        "A request has already been sent to this user, is currently pending",
        const Icon(
          Icons.warning_rounded,
          color: Colors.orange,
          size: 40,
        ));
  }

  showNotificationSuccessDialog(String firstName, String lastName) {
    showAlertDialog(
        context,
        "Request Sent Successfully",
        "Emergency contact request has been sent to $firstName $lastName",
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 40,
        ));
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  initializeData() async {
    await recieveAccessToken();
    isSupervisee();
    getProfilePicUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      appBar: AppBar(
        // title: Text(widget._user["firstName"] + " " + widget._user["lastName"]),
        title: const Row(
          children: [
            Text("Add as Supervisee"),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.people, size: 30),
            )
          ],
        ),
        backgroundColor: const Color(0xFFadd8e6),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircleAvatar(
              backgroundImage: NetworkImage(_profilePicUrl ??
                  "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png"),
              radius: 70,
            ),
            const SizedBox(height: 20),
            Text(
              widget._user["firstName"] + " " + widget._user["lastName"],
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(widget._user["username"]),
            const SizedBox(height: 40),
            _alreadySupervisee
                ? const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Card(
                      color: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("Supervisee!",
                            style:
                                TextStyle(fontSize: 24, color: Colors.white)),
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      await (isRequestSent());
                      if (_requestAlreadySent) {
                        return showRequestAlreadySentDialog();
                      }
                      await sendRequest();
                    },
                    child: const Text("Send Request"),
                  ),
            const SizedBox(height: 8),
            if (!_alreadySupervisee)
              ElevatedButton(onPressed: () {}, child: const Text("Cancel"))
          ]),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            label: "Link",
            icon: Icon(Icons.link),
          ),
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
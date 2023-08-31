import 'package:flutter/material.dart';
import 'package:neighborhood_management_software/Widgets/apptext.dart';
import 'package:neighborhood_management_software/Widgets/custominputfield.dart';
import 'package:neighborhood_management_software/Widgets/passwordinputfield.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formkey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  String _useremail = "abc@123.com";
  String _userpassword = "qwe";

  String _email = "";
  String _password = "";

  void signin() {
    if (_email == _useremail && _password == _userpassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          'Login Successful',
          style: TextStyle(
            color: Color.fromARGB(255, 5, 230, 12),
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: Duration(seconds: 2),
      ));
      Navigator.pushNamed(context, "/uploadimage");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          'Invalid Email or Password',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: AppLargeText(
          text: "Neighborhood Management Software",
          color: Colors.white,
          size: 25,
        ),
        centerTitle: true,
        toolbarHeight: 74,
        toolbarOpacity: 0.8,
        shadowColor: Colors.blueGrey,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(28),
          bottomLeft: Radius.circular(28),
        )),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(28),
              bottomLeft: Radius.circular(28),
            ),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blueAccent,
                  Colors.blueGrey,
                ]),
          ),
        ),
      ),
      body: Stack(fit: StackFit.expand, children: [
        Image.asset(
          "assets/map3.jpg",
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          color: Colors.black.withOpacity(0.7),
          colorBlendMode: BlendMode.darken,
        ),
        Center(
            child: Container(
          height: screenHeight * 0.55,
          width: screenWidth * 0.4,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    AppLargeText(
                      text: "User Login",
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    CustomInputField(
                        hint: "Enter Your Email", controller: _emailcontroller),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    PasswordInputField(
                        hint: "Enter Your Password",
                        passwordcontroller: _passwordcontroller),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
                    custombutton("Login"),
                  ],
                ),
              ),
            ),
          ),
        )),
      ]),
    );
  }

  Widget custombutton(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_formkey.currentState?.validate() ?? false) {
            _email = _emailcontroller.text;
            _password = _passwordcontroller.text;
          }
          signin();
        });
        signin();
      },
      child: Container(
        // GestureDetector(),
        margin: EdgeInsets.only(bottom: 25),
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.blueAccent, Colors.blueGrey]),
            borderRadius: BorderRadius.all(Radius.circular(42))),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.2),
          ),
        ),
      ),
    );
  }
}

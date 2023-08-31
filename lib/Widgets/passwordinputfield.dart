import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  String hint;
  TextEditingController passwordcontroller;
  PasswordInputField({
    super.key,
    required this.hint,
    required this.passwordcontroller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      margin: EdgeInsets.only(),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Icon(Icons.lock),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 5),
            child: TextFormField(
                obscureText: true,
                controller: passwordcontroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.blueGrey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  hintText: hint,
                ),
                validator: (value) {
                  if (value == null) {
                    return "Please Enter Password";
                  }
                  return null;
                }),
          )),
        ],
      ),
    );
  }
}

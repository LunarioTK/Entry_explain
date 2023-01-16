import 'package:entry_explain/constants/uicolor.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController userMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uiColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
            child: TextField(
              controller: userMessage,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Insert question',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

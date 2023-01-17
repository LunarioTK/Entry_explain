import 'package:entry_explain/constants/fonts.dart';
import 'package:entry_explain/constants/uicolor.dart';
import 'package:entry_explain/services/openai_api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController userMessage = TextEditingController();
  FocusNode myfocus = FocusNode();
  //bool isClicked = false;

  void getResponse(String userQuest) async {
    APIKey apiKey = APIKey();
    String apiUrl = "https://api.openai.com/v1/completions";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${apiKey.getApiKey}"
    };

    Map<String, dynamic> body = {
      "prompt": userQuest,
      "model": "text-davinci-002",
      "max_tokens": 100,
    };

    var response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data["choices"][0]["text"]);
    } else {
      print("Erro: ${response.statusCode}");
    }
  }

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
              focusNode: myfocus,
              style: TextStyle(
                color: Colors.white,
                fontFamily: mainFont,
              ),
              decoration: InputDecoration(
                hintText: 'Insert question',
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: mainFont,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              getResponse(userMessage.text);
              myfocus.unfocus();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonsColor,
              elevation: 10,
            ),
            child: Text(
              'Send',
              style: TextStyle(
                fontFamily: mainFont,
              ),
            ),
          )
        ],
      ),
    );
  }
}

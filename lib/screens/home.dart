import 'package:entry_explain/constants/fonts.dart';
import 'package:entry_explain/constants/uicolor.dart';
import 'package:entry_explain/services/openai_api.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

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
  String? chatResponse;
  //bool isClicked = false;

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    void getResponse(String userQuest) async {
      APIKey apiKey = APIKey();
      String apiUrl = "https://api.openai.com/v1/completions";
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": "Bearer ${apiKey.getApiKey}"
      };

      Map<String, dynamic> body = {
        "prompt":
            'Explica-me este texto o mais resumido possivel "$userQuest", em português',
        "model": "text-davinci-002",
        "max_tokens": 100,
      };

      var response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: json.encode(body));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          chatResponse = (data["choices"][0]["text"]);
          print((data["choices"][0]["text"]));
        });
      } else {
        setState(() {
          chatResponse = ("Erro: ${response.statusCode}");
          print(("Erro: ${response.statusCode}"));
        });
      }
    }

    Future<String> generatePDF() async {
      //Load an existing PDF document.
      PdfDocument document = PdfDocument(
          inputBytes:
              await _readDocumentData('Carta de Apresentação Team.It.pdf'));

      //Create a new instance of the PdfTextExtractor.
      PdfTextExtractor extractor = PdfTextExtractor(document);

      //Extract all the text from the document.
      String text = extractor.extractText();

      getResponse(text);

      return text;
    }

    return Scaffold(
      backgroundColor: uiColor,
      body: Column(
        children: [
          // Show Chat message
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
            child: Container(
              decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: ListTile(
                shape: const StadiumBorder(),
                title: Text(
                  chatResponse == null
                      ? 'What do you want explained'
                      : '$chatResponse',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: CircleAvatar(
                  child: Image.asset('assets/chatgpt.png'),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              setState(() {
                generatePDF();
              });
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
          ),
        ],
      ),
    );
  }
}

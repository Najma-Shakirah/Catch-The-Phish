import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const CatchThePhishApp());
}

class CatchThePhishApp extends StatelessWidget {
  const CatchThePhishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      title: "CatchThePhish",
      home: const CatchTheFish(),
    );
  }
}

class CatchTheFish extends StatefulWidget {
  const CatchTheFish({super.key});

  @override
  State<CatchTheFish> createState() => _CatchTheFishState();
}

class _CatchTheFishState extends State<CatchTheFish> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<String> _predictPhishing(String emailContent) async {
    const String endpoint =
        'https://api-inference.huggingface.co/models/cybersectony/phishing-email-detection-distilbert_v2.4.1';
    const String token = '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';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': emailContent,
        }),
      );

      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Decoded data: $data');

        if (data.isEmpty) {
          throw Exception('Empty response from API');
        }

        final List<dynamic> predictions = data[0];
        print('Predictions: $predictions');

        var highestScore = 0.0;
        var mostLikelyLabel = '';

        for (var prediction in predictions) {
          final double score = prediction['score'];
          final String label = prediction['label'];
          if (score > highestScore) {
            highestScore = score;
            mostLikelyLabel = label;
          }
        }

        print('Most likely label: $mostLikelyLabel with score: $highestScore');

        // LABEL_0 = legitimate email
        // LABEL_1 = phishing email
        if (mostLikelyLabel == "LABEL_0") {
          return 'not phishing';
        } else {
          return 'phishing';
        }
      } else {
        print('API Error Response: ${response.body}');
        throw Exception('Failed to get prediction: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in prediction: $e');
      throw Exception('Error processing request: $e');
    }
  }

  static const _gradients = [
    [Color(0xFFFEE440), Color(0xFFFEE440)],
    [Color(0xFF00BBF9), Color(0xFF00BBF9)],
  ];

  static const _durations = [
    5000,
    4000,
  ];

  static const _heightPercentages = [
    0.65,
    0.66,
  ];

  void _showAlertDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: result == 'phishing' ? Colors.red : Colors.green,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        result == 'phishing'
                            ? 'assets/warning_icon.svg'
                            : 'assets/safe_icon.svg',
                        height: 200,
                        width: 200,
                      ),
                      Text(
                        result == 'phishing'
                            ? 'Caught a Phish!'
                            : 'No Fishy Business!',
                        style: GoogleFonts.fredoka(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        result == 'phishing'
                            ? 'This appears to be a phishing email!'
                            : 'This email appears to be legitimate.',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        result == 'phishing'
                            ? 'Recommendation: Delete this email!'
                            : 'Recommendation: Safe to proceed',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              result == 'phishing' ? Colors.red : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: result == 'phishing'
                                  ? Colors.red
                                  : Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(result == 'phishing'
                                ? 'Got it, Stay Safe!'
                                : 'Understood'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WaveWidget(
            config: CustomConfig(
              gradients: _gradients,
              durations: _durations,
              heightPercentages: _heightPercentages,
            ),
            backgroundColor: const Color.fromARGB(255, 96, 250, 255),
            size: const Size(double.infinity, double.infinity),
            waveAmplitude: 20,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Phishing Email Detector",
                  style: GoogleFonts.fredoka(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 0, 80, 138),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Stack(
                        children: [
                          Text(
                            "Catch the Phish Before It Catches You!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(
                              textStyle: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Text(
                            "Catch the Phish Before It Catches You!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                  child: TextField(
                    controller: _emailController,
                    maxLines: 5,
                    minLines: 3,
                    decoration: InputDecoration(
                      hintText: "Paste your email content here...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          try {
                            String result =
                                await _predictPhishing(_emailController.text);
                            _showAlertDialog(context, result);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        },
                        backgroundColor: Colors.blue,
                        shape: const CircleBorder(
                            side: BorderSide(color: Colors.black, width: 1)),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Icon(Icons.phishing, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

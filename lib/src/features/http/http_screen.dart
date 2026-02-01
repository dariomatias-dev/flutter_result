import 'package:flutter/material.dart';

import 'package:flutter_result/src/features/http/http_controller.dart';
import 'package:flutter_result/src/features/http/status_codes.dart';

class HttpScreen extends StatefulWidget {
  const HttpScreen({super.key});

  @override
  State<HttpScreen> createState() => _HttpScreenState();
}

class _HttpScreenState extends State<HttpScreen> {
  final _controller = HttpController();

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Status Code:',
                ),
                const SizedBox(width: 8.0),
                DropdownButton(
                  value: _controller.statusCode,
                  items: List.generate(
                    statusCodes.length,
                    (index) {
                      final statusCode = statusCodes[index];

                      return DropdownMenuItem(
                        value: statusCode,
                        child: Text('$statusCode'),
                      );
                    },
                  ),
                  onChanged: (value) {
                    setState(() {
                      _controller.statusCode = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () {
                _controller.request(context);
              },
              child: const Text('Request'),
            ),
          ],
        ),
      ),
    );
  }
}

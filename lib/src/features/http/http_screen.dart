import 'package:flutter/material.dart';

import 'package:flutter_result/src/features/http/http_controller.dart';
import 'package:flutter_result/src/features/http/status_codes.dart';

class HttpScreen extends StatefulWidget {
  const HttpScreen({super.key, HttpController? controller})
      : _controller = controller;

  final HttpController? _controller;

  @override
  State<HttpScreen> createState() => _HttpScreenState();
}

class _HttpScreenState extends State<HttpScreen> {
  late HttpController _controller;
  int _statusCode = statusCodes.first;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = widget._controller ?? HttpController();
  }

  @override
  void didUpdateWidget(HttpScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._controller != oldWidget._controller) {
      _controller = widget._controller ?? HttpController();
    }
  }

  Future<void> _handleRequest(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    await _controller.request(context, _statusCode);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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
                const SizedBox(width: 8),
                DropdownButton(
                  value: _statusCode,
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
                      _statusCode = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _handleRequest(context),
              child: const Text('Request'),
            ),
          ],
        ),
      ),
    );
  }
}

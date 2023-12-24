import 'dart:async';
import 'dart:math';

import 'package:animate_number/animate_number.dart';
import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late final ValueNotifier<int> _numberNotifier;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _numberNotifier = ValueNotifier(0);
    _randomNumber();
  }

  void _randomNumber() {
    final random = Random();
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        _numberNotifier.value = 100 + random.nextInt(899);
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _numberNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: SizedBox.expand(
        child: Center(
          child: AnimateNumber(
            number: _numberNotifier,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

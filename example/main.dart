import 'dart:async';
import 'dart:math';

import 'package:animate_number/animate_number.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnimateNumberPage extends StatefulWidget {
  const AnimateNumberPage({super.key});

  @override
  State<AnimateNumberPage> createState() => _AnimateNumberPageState();
}

class _AnimateNumberPageState extends State<AnimateNumberPage> {
  late final ValueNotifier<num> _numberNotifier;
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
        _numberNotifier.value = (1000 + random.nextInt(8999)).toDouble();
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimateNumber(
                number: _numberNotifier,
                numberFormat: NumberFormat("###,###.###"),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'watching',
                style: TextStyle(
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

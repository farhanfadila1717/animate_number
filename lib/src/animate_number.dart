import 'package:flutter/material.dart';

import 'digit_animation.dart';

/// {@template animate_number}
/// A widget that animates the individual digits of a number when it changes.
///
/// It listens to a [ValueNotifier<int>] and creates a separate [DigitAnimation]
/// widget for each digit of the number. This allows for smooth transitions
/// between different number values.
///
/// The animation duration for each digit can be customized using the
/// [digitDuration] property.
///
/// {@endtemplate}
class AnimateNumber extends StatelessWidget {
  /// Creates an AnimateNumber widget.
  ///
  /// Must provide:
  ///
  /// * [number]: A [ValueNotifier<int>] that holds the current number value.
  ///
  /// Optional properties:
  ///
  /// * [style]: The [TextStyle] to apply to the digits.
  /// * [digitDuration]: The duration for each digit's animation.
  const AnimateNumber({
    super.key,
    required this.number,
    this.style,
    this.digitDuration,
  });

  /// The [ValueNotifier<int>] that holds the current number value.
  final ValueNotifier<int> number;

  /// The [TextStyle] to apply to the digits.
  final TextStyle? style;

  /// {@macro digit_duration}
  final Duration? digitDuration;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: number,
      builder: (_, value, __) {
        final valueInString = value.toString();
        final digitCount = value.toString().length;

        return Wrap(
          children: List.generate(
            digitCount,
            (index) => DigitAnimation(
              value: int.parse(valueInString[index]),
              style: style,
              digitDuration: digitDuration,
            ),
          ),
        );
      },
    );
  }
}

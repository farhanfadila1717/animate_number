import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    this.numberFormat,
  });

  /// The [ValueNotifier<num>] that holds the current number value.
  final ValueNotifier<num> number;

  /// The [TextStyle] to apply to the digits.
  final TextStyle? style;

  /// {@macro digit_duration}
  final Duration? digitDuration;

  ///
  final NumberFormat? numberFormat;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: number,
      builder: (_, value, __) {
        var valueInString = value.toString();

        if (numberFormat != null) {
          valueInString = numberFormat!.format(value);
        }

        var itemCount = valueInString.length;

        return Wrap(
          children: List.generate(
            itemCount,
            (index) {
              final item = valueInString[index];

              if (!item.isNumber) {
                return Text(item, style: style);
              }

              return DigitAnimation(
                number: value,
                value: int.parse(valueInString[index]),
                style: style,
                digitDuration: digitDuration,
              );
            },
          ),
        );
      },
    );
  }
}

extension on String {
  bool get isNumber {
    final parsedNumber = int.tryParse(this);

    return parsedNumber != null;
  }
}

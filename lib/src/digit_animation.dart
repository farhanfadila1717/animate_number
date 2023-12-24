import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/widgets.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

/// {@template digit_animation}
/// The DigitAnimation is widget for animation each digit
/// {@endtemplate}
class DigitAnimation extends StatefulWidget {
  const DigitAnimation({
    super.key,
    required this.value,
    this.style,
    this.digitDuration,
  });

  /// The current digit value
  final int value;

  /// The text style of digit
  final TextStyle? style;

  /// {@template digit_duration}
  /// The animation duration is determined based on the number of steps
  /// required for the transition. Each step represents a change in the
  /// displayed digit.
  ///
  /// Example:
  /// If the current digit is 1 and the next digit is 5, there are 4 steps
  /// involved in the animation (1 -> 2 -> 3 -> 4 -> 5).
  ///
  /// If you specify a duration of `Duration(milliseconds: 100)` for each step,
  /// the total animation duration will be calculated as follows:
  ///
  /// ```dart
  /// final animationDuration = Duration(milliseconds: 100) * numberOfSteps;
  /// ```
  ///
  /// In this example, the final animation duration would be `Duration(milliseconds: 400)`.
  /// {@endtemplate}
  final Duration? digitDuration;

  @override
  State<DigitAnimation> createState() => _DigitAnimationState();
}

class _DigitAnimationState extends State<DigitAnimation>
    with SingleTickerProviderStateMixin, AfterLayoutMixin {
  int _currentIndex = 0;
  late final AutoScrollController _autoScrollController;

  @override
  void initState() {
    super.initState();
    _autoScrollController = AutoScrollController();
  }

  @override
  void didUpdateWidget(covariant DigitAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (displayedNumber == widget.value) return;
    navigateToIndex(widget.value);
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    navigateToIndex(widget.value);
  }

  int get displayedNumber => _currentIndex % 10;

  void navigateToIndex(int index) {
    if (_autoScrollController.isAutoScrolling) return;

    var diffrence = _currentIndex - index;

    if (diffrence.isNegative) {
      diffrence *= -1;
    }

    final duration = widget.digitDuration ?? const Duration(milliseconds: 200);

    _autoScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: Duration(
        milliseconds:
            max(duration.inMilliseconds, duration.inMilliseconds * diffrence),
      ),
    );
    _currentIndex = index;
  }

  Size get size {
    final painter = TextPainter(
      text: TextSpan(
        text: '0',
        style: widget.style,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: double.infinity,
      );

    return painter.size;
  }

  @override
  void dispose() {
    _autoScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              controller: _autoScrollController,
              itemCount: 10,
              itemBuilder: (context, index) => AutoScrollTag(
                index: index,
                controller: _autoScrollController,
                key: ValueKey(index),
                child: Text(
                  '$index',
                  style: widget.style,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

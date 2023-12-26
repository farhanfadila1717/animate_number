import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

/// DigitSlideState
enum DigitSlideState {
  none,
  iddle,
}

/// {@template digit_animation}
/// The DigitAnimation is widget for animation each digit
/// {@endtemplate}
class DigitAnimation extends StatefulWidget {
  const DigitAnimation({
    super.key,
    required this.number,
    required this.value,
    this.style,
    this.digitDuration,
  });

  /// The real number
  final int number;

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
  late int _number;
  late final AutoScrollController _autoScrollController;
  late final ValueNotifier<DigitSlideState> _digitSlideState;

  @override
  void initState() {
    super.initState();
    _autoScrollController = AutoScrollController();
    _digitSlideState = ValueNotifier(DigitSlideState.none);
    _number = widget.number;
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

  Future<void> navigateToIndex(int index) async {
    if (_autoScrollController.isAutoScrolling) return;

    var diffrence = _currentIndex - index;
    var isUp = widget.number > _number;

    if (diffrence.isNegative) {
      diffrence *= -1;
    }

    final duration = widget.digitDuration ?? const Duration(milliseconds: 200);
    final destinationIndex = isUp ? index + 10 : index;

    _currentIndex = index;
    _number = widget.number;

    await _autoScrollController.scrollToIndex(
      destinationIndex,
      preferPosition: AutoScrollPosition.begin,
      duration: Duration(
        milliseconds:
            max(duration.inMilliseconds, duration.inMilliseconds * diffrence),
      ),
    );
    navigateToIddle(index);
  }

  /// Reset digit to center
  Future<void> navigateToIddle(int index) async {
    _digitSlideState.value = DigitSlideState.iddle;
    await _autoScrollController.scrollToIndex(
      index + 10,
      duration: const Duration(microseconds: 1),
      preferPosition: AutoScrollPosition.begin,
    );
    if (!mounted) return;
    _digitSlideState.value = DigitSlideState.none;
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
    _digitSlideState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: ValueListenableBuilder(
          valueListenable: _digitSlideState,
          builder: (_, slideState, __) {
            return Stack(
              children: [
                Opacity(
                  opacity: slideState == DigitSlideState.iddle ? 0.0 : 1.0,
                  child: ColoredBox(
                    color: Colors.amber,
                    child: ListView.builder(
                      controller: _autoScrollController,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: 30,
                      itemBuilder: (context, index) => AutoScrollTag(
                        index: index,
                        controller: _autoScrollController,
                        key: ValueKey(index),
                        child: Text(
                          '${index % 10}',
                          style: widget.style,
                        ),
                      ),
                    ),
                  ),
                ),
                if (slideState == DigitSlideState.iddle)
                  Text(
                    '$displayedNumber',
                    style: widget.style,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum ToggleMode { animating, dragged, none }

typedef CustomWrapperBuilder<T> = Widget Function(BuildContext context, GlobalToggleProperties<T> global, Widget child);

typedef CustomIconBuilder<T> = Widget Function(
    BuildContext context, LocalToggleProperties<T> local, DetailedGlobalToggleProperties<T> global);
typedef CustomSeparatorBuilder<T> = Widget Function(
    BuildContext context, SeparatorProperties<T> local, DetailedGlobalToggleProperties<T> global);

typedef CustomIndicatorBuilder<T> = Widget Function(BuildContext context, DetailedGlobalToggleProperties<T> global);

typedef IndicatorAppearingBuilder = Widget Function(BuildContext context, double value, Widget indicator);

typedef ChangeCallback<T> = FutureOr<void> Function(T value);

typedef TapCallback<T> = FutureOr<void> Function(TapProperties<T> props);
typedef PositionListener<T> = void Function(PositionListenerInfo<T> position);

enum FittingMode { none, preventHorizontalOverlapping }

enum IconArrangement {
  row,
  overlap,
}

class TapProperties<T> {
  final TapInfo<T>? tapped;
  final List<T> values;

  const TapProperties({
    required this.tapped,
    required this.values,
  });
}

class TapInfo<T> extends TogglePosition<T> {
  TapInfo({
    required super.value,
    required super.index,
    required super.position,
  });

  TapInfo._fromPosition(TogglePosition<T> position)
      : this(
          value: position.value,
          index: position.index,
          position: position.position,
        );
}

class PositionListenerInfo<T> extends TogglePosition<T> {
  final ToggleMode mode;

  PositionListenerInfo({
    required super.value,
    required super.index,
    required super.position,
    required this.mode,
  });

  PositionListenerInfo._fromPosition(TogglePosition<T> position, ToggleMode mode)
      : this(
          value: position.value,
          index: position.index,
          position: position.position,
          mode: mode,
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionListenerInfo &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          index == other.index &&
          position == other.position &&
          mode == other.mode;

  @override
  int get hashCode => value.hashCode ^ index.hashCode ^ position.hashCode ^ mode.hashCode;
}

class TogglePosition<T> {
  final T value;
  final int index;
  final double position;

  TogglePosition({
    required this.value,
    required this.index,
    required this.position,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionListenerInfo &&
          runtimeType == other.runtimeType &&
          value == other.mode &&
          index == other.index &&
          position == other.position;

  @override
  int get hashCode => value.hashCode ^ index.hashCode ^ position.hashCode;
}

class GlobalToggleProperties<T> {
  final double position;
  final T current;
  final int currentIndex;
  bool get isCurrentListed => currentIndex >= 0;
  final T? previous;
  final List<T> values;
  final double previousPosition;
  final TextDirection textDirection;
  final ToggleMode mode;
  final double loadingAnimationValue;

  final bool active;
  final Animation<double> _indicatorAppearingAnimation;

  const GlobalToggleProperties({
    required this.position,
    required this.current,
    required this.currentIndex,
    required this.previous,
    required this.values,
    required this.previousPosition,
    required this.textDirection,
    required this.mode,
    required this.loadingAnimationValue,
    required this.active,
    required Animation<double> indicatorAppearingAnimation,
  }) : _indicatorAppearingAnimation = indicatorAppearingAnimation;
}

class DetailedGlobalToggleProperties<T> extends GlobalToggleProperties<T> {
  final double spacing;
  final Size indicatorSize;
  final Size switchSize;

  Size get spacingSize => Size(spacing, switchSize.height);

  const DetailedGlobalToggleProperties({
    required this.spacing,
    required this.indicatorSize,
    required this.switchSize,
    required super.position,
    required super.current,
    required super.currentIndex,
    required super.previous,
    required super.values,
    required super.previousPosition,
    required super.textDirection,
    required super.mode,
    required super.loadingAnimationValue,
    required super.active,
    required super.indicatorAppearingAnimation,
  });
}

class LocalToggleProperties<T> {
  final T value;
  final int index;
  bool get isValueListed => index >= 0;

  const LocalToggleProperties({
    required this.value,
    required this.index,
  });
}

class SeparatorProperties<T> {
  final int index;
  double get position => index + 0.5;

  const SeparatorProperties({
    required this.index,
  });
}

class CustomNotificationSwitch<T extends Object?> extends StatefulWidget {
  final T current;
  final List<T> values;

  final CustomWrapperBuilder<T>? wrapperBuilder;

  final CustomIconBuilder<T> iconBuilder;

  final CustomIndicatorBuilder<T>? foregroundIndicatorBuilder;

  final CustomIndicatorBuilder<T>? backgroundIndicatorBuilder;
  final IndicatorAppearingBuilder indicatorAppearingBuilder;

  final Duration animationDuration;

  final Curve animationCurve;

  final Duration? loadingAnimationDuration;

  final Curve? loadingAnimationCurve;

  final Duration indicatorAppearingDuration;

  final Curve indicatorAppearingCurve;

  final Size indicatorSize;

  final ChangeCallback<T>? onChanged;

  final double spacing;

  final CustomSeparatorBuilder<T>? separatorBuilder;

  final TapCallback<T>? onTap;

  final bool iconsTappable;

  final IconArrangement iconArrangement;

  final FittingMode fittingMode;

  final double height;

  final EdgeInsetsGeometry padding;

  final double minTouchTargetSize;

  final Duration dragStartDuration;

  final Curve dragStartCurve;

  final TextDirection? textDirection;

  final ToggleCursors cursors;

  final bool? loading;

  final bool allowUnlistedValues;

  final bool active;

  final PositionListener<T>? positionListener;

  const CustomNotificationSwitch({
    Key? key,
    required this.current,
    required this.values,
    required this.iconBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutCirc,
    this.indicatorSize = const Size(48.0, double.infinity),
    this.onChanged,
    this.spacing = 0.0,
    this.separatorBuilder,
    this.onTap,
    this.fittingMode = FittingMode.preventHorizontalOverlapping,
    this.wrapperBuilder,
    this.foregroundIndicatorBuilder,
    this.backgroundIndicatorBuilder,
    this.indicatorAppearingBuilder = _defaultIndicatorAppearingBuilder,
    this.height = 50.0,
    this.iconArrangement = IconArrangement.row,
    this.iconsTappable = true,
    this.padding = EdgeInsets.zero,
    this.minTouchTargetSize = 48.0,
    this.dragStartDuration = const Duration(milliseconds: 200),
    this.dragStartCurve = Curves.easeInOutCirc,
    this.textDirection,
    this.cursors = const ToggleCursors(),
    this.loading,
    this.loadingAnimationDuration,
    this.loadingAnimationCurve,
    this.indicatorAppearingDuration = _defaultIndicatorAppearingAnimationDuration,
    this.indicatorAppearingCurve = _defaultIndicatorAppearingAnimationCurve,
    this.allowUnlistedValues = false,
    this.active = true,
    this.positionListener,
  })  : assert(foregroundIndicatorBuilder != null || backgroundIndicatorBuilder != null),
        assert(separatorBuilder == null || (spacing > 0 && iconArrangement == IconArrangement.row)),
        super(key: key);

  @override
  State<CustomNotificationSwitch<T>> createState() => _CustomNotificationSwitchState<T>();
}

class _CustomNotificationSwitchState<T> extends State<CustomNotificationSwitch<T>> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _appearingController;
  late final CurvedAnimation _animation;
  late final CurvedAnimation _appearingAnimation;
  late _AnimationInfo _animationInfo;
  final List<Future<void>> _loadingFutures = [];

  late int _currentIndex;

  bool get _isCurrentUnlisted => _currentIndex < 0;

  double get _positionValue => _animationInfo.valueAt(_animation.value).clamp(0, widget.values.length - 1);

  PositionListenerInfo<T>? _lastPositionListenerValue;

  @override
  void initState() {
    super.initState();

    final current = widget.current;
    final isValueSelected = widget.values.contains(current);
    _currentIndex = widget.values.indexOf(current);
    _checkForUnlistedValue();
    _animationInfo =
        _AnimationInfo(isValueSelected ? _currentIndex.toDouble() : 0.0).setLoading(widget.loading ?? false);
    _controller = AnimationController(vsync: this, duration: widget.animationDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && _animationInfo.toggleMode != ToggleMode.dragged) {
          _setAnimationInfo(_animationInfo.ended());
        }
      });

    _animation = CurvedAnimation(parent: _controller, curve: widget.animationCurve)..addListener(_callPositionListener);

    _appearingController = AnimationController(
      vsync: this,
      duration: widget.indicatorAppearingDuration,
      value: isValueSelected ? 1.0 : 0.0,
    );

    _appearingAnimation = CurvedAnimation(
      parent: _appearingController,
      curve: widget.indicatorAppearingCurve,
    );
  }

  @override
  void didUpdateWidget(covariant CustomNotificationSwitch<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkForUnlistedValue();

    _appearingController.duration = widget.indicatorAppearingDuration;
    _appearingAnimation.curve = widget.indicatorAppearingCurve;
    _controller.duration = widget.animationDuration;
    _animation.curve = widget.animationCurve;

    if (oldWidget.active && !widget.active) {
      _cancelDrag();
    }
    if (oldWidget.loading != widget.loading) {
      _loading(widget.loading ?? _loadingFutures.isNotEmpty);
    }

    _checkValuePosition();
  }

  @override
  void dispose() {
    _controller.dispose();
    _appearingController.dispose();
    super.dispose();
  }

  @pragma('vm:notify-debugger-on-exception')
  void _checkForUnlistedValue() {
    if (!widget.allowUnlistedValues && !widget.values.contains(widget.current)) {
      try {
        throw ArgumentError(
            'The values in AnimatedToggleSwitch have to contain current if allowUnlistedValues is false.\n'
            'current: ${widget.current}\n'
            'values: ${widget.values}\n'
            'This error is only thrown in debug mode to minimize problems with the production app.');
      } catch (e, s) {
        if (kDebugMode) rethrow;
        FlutterError.reportError(FlutterErrorDetails(exception: e, stack: s, library: 'AnimatedToggleSwitch'));
      }
    }
  }

  bool get _isActive => widget.active && !_animationInfo.loading;

  void _addLoadingFuture(Future<void> future) {
    _loadingFutures.add(future);
    final futureLength = _loadingFutures.length;
    if (widget.loading == null) _loading(true);
    Future.wait(_loadingFutures).whenComplete(() {
      // Check if new future is added since calling method
      if (futureLength != _loadingFutures.length) return;
      if (widget.loading == null && mounted) _loading(false);
      _loadingFutures.clear();
    });
  }

  void _onChanged(T value) {
    if (!_isActive) return;
    final result = widget.onChanged?.call(value);
    if (result is Future) {
      _addLoadingFuture(result);
    }
  }

  void _onTap(TapProperties<T> info) {
    if (!_isActive) return;
    final result = widget.onTap?.call(info);
    if (result is Future) {
      _addLoadingFuture(result);
    }
  }

  void _loading(bool b) {
    if (b == _animationInfo.loading) return;
    _cancelDrag();
    _setAnimationInfo(_animationInfo.setLoading(b), setState: true);
  }

  void _checkValuePosition() {
    _currentIndex = widget.values.indexOf(widget.current);
    if (_animationInfo.toggleMode == ToggleMode.dragged) return;
    if (_currentIndex >= 0) {
      _animateTo(_currentIndex);
    } else {
      _appearingController.reverse();
    }
  }

  double _doubleFromPosition(double x, DetailedGlobalToggleProperties<T> properties) {
    double result =
        (x.clamp(properties.indicatorSize.width / 2, properties.switchSize.width - properties.indicatorSize.width / 2) -
                properties.indicatorSize.width / 2) /
            (properties.indicatorSize.width + properties.spacing);
    if (properties.textDirection == TextDirection.rtl) {
      result = widget.values.length - 1 - result;
    }
    return result;
  }

  void _setAnimationInfo(_AnimationInfo info, {bool setState = false}) {
    if (_animationInfo == info) return;
    _animationInfo = info;
    if (setState) this.setState(() {});
    _callPositionListener();
  }

  void _callPositionListener() {
    if (widget.positionListener == null) return;
    final value =
        PositionListenerInfo._fromPosition(_togglePositionFromPositionValue(_positionValue), _animationInfo.toggleMode);
    if (_lastPositionListenerValue == value) return;
    _lastPositionListenerValue = value;
    widget.positionListener?.call(value);
  }

  TogglePosition<T> _togglePositionFromPositionValue(double position) {
    final index = position.round();
    return TogglePosition(
      value: widget.values[index],
      index: index,
      position: position,
    );
  }

  TogglePosition<T> _togglePositionFromRealPosition(double x, DetailedGlobalToggleProperties<T> properties) {
    return _togglePositionFromPositionValue(_doubleFromPosition(x, properties));
  }

  @override
  Widget build(BuildContext context) {
    double spacing = widget.spacing;
    final textDirection = _textDirectionOf(context);
    final loadingValue = _animationInfo.loading ? 1.0 : 0.0;
    final privateIndicatorAppearingAnimation = _PrivateAnimation(_appearingAnimation);

    final defaultCursor = !_isActive
        ? (_animationInfo.loading ? widget.cursors.loadingCursor : widget.cursors.inactiveCursor)
        : (widget.cursors.defaultCursor ?? (widget.onTap == null ? MouseCursor.defer : SystemMouseCursors.click));

    return SizedBox(
      height: widget.height,
      child: MouseRegion(
        hitTestBehavior: HitTestBehavior.deferToChild,
        cursor: defaultCursor,
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTapUp: (_) => _onTap(TapProperties(
            tapped: null,
            values: widget.values,
          )),
          child: TweenAnimationBuilder<double>(
            duration: widget.loadingAnimationDuration ?? widget.animationDuration,
            curve: widget.loadingAnimationCurve ?? widget.animationCurve,
            tween: Tween(begin: loadingValue, end: loadingValue),
            builder: (context, loadingValue, child) => AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  double positionValue = _positionValue;
                  GlobalToggleProperties<T> properties = GlobalToggleProperties(
                    position: positionValue,
                    current: widget.current,
                    currentIndex: _currentIndex,
                    previous: _animationInfo.start.toInt() == _animationInfo.start
                        ? widget.values[_animationInfo.start.toInt()]
                        : null,
                    values: widget.values,
                    previousPosition: _animationInfo.start,
                    textDirection: textDirection,
                    mode: _animationInfo.toggleMode,
                    loadingAnimationValue: loadingValue,
                    active: widget.active,
                    indicatorAppearingAnimation: privateIndicatorAppearingAnimation,
                  );
                  Widget child = Padding(
                    padding: widget.padding,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double height = constraints.maxHeight;
                        assert(
                            constraints.maxWidth.isFinite || (widget.indicatorSize.width.isFinite && spacing.isFinite),
                            'With unbound width constraints '
                            'the width of the indicator and the spacing '
                            "can't be infinite");
                        assert(
                            widget.indicatorSize.width.isFinite || spacing.isFinite,
                            'The width of the indicator '
                            'or the spacing must be finite.');

                        // Recalculates the indicatorSize if its width or height is
                        // infinite.
                        Size indicatorSize = Size(
                            widget.indicatorSize.width.isInfinite
                                ? (constraints.maxWidth - spacing * (widget.values.length - 1)) / widget.values.length
                                : widget.indicatorSize.width,
                            widget.indicatorSize.height.isInfinite ? height : widget.indicatorSize.height);

                        if (spacing.isInfinite) {
                          spacing = (constraints.maxWidth - widget.indicatorSize.width * widget.values.length) /
                              (widget.values.length - 1);
                        }

                        // Calculates the required width of the widget.
                        double width =
                            indicatorSize.width * widget.values.length + (widget.values.length - 1) * spacing;

                        // Handles the case that the required width of the widget
                        // cannot be used due to the given BoxConstraints.
                        if (widget.fittingMode == FittingMode.preventHorizontalOverlapping &&
                            width > constraints.maxWidth) {
                          double factor = constraints.maxWidth / width;
                          spacing *= factor;
                          width = constraints.maxWidth;
                          indicatorSize = Size(
                              indicatorSize.width.isInfinite
                                  ? width / widget.values.length
                                  : factor * indicatorSize.width,
                              indicatorSize.height);
                        } else if (constraints.minWidth > width) {
                          spacing += (constraints.minWidth - width) / (widget.values.length - 1);
                          width = constraints.minWidth;
                        }

                        double dragDif = indicatorSize.width < widget.minTouchTargetSize
                            ? (widget.minTouchTargetSize - indicatorSize.width)
                            : 0;

                        double position = (indicatorSize.width + spacing) * positionValue + indicatorSize.width / 2;

                        double leftPosition = textDirection == TextDirection.rtl ? width - position : position;

                        bool isHoveringIndicator(Offset offset) {
                          if (!_isActive || _isCurrentUnlisted) {
                            return false;
                          }
                          double dx = textDirection == TextDirection.rtl ? width - offset.dx : offset.dx;
                          return position - (indicatorSize.width + dragDif) / 2 <= dx &&
                              dx <= (position + (indicatorSize.width + dragDif) / 2);
                        }

                        DetailedGlobalToggleProperties<T> properties = DetailedGlobalToggleProperties(
                          spacing: spacing,
                          position: positionValue,
                          indicatorSize: indicatorSize,
                          switchSize: Size(width, height),
                          current: widget.current,
                          currentIndex: _currentIndex,
                          previous: _animationInfo.start.toInt() == _animationInfo.start
                              ? widget.values[_animationInfo.start.toInt()]
                              : null,
                          values: widget.values,
                          previousPosition: _animationInfo.start,
                          textDirection: textDirection,
                          mode: _animationInfo.toggleMode,
                          loadingAnimationValue: loadingValue,
                          active: widget.active,
                          indicatorAppearingAnimation: privateIndicatorAppearingAnimation,
                        );

                        List<Widget> stack = <Widget>[
                          if (widget.backgroundIndicatorBuilder != null)
                            _Indicator(
                              key: const ValueKey(0),
                              textDirection: textDirection,
                              height: height,
                              indicatorSize: indicatorSize,
                              position: position,
                              appearingAnimation: _appearingAnimation,
                              appearingBuilder: widget.indicatorAppearingBuilder,
                              child: widget.backgroundIndicatorBuilder!(context, properties),
                            ),
                          if (widget.iconArrangement == IconArrangement.overlap)
                            ..._buildBackgroundStack(context, properties)
                          else
                            ..._buildBackgroundRow(context, properties),
                          if (widget.foregroundIndicatorBuilder != null)
                            _Indicator(
                              key: const ValueKey(1),
                              textDirection: textDirection,
                              height: height,
                              indicatorSize: indicatorSize,
                              position: position,
                              appearingAnimation: _appearingAnimation,
                              appearingBuilder: widget.indicatorAppearingBuilder,
                              child: widget.foregroundIndicatorBuilder!(context, properties),
                            ),
                        ];

                        return _WidgetPart(
                          left: loadingValue * (leftPosition - 0.5 * indicatorSize.width),
                          width: indicatorSize.width + (1 - loadingValue) * (width - indicatorSize.width),
                          height: height,
                          child: ConstrainedBox(
                            constraints: constraints.loosen(),
                            child: SizedBox(
                              width: width,
                              height: height,
                              child: _HoverRegion(
                                hoverCursor: widget.cursors.tapCursor,
                                hoverCheck: (pos) =>
                                    widget.iconsTappable &&
                                    _doubleFromPosition(pos.dx, properties).round() != _currentIndex,
                                child: _DragRegion(
                                  dragging: _animationInfo.toggleMode == ToggleMode.dragged,
                                  draggingCursor: widget.cursors.draggingCursor,
                                  dragCursor: widget.cursors.dragCursor,
                                  hoverCheck: isHoveringIndicator,
                                  defaultCursor: defaultCursor,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    dragStartBehavior: DragStartBehavior.down,
                                    onTapUp: (details) {
                                      final togglePosition =
                                          _togglePositionFromRealPosition(details.localPosition.dx, properties);
                                      _onTap(TapProperties(
                                        tapped: TapInfo._fromPosition(togglePosition),
                                        values: widget.values,
                                      ));
                                      if (!widget.iconsTappable) return;
                                      if (togglePosition.value == widget.current) {
                                        return;
                                      }
                                      _onChanged(togglePosition.value);
                                    },
                                    onHorizontalDragStart: (details) {
                                      if (!isHoveringIndicator(details.localPosition)) {
                                        return;
                                      }
                                      _onDragged(
                                          _doubleFromPosition(details.localPosition.dx, properties), positionValue);
                                    },
                                    onHorizontalDragUpdate: (details) {
                                      _onDragUpdate(_doubleFromPosition(details.localPosition.dx, properties));
                                    },
                                    onHorizontalDragEnd: (details) {
                                      _onDragEnd();
                                    },
                                    child: DecoratedBox(
                                        position: DecorationPosition.background,
                                        decoration: const BoxDecoration(),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: stack,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                  return widget.wrapperBuilder?.call(context, properties, child) ?? child;
                }),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundStack(BuildContext context, DetailedGlobalToggleProperties<T> properties) {
    return [
      ...Iterable.generate(widget.values.length, (i) {
        double position = i * (properties.indicatorSize.width + properties.spacing);
        return Positioned.directional(
          textDirection: _textDirectionOf(context),
          start: i == 0 ? position : position - properties.spacing,
          width:
              (i == 0 || i == widget.values.length - 1 ? 1 : 2) * properties.spacing + properties.indicatorSize.width,
          height: properties.indicatorSize.height,
          child: widget.iconBuilder(
            context,
            LocalToggleProperties(value: widget.values[i], index: i),
            properties,
          ),
        );
      }),
      Row(
        children: [
          SizedBox(
            width: properties.switchSize.width,
            height: 1.0,
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildBackgroundRow(BuildContext context, DetailedGlobalToggleProperties<T> properties) {
    final length = properties.values.length;
    return [
      Row(
        textDirection: _textDirectionOf(context),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int i = 0; i < length; i++) ...[
            SizedBox(
                width: properties.indicatorSize.width,
                height: properties.indicatorSize.height,
                child: widget.iconBuilder(
                  context,
                  LocalToggleProperties(value: widget.values[i], index: i),
                  properties,
                )),
            if (i < length - 1 && widget.separatorBuilder != null)
              SizedBox(
                width: properties.spacing,
                child: Center(
                  child: widget.separatorBuilder!(context, SeparatorProperties(index: i), properties),
                ),
              ),
          ]
        ],
      ),
    ];
  }

  void _animateTo(int index, {double? current}) {
    if (_animationInfo.toggleMode == ToggleMode.dragged) return;
    if (_appearingController.value > 0.0) {
      if (index.toDouble() != _animationInfo.end) {
        _setAnimationInfo(
            _animationInfo.toEnd(index.toDouble(), current: current ?? _animationInfo.valueAt(_animation.value)));
        _controller.duration = widget.animationDuration;
        _animation.curve = widget.animationCurve;
        _controller.forward(from: 0.0);
      }
    } else {
      _setAnimationInfo(_animationInfo.toEnd(index.toDouble()).ended());
    }
    _appearingController.forward();
  }

  void _onDragged(double indexPosition, double pos) {
    if (!_isActive) return;
    _setAnimationInfo(_animationInfo.dragged(indexPosition, pos: pos));
    _controller.duration = widget.dragStartDuration;
    _animation.curve = widget.dragStartCurve;
    _controller.forward(from: 0.0);
  }

  void _onDragUpdate(double indexPosition) {
    if (_animationInfo.toggleMode != ToggleMode.dragged) return;
    _setAnimationInfo(_animationInfo.dragged(indexPosition), setState: true);
  }

  void _onDragEnd() {
    if (_animationInfo.toggleMode != ToggleMode.dragged) return;
    int index = _animationInfo.end.round();
    T newValue = widget.values[index];
    _setAnimationInfo(_animationInfo.none(current: _animationInfo.end));
    if (widget.current != newValue) _onChanged(newValue);
    _checkValuePosition();
  }

  void _cancelDrag() {
    _setAnimationInfo(_animationInfo.none());
    _checkValuePosition();
  }

  TextDirection _textDirectionOf(BuildContext context) =>
      widget.textDirection ?? Directionality.maybeOf(context) ?? TextDirection.ltr;
}

class _AnimationInfo {
  final double start;

  final double end;

  final ToggleMode toggleMode;
  final bool loading;

  const _AnimationInfo(
    this.start, {
    this.toggleMode = ToggleMode.none,
    this.loading = false,
  }) : end = start;

  const _AnimationInfo._internal(
    this.start,
    this.end, {
    this.toggleMode = ToggleMode.none,
    this.loading = false,
  });

  const _AnimationInfo.animating(
    this.start,
    this.end, {
    this.loading = false,
  }) : toggleMode = ToggleMode.animating;

  _AnimationInfo toEnd(double end, {double? current}) =>
      _AnimationInfo.animating(current ?? start, end, loading: loading);

  _AnimationInfo none({double? current}) =>
      _AnimationInfo(current ?? start, toggleMode: ToggleMode.none, loading: loading);

  _AnimationInfo ended() => _AnimationInfo(end, loading: loading);

  _AnimationInfo dragged(double current, {double? pos}) => _AnimationInfo._internal(
        pos ?? start,
        current,
        toggleMode: ToggleMode.dragged,
        loading: false,
      );

  _AnimationInfo setLoading(bool loading) =>
      _AnimationInfo._internal(start, end, toggleMode: toggleMode, loading: loading);

  double valueAt(num position) => start + (end - start) * position;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _AnimationInfo &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end &&
          toggleMode == other.toggleMode &&
          loading == other.loading;

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ toggleMode.hashCode ^ loading.hashCode;
}

class ToggleCursors {
  final MouseCursor? defaultCursor;
  final MouseCursor tapCursor;
  final MouseCursor draggingCursor;
  final MouseCursor dragCursor;
  final MouseCursor loadingCursor;
  final MouseCursor inactiveCursor;

  const ToggleCursors({
    this.defaultCursor,
    this.tapCursor = SystemMouseCursors.click,
    this.draggingCursor = SystemMouseCursors.grabbing,
    this.dragCursor = SystemMouseCursors.grab,
    this.loadingCursor = MouseCursor.defer,
    this.inactiveCursor = SystemMouseCursors.forbidden,
  });

  const ToggleCursors.all(MouseCursor cursor)
      : defaultCursor = cursor,
        tapCursor = cursor,
        draggingCursor = cursor,
        dragCursor = cursor,
        loadingCursor = cursor,
        inactiveCursor = cursor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToggleCursors &&
          runtimeType == other.runtimeType &&
          defaultCursor == other.defaultCursor &&
          tapCursor == other.tapCursor &&
          draggingCursor == other.draggingCursor &&
          dragCursor == other.dragCursor &&
          loadingCursor == other.loadingCursor &&
          inactiveCursor == other.inactiveCursor;

  @override
  int get hashCode =>
      defaultCursor.hashCode ^
      tapCursor.hashCode ^
      draggingCursor.hashCode ^
      dragCursor.hashCode ^
      loadingCursor.hashCode ^
      inactiveCursor.hashCode;
}

class _PrivateAnimation<T> extends Animation<T> {
  final Animation<T> _parent;

  _PrivateAnimation(this._parent);

  @override
  void addListener(VoidCallback listener) => _parent.addListener(listener);

  @override
  void addStatusListener(AnimationStatusListener listener) => _parent.addStatusListener(listener);

  @override
  void removeListener(VoidCallback listener) => _parent.removeListener(listener);

  @override
  void removeStatusListener(AnimationStatusListener listener) => _parent.removeStatusListener(listener);

  @override
  AnimationStatus get status => _parent.status;

  @override
  T get value => _parent.value;
}

class _HoverRegion extends StatefulWidget {
  final MouseCursor? cursor;
  final MouseCursor hoverCursor;
  final Widget child;
  final bool Function(Offset offset) hoverCheck;
  final MouseCursor defaultCursor;

  const _HoverRegion({
    Key? key,
    this.cursor,
    required this.hoverCursor,
    required this.child,
    this.hoverCheck = _defaultHoverCheck,
    this.defaultCursor = MouseCursor.defer,
  }) : super(key: key);

  static bool _defaultHoverCheck(Offset offset) => true;

  @override
  State<_HoverRegion> createState() => _HoverRegionState();
}

class _HoverRegionState extends State<_HoverRegion> {
  bool _hovering = false;
  Offset? _position;

  @override
  Widget build(BuildContext context) {
    if (_position != null) _updateHovering(_position!, rebuild: false);
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerHover: _updatePointer,
      onPointerMove: _updatePointer,
      child: GestureDetector(
        child: MouseRegion(
          opaque: false,
          hitTestBehavior: HitTestBehavior.translucent,
          cursor: widget.cursor ?? (_hovering ? widget.hoverCursor : widget.defaultCursor),
          onExit: (e) => _setHovering(false),
          child: widget.child,
        ),
      ),
    );
  }

  void _updatePointer(PointerEvent event, {bool rebuild = true}) {
    _updateHovering(event.localPosition, rebuild: rebuild);
  }

  void _updateHovering(Offset offset, {bool rebuild = true}) {
    _setHovering(widget.hoverCheck(_position = offset), rebuild: rebuild);
  }

  void _setHovering(bool hovering, {bool rebuild = true}) {
    if (hovering == _hovering) return;
    _hovering = hovering;
    if (rebuild) setState(() {});
  }
}

class _DragRegion extends StatelessWidget {
  final bool dragging;
  final Widget child;
  final bool Function(Offset offset) hoverCheck;
  final MouseCursor defaultCursor;
  final MouseCursor dragCursor;
  final MouseCursor draggingCursor;

  const _DragRegion({
    Key? key,
    this.dragging = false,
    required this.child,
    this.hoverCheck = _HoverRegion._defaultHoverCheck,
    this.defaultCursor = MouseCursor.defer,
    this.dragCursor = SystemMouseCursors.grab,
    this.draggingCursor = SystemMouseCursors.grabbing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _HoverRegion(
      cursor: dragging ? draggingCursor : null,
      hoverCursor: dragCursor,
      hoverCheck: hoverCheck,
      defaultCursor: defaultCursor,
      child: child,
    );
  }
}

class _Indicator extends StatelessWidget {
  final double height;
  final Size indicatorSize;
  final double position;
  final Widget child;
  final TextDirection textDirection;
  final Animation<double> appearingAnimation;
  final IndicatorAppearingBuilder appearingBuilder;

  const _Indicator({
    super.key,
    required this.height,
    required this.indicatorSize,
    required this.position,
    required this.textDirection,
    required this.appearingAnimation,
    required this.appearingBuilder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.directional(
      textDirection: textDirection,
      top: (height - indicatorSize.height) / 2,
      start: position - indicatorSize.width / 2,
      width: indicatorSize.width,
      height: indicatorSize.height,
      child: AnimatedBuilder(
          animation: appearingAnimation,
          builder: (context, _) {
            return appearingBuilder(context, appearingAnimation.value, child);
          }),
    );
  }
}

class _WidgetPart extends StatelessWidget {
  final double width, height;
  final double left;
  final Widget child;

  const _WidgetPart({
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
    required this.left,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OverflowBox(
        alignment: Alignment.topLeft,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: Transform.translate(offset: Offset(-left, 0), child: child),
      ),
    );
  }
}

Widget _defaultIndicatorAppearingBuilder(BuildContext context, double value, Widget indicator) {
  return Transform.scale(scale: value, child: indicator);
}

const _defaultIndicatorAppearingAnimationDuration = Duration(milliseconds: 350);
const _defaultIndicatorAppearingAnimationCurve = Curves.easeOutBack;

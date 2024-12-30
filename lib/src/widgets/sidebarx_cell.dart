import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class SidebarXCell extends StatefulWidget {
  const SidebarXCell({
    Key? key,
    required this.item,
    required this.extended,
    required this.selected,
    required this.theme,
    this.onTap,
    required this.onLongPress,
    required this.onSecondaryTap,
    required this.animationController,
    this.panelExpanded,
    this.decoration,
  }) : super(key: key);

  final bool extended;
  final bool selected;
  final bool? panelExpanded;
  final SidebarXItem item;
  final SidebarXTheme theme;
  final VoidCallback? onTap;
  final VoidCallback onLongPress;
  final VoidCallback onSecondaryTap;
  final AnimationController animationController;
  final Decoration Function(bool)? decoration;
  @override
  State<SidebarXCell> createState() => _SidebarXCellState();
}

class _SidebarXCellState extends State<SidebarXCell> {
  late Animation<double> _animation;
  var _hovered = false;

  @override
  void initState() {
    super.initState();
    _animation = CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final iconTheme = widget.selected
        ? theme.selectedIconTheme
        : _hovered
            ? theme.hoverIconTheme ?? theme.selectedIconTheme
            : theme.iconTheme;
    final textStyle = widget.selected
        ? theme.selectedTextStyle
        : _hovered
            ? theme.hoverTextStyle
            : theme.textStyle;
    final decoration =
        (widget.selected ? theme.selectedItemDecoration : theme.itemDecoration);
    final margin =
        (widget.selected ? theme.selectedItemMargin : theme.itemMargin);
    final padding =
        (widget.selected ? theme.selectedItemPadding : theme.itemPadding);
    final textPadding =
        widget.selected ? theme.selectedItemTextPadding : theme.itemTextPadding;

    return MouseRegion(
      onEnter: (_) => _onEnteredCellZone(),
      onExit: (_) => _onExitCellZone(),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onSecondaryTap: widget.onSecondaryTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: widget.decoration?.call(_hovered) ??
              decoration?.copyWith(
                color: _hovered && !widget.selected ? theme.hoverColor : null,
              ),
          padding: padding ?? const EdgeInsets.all(8),
          margin: margin ?? const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: widget.extended
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, _) {
                  final value = ((1 - _animation.value) * 6).toInt();
                  if (value <= 0) {
                    return const SizedBox();
                  }
                  return Spacer(flex: value);
                },
              ),
              if (widget.item.iconBuilder != null)
                widget.item.iconBuilder!.call(widget.selected, _hovered)
              else if (widget.item.icon != null)
                _Icon(item: widget.item, iconTheme: iconTheme)
              // ignore: deprecated_member_use_from_same_package
              else if (widget.item.iconWidget != null)
                // ignore: deprecated_member_use_from_same_package
                widget.item.iconWidget!,
              Flexible(
                flex: 6,
                child: FadeTransition(
                  opacity: _animation,
                  child: Padding(
                    padding: textPadding ?? EdgeInsets.zero,
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.item.label ?? '',
                            style: textStyle,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                        ),
                        if (widget.panelExpanded != null) ...[
                          _ExpansionIcon(
                            item: widget.item,
                            iconTheme: iconTheme,
                            selected: widget.selected,
                            expanded: widget.panelExpanded!,
                          )
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEnteredCellZone() {
    setState(() => _hovered = true);
  }

  void _onExitCellZone() {
    setState(() => _hovered = false);
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    Key? key,
    required this.item,
    required this.iconTheme,
  }) : super(key: key);

  final SidebarXItem item;
  final IconThemeData? iconTheme;

  @override
  Widget build(BuildContext context) {
    return Icon(
      item.icon,
      color: iconTheme?.color,
      size: iconTheme?.size,
    );
  }
}

class _ExpansionIcon extends StatelessWidget {
  const _ExpansionIcon({
    Key? key,
    required this.item,
    required this.iconTheme,
    required this.selected,
    required this.expanded,
  }) : super(key: key);
  final bool selected;
  final bool expanded;
  final SidebarXItem item;
  final IconThemeData? iconTheme;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: expanded ? 0 : 3.14,
        end: expanded ? 3.14 : 0,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        if (selected) {
          return Transform.rotate(
            angle: value,
            child: child,
          );
        }
        return child!;
      },
      child: Icon(
        Icons.expand_more,
        color: iconTheme?.color,
        size: iconTheme?.size,
      ),
    );
  }
}

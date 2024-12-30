import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import 'sidebarx_cell.dart';

class ExpandedSidebarXCell extends StatelessWidget {
  const ExpandedSidebarXCell({
    Key? key,
    required this.item,
    required this.extended,
    required this.selected,
    required this.theme,
    this.onTap,
    this.onItemTap,
    required this.onLongPress,
    required this.onSecondaryTap,
    required this.animationController,
    required this.panelExpanded,
    required this.itemSelected,
    required this.onExpanded,
    this.childrenPadding,
    this.showTrailingIcon = true,
    this.shape,
    this.alwaysExpanded = true,
    this.onTitleTap,
  }) : super(key: key);

  final bool extended;
  final bool selected;
  final bool showTrailingIcon;
  final bool Function(int index) itemSelected;
  final bool panelExpanded;
  final SidebarXItem item;
  final SidebarXTheme theme;
  final VoidCallback? onTap;
  final Function(int, SidebarXItem)? onItemTap;
  final VoidCallback onLongPress;
  final VoidCallback onSecondaryTap;
  final VoidCallback onExpanded;
  final AnimationController animationController;
  final EdgeInsets? childrenPadding;
  final ShapeBorder? shape;
  final bool alwaysExpanded;
  final VoidCallback? onTitleTap;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: shape,
      showTrailingIcon: false,
      enabled: !alwaysExpanded,
      tilePadding: EdgeInsets.zero,
      childrenPadding: childrenPadding ?? EdgeInsets.zero,
      onExpansionChanged: (_) {
        onExpanded();
        onTitleTap?.call();
      },
      initiallyExpanded: alwaysExpanded ? true : panelExpanded,
      title: SidebarXCell(
        item: item,
        decoration: (hovered) => const BoxDecoration(),
        onTap: alwaysExpanded == false ? null : onTitleTap,
        theme: theme,
        panelExpanded: showTrailingIcon ? panelExpanded : null,
        animationController: animationController,
        extended: extended,
        selected: selected,
        onLongPress: onLongPress,
        onSecondaryTap: onSecondaryTap,
      ),
      children: item.children!.map((e) {
        final itemIndex = item.children!.indexOf(e);
        return SidebarXCell(
          item: e,
          theme: theme,
          animationController: animationController,
          extended: extended,
          selected: itemSelected(itemIndex),
          onTap: () => onItemTap?.call(itemIndex, e),
          onLongPress: onLongPress,
          onSecondaryTap: onSecondaryTap,
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_navigation_destination.dart';

class AppBottomNavigation extends StatefulWidget {
  const AppBottomNavigation({
    required this.navigationShell,
    required this.destinations,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final List<AppNavigationDestination> destinations;

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  static const int _visibleItemCount = 4;
  static const double _itemHeight = 68;
  static const double _hintHeight = 22;
  static const double _verticalPadding = 5;

  late final PageController _pageController;
  int _currentPage = 0;

  int get _pageCount {
    if (widget.destinations.isEmpty) return 1;
    return (widget.destinations.length / _visibleItemCount).ceil();
  }

  int get _selectedIndex {
    final index = widget.destinations.indexWhere(
      (item) => item.branchIndex == widget.navigationShell.currentIndex,
    );

    return index < 0 ? 0 : index;
  }

  int get _selectedPage {
    if (widget.destinations.isEmpty) return 0;
    return (_selectedIndex ~/ _visibleItemCount).clamp(0, _pageCount - 1);
  }

  @override
  void initState() {
    super.initState();
    _currentPage = _selectedPage;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void didUpdateWidget(covariant AppBottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);

    final navigationChanged =
        oldWidget.navigationShell.currentIndex != widget.navigationShell.currentIndex;
    final lengthChanged = oldWidget.destinations.length != widget.destinations.length;

    if (navigationChanged || lengthChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pageController.hasClients) return;

        final targetPage = _selectedPage;
        if (targetPage == _currentPage) return;

        setState(() => _currentPage = targetPage);
        _pageController.animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.destinations.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final unselected = theme.colorScheme.onSurface.withValues(alpha: 0.62);
    final canSwipe = _pageCount > 1;

    return SizedBox(
      height: _itemHeight + (canSwipe ? _hintHeight : 0) + (_verticalPadding * 2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
        child: Column(
          children: [
            SizedBox(
              height: _itemHeight,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    physics: canSwipe
                        ? const PageScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    itemCount: _pageCount,
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                    },
                    itemBuilder: (context, pageIndex) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var column = 0; column < _visibleItemCount; column++)
                            Expanded(
                              child: _buildSlot(
                                pageIndex: pageIndex,
                                column: column,
                                selectedIndex: _selectedIndex,
                                selectedColor: primary,
                                unselectedColor: unselected,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  if (canSwipe && _currentPage < _pageCount - 1)
                    _SwipeEdgeHint(
                      alignment: Alignment.centerRight,
                      icon: Icons.chevron_right_rounded,
                      color: primary,
                    ),
                  if (canSwipe && _currentPage > 0)
                    _SwipeEdgeHint(
                      alignment: Alignment.centerLeft,
                      icon: Icons.chevron_left_rounded,
                      color: primary,
                    ),
                ],
              ),
            ),
            if (canSwipe)
              SizedBox(
                height: _hintHeight,
                child: _NavigationSwipeIndicator(
                  currentPage: _currentPage,
                  pageCount: _pageCount,
                  activeColor: primary,
                  inactiveColor: unselected,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlot({
    required int pageIndex,
    required int column,
    required int selectedIndex,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    final index = (pageIndex * _visibleItemCount) + column;

    if (index >= widget.destinations.length) {
      return const SizedBox.shrink();
    }

    return _BottomNavItem(
      destination: widget.destinations[index],
      selected: index == selectedIndex,
      selectedColor: selectedColor,
      unselectedColor: unselectedColor,
      onTap: () {
        final destination = widget.destinations[index];

        widget.navigationShell.goBranch(
          destination.branchIndex,
          initialLocation: destination.branchIndex == widget.navigationShell.currentIndex,
        );
      },
    );
  }
}

class _NavigationSwipeIndicator extends StatelessWidget {
  const _NavigationSwipeIndicator({
    required this.currentPage,
    required this.pageCount,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int currentPage;
  final int pageCount;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    final canGoLeft = currentPage > 0;
    final canGoRight = currentPage < pageCount - 1;
    final label = canGoRight
        ? 'Geser untuk fitur lainnya'
        : canGoLeft
            ? 'Geser kembali'
            : 'Menu fitur';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          canGoLeft ? Icons.keyboard_arrow_left_rounded : Icons.swipe_left_rounded,
          size: 14,
          color: canGoLeft ? activeColor : inactiveColor,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: inactiveColor,
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
        ),
        const SizedBox(width: 8),
        for (var index = 0; index < pageCount; index++) ...[
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: index == currentPage ? 14 : 5,
            height: 5,
            decoration: BoxDecoration(
              color: index == currentPage
                  ? activeColor
                  : inactiveColor.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          if (index != pageCount - 1) const SizedBox(width: 4),
        ],
        const SizedBox(width: 4),
        Icon(
          canGoRight ? Icons.keyboard_arrow_right_rounded : Icons.swipe_right_rounded,
          size: 14,
          color: canGoRight ? activeColor : inactiveColor,
        ),
      ],
    );
  }
}

class _SwipeEdgeHint extends StatelessWidget {
  const _SwipeEdgeHint({
    required this.alignment,
    required this.icon,
    required this.color,
  });

  final Alignment alignment;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: Container(
          width: 22,
          margin: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.destination,
    required this.selected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  final AppNavigationDestination destination;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected ? selectedColor : unselectedColor;
    final textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: iconColor,
          fontWeight: selected ? FontWeight.w900 : FontWeight.w800,
          fontSize: 10.5,
          letterSpacing: -0.25,
          height: 1.0,
        );

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: Tooltip(
        message: destination.label,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  width: selected ? 48 : 42,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? selectedColor.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    selected ? destination.selectedIcon : destination.icon,
                    color: iconColor,
                    size: selected ? 24 : 22,
                  ),
                ),
                const SizedBox(height: 3),
                SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        destination.label,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.visible,
                        style: textStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

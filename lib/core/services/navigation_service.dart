import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

final navigator = NavigationService();

class NavigationService {
  /// Navigator state key
  final key = GlobalKey<NavigatorState>();

  /// Navigator's current state
  NavigatorState? get state => key.currentState;

  /// Navigator's current context
  BuildContext get context => state!.context;

  /// Smooth navigation from Splash
  Future navigateFromSplash(
    Widget route, {
    bool isDialog = false,
  }) {
    return state!.pushAndRemoveUntil(
      PageTransition(
        alignment: Alignment.center,
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 1000),
        child: route,
      ),
      (route) => false,
    );
  }

  /// Push a named route
  void pushTop(String routeName) {
    state!.pushNamed(routeName);
  }

  /// Push a replacement route
  void replaceTop(
    Widget page, {
    bool isDialog = false,
    bool isTransparent = false,
  }) {
    final route =
        isTransparent ? _transparentRoute(page) : _materialRoute(page);
    state!.pushReplacement(route);
  }

  /// Push a  route and replace the root route
  Future<void> replaceRoot(
    Widget root, {
    bool isDialog = false,
    bool isTransparent = false,
  }) async {
    final route =
        isTransparent ? _transparentRoute(root) : _materialRoute(root);
    await state!.pushAndRemoveUntil(route, (route) => false);
  }

  /// Push a  route
  Future<T?> pushTo<T>(
    Widget page, {
    bool isDialog = false,
    bool isTransparent = false,
  }) {
    final route = isTransparent
        ? _transparentRoute<T>(page)
        : _materialRoute<T>(
            page,
          );
    // recordRoute(page);
    return state!.push(route);
  }

  /// Pop to initial route
  void popToFirst() => state!.popUntil((route) => route.isFirst);

  void maybePop<T extends Object?>([T? result]) =>
      state!.canPop() ? state!.pop(result) : () {};

  /// Pop/remove current route
  void pop<T extends Object?>([T? result]) => state!.pop(result);

  void multiPop([int popCount = 1]) {
    for (var i = 1; i <= popCount; i++) {
      pop();
    }
  }

  /// If ui can pop/remove current route
  bool get canPop => state!.canPop();

  /// Custom material route
  PageTransition<T> _materialRoute<T>(
    Widget widget,
  ) {
    return PageTransition<T>(
      alignment: Alignment.center,
      type: PageTransitionType.fade,
      curve: Curves.ease,
      duration: const Duration(milliseconds: 100),
      childCurrent: widget,
      child: widget,
    );
  }

  /// Custom Transaprent route
  TransparentRoute<T> _transparentRoute<T>(Widget widget) {
    return TransparentRoute<T>(
      builder: (context) => widget,
    );
  }
}

extension MyNavigator on BuildContext {
  void navigateFromSplash(
    Widget route, {
    bool isDialog = false,
  }) =>
      navigator.navigateFromSplash(
        route,
        isDialog: isDialog,
      );

  void navigateReplace(
    Widget route, {
    bool isDialog = false,
    bool isTransparent = false,
  }) =>
      navigator.replaceTop(
        route,
        isDialog: isDialog,
        isTransparent: isTransparent,
      );

  Future<T?> navigate<T>(
    Widget route, {
    bool isDialog = false,
    bool isTransparent = false,
  }) =>
      navigator.pushTo<T>(
        route,
        isDialog: isDialog,
        isTransparent: isTransparent,
      );

  void popNavigate(
    Widget route, {
    bool isDialog = false,
    bool isTransparent = false,
  }) =>
      navigator
        ..pop()
        ..pushTo(
          route,
          isDialog: isDialog,
          isTransparent: isTransparent,
        );

  void popToFirst() => navigator.popToFirst();

  void pop<T extends Object?>([T? result]) => navigator.pop<T>(result);

  void multiPop([int popCount = 1]) => navigator.multiPop(popCount);

  void maybePop<T extends Object?>([T? result]) =>
      navigator.maybePop<T>(result);

  bool get canPop => navigator.canPop;
}

class FadeInRoute<T> extends MaterialPageRoute<T> {
  FadeInRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return FadeTransition(opacity: animation, child: child);
  }
}

class TransparentRoute<T> extends PageRoute<T> {
  TransparentRoute({
    required this.builder,
    super.settings,
  }) : super(fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => true;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0.0, -1.0),
            ).animate(secondaryAnimation),
            child: result,
          ),
        ),
      ),
    );
  }
}

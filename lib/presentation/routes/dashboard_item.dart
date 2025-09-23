import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///para hacerlo que los child tengan una lista tambien de childs (en ese caso el PageData la lista de childs seria de tipo PageData)
///hay que hacer una recursividad y no estoy pa eso
class DashboardItem {
  /// The title to show in the side bar menu.
  /// Tiene que ser un builder para que haga la internacionalizacion
  final String Function() title;

  /// The permission tag to show the page according to logged user.
  final String tag;

  /// The icon to show in the side bar menu.
  final IconData icon;

  /// The route name to navigate.
  final String routeName;

  /// The route path to navigate.
  final String routePath;

  /// The route page builder.
  final Widget Function(BuildContext, GoRouterState) pageBuilder;

  /// The parent navigation key.
  final GlobalKey<NavigatorState>? parentNavigatorKey;

  /// The child pages of this route.
  final List<DashboardChildItem> pageChilds;

  ///rutas internas del shell que no son un item del dashboard
  ///ejemplo: los detalles de una orgia (orgias/detalles/5), que se visualiza dentro del shell, pero no tiene un tab en el dashboard
  final List<GoRoute> internalRouteChilds;

  const DashboardItem({
    required this.title,
    required this.tag,
    required this.icon,
    required this.routeName,
    required this.routePath,
    required this.pageBuilder,
    this.parentNavigatorKey,
    this.pageChilds = const [],
    this.internalRouteChilds = const [],
  });
}

class DashboardChildItem {
  /// The title to show in the side bar menu.
  /// Tiene que ser un builder para que haga la internacionalizacion
  final String Function() title;

  /// The permission tag to show the page according to logged user.
  final String tag;

  /// The route name to navigate.
  final String routeName;

  /// The route path to navigate.
  final String routePath;

  /// The route page builder.
  final Widget Function(BuildContext, GoRouterState) pageBuilder;

  /// The parent navigation key.
  final GlobalKey<NavigatorState>? parentNavigatorKey;

  ///rutas internas del shell que no son un item del dashboard
  ///ejemplo: los detalles de un usuario activo (usuario/activos/detalles/5), que se visualiza dentro del shell, pero no tiene un tab en el dashboard
  final List<GoRoute> internalRouteChilds;

  const DashboardChildItem({
    required this.title,
    required this.tag,
    required this.routeName,
    required this.routePath,
    required this.pageBuilder,
    this.parentNavigatorKey,
    this.internalRouteChilds = const [],
  });
}

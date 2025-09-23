import 'package:book_store_admin/presentation/app/constants/constants.dart';
import 'package:book_store_admin/presentation/bindings/add_entities/add_edit_book_binding.dart';
import 'package:book_store_admin/presentation/bindings/home_binding.dart';
import 'package:book_store_admin/presentation/bindings/login_register/register_page_binding.dart';
import 'package:book_store_admin/presentation/bindings/login_register/create_library_binding.dart';
import 'package:book_store_admin/presentation/bindings/login_register/create_or_change_password_bindig.dart';
import 'package:book_store_admin/presentation/bindings/login_register/sign_in_page_binding.dart';
import 'package:book_store_admin/presentation/bindings/splash_binding.dart';
import 'package:book_store_admin/presentation/controllers/user_controller.dart';
import 'package:book_store_admin/presentation/pages/errors/error_401.dart';
import 'package:book_store_admin/presentation/pages/errors/error_404.dart';
import 'package:book_store_admin/presentation/pages/home/home_page.dart';
import 'package:book_store_admin/presentation/pages/home/home_pages/books/add_edit_book/add_edit_book_page.dart';
import 'package:book_store_admin/presentation/pages/login_register/create_library_page.dart';
import 'package:book_store_admin/presentation/pages/login_register/register_page.dart';
import 'package:book_store_admin/presentation/pages/login_register/create_or_change_password_page.dart';
import 'package:book_store_admin/presentation/pages/login_register/sign_in_page.dart';
import 'package:book_store_admin/presentation/pages/splash/splash_page.dart';
import 'package:book_store_admin/presentation/routes/dashboard_items_config_admin.dart';
import 'package:book_store_admin/presentation/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RouteConfig {
  static final RouterConfig<Object> router = GoRouter(
    initialLocation: '/${Routes.home}',
    redirect: (BuildContext context, GoRouterState state) async {
      debugPrint('🔄 Redirect called for: ${state.fullPath}');

      final UserController userController = Get.find<UserController>();

      // Wait for the initial authentication check to complete
      if (!userController.isAuthCheckComplete) {
        await userController.authCheckFinished;
      }

      // Define public routes that don't require authentication
      final publicRoutes = {
        '/${Routes.home}', // splash page
        '/${Routes.signIn}',
        '/${Routes.forgotPassword}',
        '/${Routes.register}',
        '/${Routes.createPassword}',
        '/${Routes.unauthorized}',
        '/${Routes.pageNotFound}',
      };

      // If user is not logged in
      if (!userController.isLoggedIn) {
        debugPrint('👤 User not logged in');

        // If on splash page, let it handle the navigation
        if (state.matchedLocation == Routes.home) {
          debugPrint('🚀 On splash page, continuing...');
          return null;
        }

        // If trying to access a public route, allow it
        if (publicRoutes.contains(state.fullPath)) {
          debugPrint('✅ Accessing public route: ${state.fullPath}');
          return null;
        }

        // Otherwise redirect to sign in
        debugPrint('↩️ Redirecting to sign in');
        return '/${Routes.signIn}';
      }

      // User is logged in, check if user profile is loaded
      if (userController.userProfile == null) {
        await userController.setUserProfile(null, null);
      }

      // Check if user is admin
      final bool isAdmin = userController.userProfile?.get(
            'isAdmin',
            defaultValue: false,
          ) ??
          false;

      debugPrint('👑 User is admin: $isAdmin');

      // If user is admin
      if (isAdmin) {
        // There is no library associated with the user
        if (userController.library == null) {
          return '/${Routes.createLibrary}';
        }

        // If admin is on unauthorized page, redirect to home dashboard
        if (state.fullPath == '/${Routes.unauthorized}') {
          debugPrint('↩️ Admin redirecting from unauthorized to dashboard');
          // Redirect to first dashboard item instead of splash
          if (DashboardItemsConfigAdmin.items.isNotEmpty) {
            return DashboardItemsConfigAdmin.items.first.routePath;
          }
          return Routes.dashboard;
        }

        // If admin is on splash, redirect to dashboard
        if (state.matchedLocation == Routes.home) {
          debugPrint('🏠 Admin on splash, redirecting to dashboard');
          if (DashboardItemsConfigAdmin.items.isNotEmpty) {
            return DashboardItemsConfigAdmin.items.first.routePath;
          }
        }

        return null;
      }

      // User is not admin
      debugPrint('🚫 User is not admin');

      // If trying to access unauthorized page, allow it
      if (state.fullPath == '/${Routes.unauthorized}') {
        return null;
      }

      // If trying to access public routes, allow it
      if (publicRoutes.contains(state.fullPath)) {
        return null;
      }

      // Otherwise redirect to unauthorized
      debugPrint('↩️ Redirecting to unauthorized');
      return '/${Routes.unauthorized}';
    },
    navigatorKey: navigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          HomeBinding.init();
          return HomePage(navigationShell: navigationShell);
        },
        branches: [
          ...DashboardItemsConfigAdmin.items.map(
            (pageConfig) {
              return StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    name: pageConfig.routeName,
                    path: pageConfig.routePath,
                    builder: pageConfig.pageBuilder,
                    routes: [
                      ...pageConfig.pageChilds.map(
                        (child) => GoRoute(
                          name: child.routeName,
                          path: child.routePath,
                          builder: child.pageBuilder,
                          routes: child.internalRouteChilds,
                        ),
                      ),
                      ...pageConfig.internalRouteChilds,
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),

      ///------------------------ splash ------------------------\\\
      ///   /splash
      GoRoute(
        name: Routes.home,
        path: '/${Routes.home}',
        builder: (context, state) {
          SplashBinding.init();
          return const SplashPage();
        },
      ),

      ///------------------------ login ------------------------\\\
      ///   /login
      GoRoute(
        name: Routes.signIn,
        path: '/${Routes.signIn}',
        builder: (context, state) {
          SignInPageBinding.init();
          return const SignInPage();
        },
      ),

      ///------------------------ forgot-password ------------------------\\\
      ///   /forgot-password
      /*  GoRoute(
        name: Routes.forgotPassword,
        path: '/${Routes.forgotPassword}',
        builder: (context, state) {
          ForgotPasswordBinding.init();
          return const ForgotPasswordPage();
        },
      ), */

      ///------------------------ register ------------------------\\\
      ///   /register
      GoRoute(
        name: Routes.register,
        path: '/${Routes.register}',
        builder: (context, state) {
          RegisterPageBinding.init();
          return const RegisterPage();
        },
      ),

      ///   /create-password
      GoRoute(
        name: Routes.createPassword,
        path: '/${Routes.createPassword}',
        builder: (context, state) {
          CreateOrChangePasswordBinding.init(
            state: state,
          );
          return const CreateOrChangePasswordPage();
        },
      ),

      ///   /create-library
      GoRoute(
        name: Routes.createLibrary,
        path: '/${Routes.createLibrary}',
        builder: (context, state) {
          CreateLibraryBinding.init(state);
          return const CreateLibraryPage();
        },
      ),

      ///------------------------ dashboard-inner-routes ------------------------\\\
      ///   /add-book
      GoRoute(
        name: Routes.createBook,
        path: '/${Routes.createBook}',
        builder: (context, state) {
          AddEditBookBinding.init(state);
          return const AddEditBookPage();
        },
      ),

      ///   /edit-book
      GoRoute(
        name: Routes.editBook,
        path: '/${Routes.editBook}',
        builder: (context, state) {
          AddEditBookBinding.init(state);
          return const AddEditBookPage();
        },
      ),

      ///------------------------ no access ------------------------\\\
      ///   /unauthorized
      GoRoute(
        name: Routes.unauthorized,
        path: '/${Routes.unauthorized}',
        builder: (context, state) {
          return const Error401();
        },
      ),

      ///   /page-not-found
      GoRoute(
        name: Routes.pageNotFound,
        path: '/${Routes.pageNotFound}',
        builder: (context, state) {
          return const Error404();
        },
      ),
    ],
  );
}

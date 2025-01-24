import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app_arq/data/repositories/auth/auth_repository.dart';
import 'package:tasks_app_arq/routing/routes.dart';
import 'package:tasks_app_arq/ui/home/view_models/home_viewmodel.dart';
import 'package:tasks_app_arq/ui/home/widgets/home_screen.dart';
import 'package:tasks_app_arq/ui/login/view_models/login_viewmodel.dart';
import 'package:tasks_app_arq/ui/login/widgets/login_screen.dart';

GoRouter router(
  AuthRepository authRepository,
) =>
    GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      redirect: _redirect,
      refreshListenable: authRepository,
      routes: [
        GoRoute(
          path: Routes.login,
          builder: (context, state) => LoginScreen(
            viewModel: LoginViewModel(
              authRepository: context.read(),
              userRepository: context.read(),
            ),
          ),
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) => HomeScreen(
            viewModel: HomeViewModel(),
          ),
        ),
      ],
    );

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.login;
  if (!loggedIn) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to
  // the home page
  if (loggingIn) {
    return Routes.home;
  }

  // no need to redirect at all
  return null;
}

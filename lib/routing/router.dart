import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app_arq/data/repositories/auth/auth_repository.dart';

GoRouter router(
  AuthRepository authRepository,
) =>
    GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      redirect: _redirect,
      refreshListenable: authRepository,
      routes: [],
    );

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == '/login';
  if (!loggedIn) {
    return '/login';
  }

  // if the user is logged in but still on the login page, send them to
  // the home page
  if (loggingIn) {
    return '/';
  }

  // no need to redirect at all
  return null;
}

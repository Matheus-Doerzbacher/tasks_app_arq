import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tasks_app_arq/data/repositories/auth/auth_repository.dart';
import 'package:tasks_app_arq/data/repositories/auth/auth_repository_remote.dart';
import 'package:tasks_app_arq/data/repositories/user/user_repository.dart';
import 'package:tasks_app_arq/data/repositories/user/user_repository_remote.dart';
import 'package:tasks_app_arq/data/services/firebase/auth/auth_firebase_client.dart';
import 'package:tasks_app_arq/data/services/firebase/user/user_firebase_client.dart';
import 'package:tasks_app_arq/data/services/shared_preferences_service.dart';

List<SingleChildWidget> get providers {
  return [
    // SERVICES
    Provider(
      create: (context) => AuthFirebaseClient(),
    ),
    Provider(
      create: (context) => SharedPreferencesService(),
    ),
    Provider(
      create: (context) => UserFirebaseClient(),
    ),

    // REPOSITORIES
    ChangeNotifierProvider(
      create: (context) => AuthRepositoryRemote(
        authFirebaseClient: context.read(),
        sharedPreferencesService: context.read(),
      ) as AuthRepository,
    ),
    Provider(
      create: (context) => UserRepositoryRemote(
        userFirebaseClient: context.read(),
      ) as UserRepository,
    ),
  ];
}

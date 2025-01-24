import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tasks_app_arq/data/repositories/auth/auth_repository.dart';
import 'package:tasks_app_arq/data/repositories/auth/auth_repository_remote.dart';
import 'package:tasks_app_arq/data/repositories/task/task_repository.dart';
import 'package:tasks_app_arq/data/repositories/task/task_repository_remote.dart';
import 'package:tasks_app_arq/data/repositories/user/user_repository.dart';
import 'package:tasks_app_arq/data/repositories/user/user_repository_remote.dart';
import 'package:tasks_app_arq/data/services/firebase/task/task_firebase_client.dart';
import 'package:tasks_app_arq/data/services/firebase/user/user_firebase_client.dart';
import 'package:tasks_app_arq/data/services/shared_preferences_service.dart';

List<SingleChildWidget> get providers {
  return [
    // SERVICES
    Provider(
      create: (context) => SharedPreferencesService(),
    ),
    Provider(
      create: (context) => UserFirebaseClient(),
    ),
    Provider(
      create: (context) => TaskFirebaseClient(),
    ),

    // REPOSITORIES
    ChangeNotifierProvider(
      create: (context) => AuthRepositoryRemote(
        userFirebaseClient: context.read(),
        sharedPreferencesService: context.read(),
      ) as AuthRepository,
    ),
    Provider(
      create: (context) => UserRepositoryRemote(
        userFirebaseClient: context.read(),
      ) as UserRepository,
    ),
    Provider(
      create: (context) => TaskRepositoryRemote(
        taskFirebaseClient: context.read(),
      ) as TaskRepository,
    ),
  ];
}

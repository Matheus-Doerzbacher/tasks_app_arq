import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tasks_app_arq/data/repositories/auth/auth_repository_remote.dart';
import 'package:tasks_app_arq/data/services/firebase/user/user_firebase_client.dart';
import 'package:tasks_app_arq/data/services/shared_preferences_service.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (context) => UserFirebaseClient(),
    ),
    Provider(
      create: (context) => SharedPreferencesService(),
    ),
    ChangeNotifierProvider(
      create: (context) => AuthRepositoryRemote(
        userFirebaseClient: context.read(),
        sharedPreferencesService: context.read(),
      ),
    )
  ];
}

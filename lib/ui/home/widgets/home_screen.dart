import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app_arq/ui/home/view_models/home_viewmodel.dart';
import 'package:tasks_app_arq/ui/user/logout/view_models/logout_viewmodel.dart';
import 'package:tasks_app_arq/ui/user/logout/widgets/logout_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          LogoutButton(
            viewModel: LogoutViewModel(
              authRepository: context.read(),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(widget.viewModel.user?.name ?? 'Not User'),
      ),
    );
  }
}

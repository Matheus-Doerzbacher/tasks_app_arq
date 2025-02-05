import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app_arq/domain/models/task/task.dart';
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
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.deleteTask.addListener(_onResultDelete);
    widget.viewModel.addTask.addListener(_onResultAdd);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.deleteTask.removeListener(_onResultDelete);
    oldWidget.viewModel.addTask.removeListener(_onResultAdd);
    widget.viewModel.deleteTask.addListener(_onResultDelete);
    widget.viewModel.addTask.addListener(_onResultAdd);
  }

  @override
  void dispose() {
    _taskController.dispose();
    widget.viewModel.deleteTask.removeListener(_onResultDelete);
    widget.viewModel.addTask.removeListener(_onResultAdd);
    super.dispose();
  }

  Future<void> _addTask() async {
    if (_taskController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tarefa não pode ser vazia'),
        ),
      );
      return;
    }
    await widget.viewModel.addTask.execute(
      Task(
        description: _taskController.text,
        userId: widget.viewModel.user?.id ?? '',
        createdDate: DateTime.now(),
      ),
    );
    _taskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tarefas'),
        actions: [
          LogoutButton(
            viewModel: LogoutViewModel(
              authRepository: context.read(),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(widget.viewModel.user?.name ?? 'Not User'),
                ListenableBuilder(
                  listenable: widget.viewModel.addTask,
                  builder: (context, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _taskController,
                            onSubmitted: (_) => _addTask(),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _addTask,
                          child: widget.viewModel.addTask.running
                              ? const Text("Adicionando...")
                              : const Text('Add'),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (context, _) {
                    final loadCommand = widget.viewModel.load;
                    if (loadCommand.running) {
                      return const CircularProgressIndicator();
                    }

                    if (loadCommand.error) {
                      loadCommand.clearResult();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          content: Text('Erro ao carregar tarefas'),
                        ),
                      );
                      return const SizedBox.shrink();
                    }

                    return widget.viewModel.tasks.isEmpty
                        ? const SizedBox.shrink()
                        : Expanded(
                            child: ListView.builder(
                              itemCount: widget.viewModel.tasks.length,
                              itemBuilder: (context, index) => ListTile(
                                title: Row(
                                  children: [
                                    Checkbox(
                                      value: widget
                                          .viewModel.tasks[index].isFinish,
                                      onChanged: (bool? value) {
                                        widget.viewModel.finishTask.execute(
                                          widget.viewModel.tasks[index],
                                        );
                                      },
                                    ),
                                    Text(
                                      widget.viewModel.tasks[index].description,
                                      style: TextStyle(
                                        color: widget
                                                .viewModel.tasks[index].isFinish
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 100)
                                            : null,
                                        decoration: widget
                                                .viewModel.tasks[index].isFinish
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Text('Deletar'),
                                          const SizedBox(width: 8),
                                          Icon(Icons.delete),
                                        ],
                                      ),
                                      onTap: () =>
                                          widget.viewModel.deleteTask.execute(
                                        widget.viewModel.tasks[index].id ?? '',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onResultDelete() {
    if (widget.viewModel.deleteTask.completed) {
      widget.viewModel.deleteTask.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tarefa deletada'),
        ),
      );
    }

    if (widget.viewModel.deleteTask.error) {
      widget.viewModel.deleteTask.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao deletar tarefa'),
        ),
      );
    }
  }

  void _onResultAdd() {
    if (widget.viewModel.addTask.completed) {
      widget.viewModel.addTask.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tarefa adicionada'),
        ),
      );
    }

    if (widget.viewModel.addTask.error) {
      widget.viewModel.addTask.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar tarefa'),
        ),
      );
    }
  }
}

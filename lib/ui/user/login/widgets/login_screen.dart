import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasks_app_arq/domain/models/user/user.dart';
import 'package:tasks_app_arq/routing/routes.dart';
import 'package:tasks_app_arq/ui/core/exception_message.dart';
import 'package:tasks_app_arq/ui/user/login/view_models/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formLogin = GlobalKey<FormState>();
  final GlobalKey<FormState> _formSignUp = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.viewModel.login.addListener(_onResultLogin);
    widget.viewModel.createUser.addListener(_onResultCreateUser);
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.login.removeListener(_onResultLogin);
    widget.viewModel.login.addListener(_onResultLogin);
    oldWidget.viewModel.createUser.removeListener(_onResultCreateUser);
    widget.viewModel.createUser.addListener(_onResultCreateUser);
  }

  @override
  void dispose() {
    widget.viewModel.login.removeListener(_onResultLogin);
    widget.viewModel.createUser.removeListener(_onResultCreateUser);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _buildLoginPage(),
          _buildSignUpPage(),
        ],
      ),
    );
  }

  Widget _buildLoginPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formLogin,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset('assets/images/task.png', width: 400),
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email é obrigatório';
                  }

                  if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha é obrigatório';
                  }

                  if (value.length < 6) {
                    return 'Senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ListenableBuilder(
                listenable: widget.viewModel.login,
                builder: (context, _) {
                  return FilledButton(
                    onPressed: widget.viewModel.login.running
                        ? null
                        : () {
                            if (_formLogin.currentState!.validate()) {
                              widget.viewModel.login.execute(
                                (_email.value.text, _password.value.text),
                              );
                            }
                          },
                    child: widget.viewModel.login.running
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Login'),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _pageController.animateToPage(
                    1, // Índice da página de criação de conta
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  'Criar uma conta',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formSignUp,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset('assets/images/user.png', width: 400),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email é obrigatório';
                  }

                  if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }

                  if (value.length < 3) {
                    return 'Nome deve ter pelo menos 3 caracteres';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha é obrigatório';
                  }

                  if (value.length < 6) {
                    return 'Senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPassword,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha é obrigatório';
                  }

                  if (value != _password.value.text) {
                    return 'As senhas não correspondem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ListenableBuilder(
                listenable: widget.viewModel.createUser,
                builder: (context, _) {
                  return FilledButton(
                    onPressed: widget.viewModel.createUser.running
                        ? null
                        : () {
                            if (_formSignUp.currentState!.validate()) {
                              final user = User(
                                email: _email.value.text,
                                name: _name.value.text,
                                password: _password.value.text,
                              );
                              widget.viewModel.createUser.execute(user);
                              _name.clear();
                              _password.clear();
                              _confirmPassword.clear();
                              _pageController.animateToPage(
                                0, // Índice da página de criação de conta
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Usuário criado com sucesso'),
                                ),
                              );
                            }
                          },
                    child: widget.viewModel.createUser.running
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Criar conta'),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _pageController.animateToPage(
                    0, // Índice da página de criação de conta
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  'Já tem uma conta? Faça login',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onResultLogin() {
    if (widget.viewModel.login.completed) {
      widget.viewModel.login.clearResult();
      context.go(Routes.home);
    }

    if (widget.viewModel.login.error) {
      widget.viewModel.login.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ExceptionMessage.message(widget.viewModel.errorMsg!)),
          action: SnackBarAction(
            label: 'Tente novamente',
            onPressed: () => widget.viewModel.login
                .execute((_email.value.text, _password.value.text)),
          ),
        ),
      );
    }
  }

  void _onResultCreateUser() {
    if (widget.viewModel.createUser.error) {
      widget.viewModel.createUser.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ExceptionMessage.message(widget.viewModel.errorMsg!)),
        ),
      );
    }
  }
}

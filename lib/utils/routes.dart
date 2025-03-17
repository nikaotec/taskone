import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taskone/models/task.dart';
import 'package:taskone/screens/setttings_screens.dart';
import 'package:taskone/screens/task_details_screen.dart';
import 'package:taskone/screens/task_list.dart';
import 'package:taskone/screens/tasks/schedule_manage_task.dart';
import 'package:taskone/screens/tasks/task_form_screen.dart';
import 'package:taskone/screens/teste.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../providers/auth_provider.dart';

final GoRouter router = GoRouter(
  routes: [
    // Rota inicial (verifica se o usuário está logado)
    GoRoute(
      path: '/',
      redirect: (context, state) async {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final isLoggedIn = await authProvider.checkIfUserIsLoggedIn();
        return isLoggedIn ? '/home' : '/login';
      },
    ),
    // Tela de login
    GoRoute(path: '/login', builder: (context, state) =>  LoginScreen()),
    // Tela de cadastro
    GoRoute(path: '/signup', builder: (context, state) =>  SignupScreen()),
    // Tela principal (HomeScreen)
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    // Tela de adição de tarefas
    GoRoute(
      path: '/add-task',
      builder: (context, state) => const TaskFormScreen(),
    ),
    // Tela de detalhes da tarefa
    GoRoute(
      path: '/task-detail',
      builder: (context, state) {
        final task =
            state.extra as Task; // Recupera o objeto Task passado como extra
        return TaskDetailsScreen(taskId: task.id);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    
     GoRoute(path: '/task-list', builder: (context, state) => TaskList()),

     GoRoute(path: '/teste', builder: (context, state) => Teste()),
      GoRoute(path: '/schedule', builder: (context, state) => ScheduleManageTask()),
  ],
 // errorBuilder: (context, state) => const ErrorScreen(), // Tela de erro
);

//importamos GoRouter para manejar las rutas de navegación en la aplicación
import 'package:chocomil_movies_app_bv/presentation/screens/auth/register_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/screens.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/auth/login_screen.dart';// Ajusta el nombre exacto de tu archivo

//Usar GoRouter nos ayuda a que nosotros no tengamos que hacer configuraciones especiales si lo queremos en la web
final appRouter = GoRouter
(
  // Cambiamos temporalmente la ruta inicial para ver la pantalla de registro al compilar
  initialLocation: '/login',

  //lista de rutas disponibles en la App
  routes: 
  [
    GoRoute(
      //URL de la ruta
      path: '/',
      //Nombre de la ruta (Util para la navegación)
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder:(context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
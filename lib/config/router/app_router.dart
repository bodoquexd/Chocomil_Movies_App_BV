//importamos GoRouter para manejar las rutas de navegación en la aplicación
import 'package:chocomil_movies_app_bv/presentation/screens/register.dart';
import 'package:go_router/go_router.dart';
import 'package:chocomil_movies_app_bv/presentation/screens/screens.dart';// Ajusta el nombre exacto de tu archivo

//Usar GoRouter nos ayuda a que nosotros no tengamos que hacer configuraciones especiales si lo queremos en la web
final appRouter = GoRouter
(
  // Cambiamos temporalmente la ruta inicial para ver la pantalla de registro al compilar
  initialLocation: '/register',

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
      path: '/register',
      name: 'register_screen', // Puedes definir un String o usar una variable estática como en HomeScreen
      builder: (context, state) => const Register(),
    ),
  ],
);
//importamos GoRouter para manejar las rutas de navegación en la aplicación
import 'package:go_router/go_router.dart';
import 'package:movies_app_bv/presentation/screens/movies/home_screen.dart';

//Usar GoRouter nos ayuda a que nosotros no tengamos que hacer configuraciones especiales si lo queremos en la web
final appRouter = GoRouter
(
  //pantallas inicial de la App
  initialLocation: '/',

  //lista de rutas disponibles en la App
  routes: 
  [
    
    GoRoute(
      //URL de la ruta
      path: '/',
      //Nombre de la ruta (Util para la navegación)
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    )
  ],
);
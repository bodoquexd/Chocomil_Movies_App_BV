//En el datasources definimos como queremos que sea nuestros origenes de datos

//Clase abstracta porque no quiero crear instancias de ella
//Definimos como luce el origen de los datos que vamos a obtener
//Definir metodos para obtener la data

//ORIGEN DE DATOS
/*import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';

abstract class MovieDatasources 
{
  Future<List<Movie>> getTrending({int page = 1});
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1});
}
*/
import 'package:chocomil_movies_app_bv/domain/entities/movie_entities.dart';

abstract class MovieDatasources {
  Future<List<Movie>> getTrending({int page = 1});

  Future<List<Movie>> getMoviesByGenre(
    int genreId, {
    int page = 1,
  });

  Future<List<Movie>> searchMovies(
    String query, {
    int page = 1,
  });
}

//https://www.themoviedb.org/
//https://developer.themoviedb.org/docs/getting-started
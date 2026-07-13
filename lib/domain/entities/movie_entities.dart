// Primera estructura de datos de nuestra aplicacion, la forma en que nosotros lo definimos
// Esto es lo que utilizaremos, no lo que venga directamente de una API

class Movie {
  final bool adult;
  final String backdropPath;
  final List<String> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
  final String? logoPath;

  Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    this.logoPath,
  });

  // Convertir JSON a Película al leer de SharedPreferences
  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    adult: json['adult'] ?? false,
    backdropPath: json['backdropPath'] ?? '',
    genreIds: List<String>.from(json['genreIds'] ?? []),
    id: json['id'] ?? 0,
    originalLanguage: json['originalLanguage'] ?? '',
    originalTitle: json['originalTitle'] ?? '',
    overview: json['overview'] ?? '',
    popularity: (json['popularity'] ?? 0.0).toDouble(),
    posterPath: json['posterPath'] ?? '',
    releaseDate: json['releaseDate'] != null
        ? DateTime.parse(json['releaseDate'])
        : DateTime.now(),
    title: json['title'] ?? '',
    video: json['video'] ?? false,
    voteAverage: (json['voteAverage'] ?? 0.0).toDouble(),
    voteCount: json['voteCount'] ?? 0,
    logoPath: json['logoPath'],
  );

  Map<String, dynamic> toJson() => {
    'adult': adult,
    'backdropPath': backdropPath,
    'genreIds': genreIds,
    'id': id,
    'originalLanguage': originalLanguage,
    'originalTitle': originalTitle,
    'overview': overview,
    'popularity': popularity,
    'posterPath': posterPath,
    'releaseDate': releaseDate.toIso8601String(),
    'title': title,
    'video': video,
    'voteAverage': voteAverage,
    'voteCount': voteCount,
    'logoPath': logoPath,
  };
}

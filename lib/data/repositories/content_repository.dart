import '../models/comment.dart';
import '../models/movie.dart';
import '../models/search_result.dart';
import '../models/season.dart';
import '../models/show.dart';

abstract class ContentRepository {
  Future<List<Show>> getShows();

  Future<Show?> getShow(String id);

  Future<List<Movie>> getMovies();

  Future<Movie?> getMovie(String id);

  Future<Season?> getSeason(String showId, int seasonNumber);

  Future<List<Comment>> getComments();

  Future<List<SearchResult>> search(String query);
}

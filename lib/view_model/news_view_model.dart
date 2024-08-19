import 'package:newsapp/models/categories_news_model.dart';
import 'package:newsapp/models/news_channels_headlines_model.dart';
import 'package:newsapp/repository/news_repository.dart';

class NewsViewModel{
  final _rep = NewsRepository();
  Future<NewsChannelsHeadlinesModel> fetchnewschannelheadlinesAPI(String channelName) async {
       final response = await _rep.fetchnewschannelheadlinesAPI(channelName);
       return response;
  }
  Future<CategoriesNewsModel> fetchcategoriesnewsAPI(String category) async {
       final response = await _rep.fetchcategoriesnewsAPI(category);
       return response;
  }
}
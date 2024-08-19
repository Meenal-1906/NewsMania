import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/models/categories_news_model.dart';
import 'package:newsapp/models/news_channels_headlines_model.dart';

class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetchnewschannelheadlinesAPI(String channelName) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=5d42aa57b1aa41a3b74561a5d439ac63';
    final response = await http.get(Uri.parse(url));

    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoriesNewsModel> fetchcategoriesnewsAPI(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=5d42aa57b1aa41a3b74561a5d439ac63';
    final response = await http.get(Uri.parse(url));

    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }
}

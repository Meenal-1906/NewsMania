import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/models/categories_news_model.dart';
import 'package:newsapp/models/news_channels_headlines_model.dart';
import 'package:newsapp/view/categories_screen.dart';
import 'package:newsapp/view/news_detail_screen.dart';
import 'package:newsapp/view_model/news_view_model.dart';

enum FilterList {
  bbcNews,
  abcNews,
  bbcSportNews,
  cnnNews,
  googleNews,
  hinduNews,
  nationalGeographicNews,
  timesofIndiaNews
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd yyyy');
  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoriesScreen(),
              ),
            );
          },
          icon: Image.asset('images/category_icon.png'),
        ),
        title: Text(
          'NewsNexus',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (FilterList item) {
              setState(() {
                selectedMenu = item;
                // Changes start here
                switch (item) {
                  case FilterList.bbcNews:
                    name = 'bbc-news';
                    break;
                  case FilterList.abcNews:
                    name = 'abc-news';
                    break;
                  case FilterList.bbcSportNews:
                    name = 'bbc-sport';
                    break;
                  case FilterList.cnnNews:
                    name = 'cnn';
                    break;
                  case FilterList.googleNews:
                    name = 'google-news';
                    break;
                  case FilterList.hinduNews:
                    name = 'the-hindu';
                    break;
                  case FilterList.nationalGeographicNews:
                    name = 'national-geographic';
                    break;
                  case FilterList.timesofIndiaNews:
                    name = 'the-times-of-india';
                    break;
                }
                // Changes end here
              });
            },
            itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem(
                value: FilterList.bbcNews,
                child: Text('BBC News'),
              ),
              PopupMenuItem(
                value: FilterList.abcNews,
                child: Text('ABC News'),
              ),
              PopupMenuItem(
                value: FilterList.bbcSportNews,
                child: Text('BBC Sport'),
              ),
              PopupMenuItem(
                value: FilterList.cnnNews,
                child: Text('CNN News'),
              ),
              PopupMenuItem(
                value: FilterList.googleNews,
                child: Text('Google News'),
              ),
              PopupMenuItem(
                value: FilterList.hinduNews,
                child: Text('The Hindu News'),
              ),
              PopupMenuItem(
                value: FilterList.nationalGeographicNews,
                child: Text('National Geographic'),
              ),
              PopupMenuItem(
                value: FilterList.timesofIndiaNews,
                child: Text('The Times of India'),
              ),
            ],
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: newsViewModel.fetchnewschannelheadlinesAPI(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    // Changes start here
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(
                            snapshot.data!.articles![index].publishedAt
                                .toString(),
                          );
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return NewsDetailScreen(
                                    newsImage: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    newsTitle: snapshot
                                        .data!.articles![index].title
                                        .toString(),
                                    newsDate: snapshot
                                        .data!.articles![index].publishedAt
                                        .toString(),
                                    author: snapshot
                                        .data!.articles![index].author
                                        .toString(),
                                    description: snapshot
                                        .data!.articles![index].description
                                        .toString(),
                                    content: snapshot
                                        .data!.articles![index].content
                                        .toString(),
                                    source: snapshot
                                        .data!.articles![index].source!.name
                                        .toString());
                              }));
                            },
                            child: SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: height * 0.6,
                                    width: width * 0.9,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: height * 0.02,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) {
                                          return Container(
                                            child: spinkit2,
                                          );
                                        },
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    child: Card(
                                      elevation: 5,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        alignment: Alignment.bottomCenter,
                                        height: height * 0.22,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: width * 0.7,
                                              child: Text(
                                                snapshot.data!.articles![index]
                                                    .title
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: width * 0.7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!
                                                        .articles![index]
                                                        .source!
                                                        .name
                                                        .toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    format.format(dateTime),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    // Changes end here
                    return Center(
                      child: Text("No data available"),
                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(
              20,
            ),
            child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchcategoriesnewsAPI('General'),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    var articles = snapshot.data!.articles!
                        .where((article) =>
                            article.urlToImage != null &&
                            article.urlToImage!.isNotEmpty)
                        .toList();
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(
                            articles[index].publishedAt.toString(),
                          );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        articles[index].urlToImage.toString(),
                                    fit: BoxFit.cover,
                                    height: height * 0.18,
                                    width: width * 0.3,
                                    placeholder: (context, url) {
                                      return Container(
                                        child: SpinKitCircle(
                                          color: Colors.blue,
                                          size: 50,
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: height * 0.18,
                                    padding: EdgeInsets.only(
                                      left: 15,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          articles[index].title.toString(),
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              articles[index]
                                                  .source!
                                                  .name
                                                  .toString(),
                                              maxLines: 3,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: Text("No data available"),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitCircle(
  color: Colors.amber,
  size: 50,
);

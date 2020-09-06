import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app_imdb/allMostPopularMovies.dart';
import 'package:test_app_imdb/allTopRatedMovies.dart';
import 'package:test_app_imdb/jsonFiles/popularMovies.dart';
import 'package:test_app_imdb/jsonFiles/topRatedMovies.dart';
import 'package:test_app_imdb/selectedMovieBasedOnIDPage.dart';


class HomePage extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  final ScrollController _scrollController = ScrollController();


  Future<PopularMovie> futurePopularMovie;
  Future<TopRatedMovies> futureTopRatedMovie;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 2), ()
    {
      setState(()
      {
        futurePopularMovie = PopularMovie().fetchPopularMovie(1);
      });
    });

    Future.delayed(Duration(seconds: 2), ()
    {
      setState(()
      {
        futureTopRatedMovie = TopRatedMovies().fetchTopRatedMovie(1);
      });
    });
  }

  int selectedIndexTopRated;
  bool clickToExpandTopRatedMovieBool = false;
  int topRatedItemCount;
  int favoriteIndexTopRated;
  bool favoriteBoolIconTopRated = false;

  bool clickToExpandPopularMovieBool = false;
  int selectedIndexPopular;
  int popularItemCount;
  int favoriteIndexPopular;
  bool favoriteBoolIconPopular = false;


  String title = null ?? "Welcome";

  //not pushed
  List<String> popularMoviesTitles = [];
  List<String> popularPosterPath = [];
  List<int> popularMoviesID = [];

  List<String> topRatedMoviesTitles = [];
  List<String> topRatedPosterPath = [];
  List<int> topRatedMoviesID = [];


  @override
  Widget build(BuildContext context)
  {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('MyFavorites').snapshots(),
      builder: (context, snapshot2)
      {
        return Scaffold(
          backgroundColor: Colors.grey,
          resizeToAvoidBottomPadding: false,

          appBar: AppBar(
            title: Text("${title.toString()}"),
            centerTitle: true,
            backgroundColor: Colors.blueGrey,
            elevation: 10.0,
          ),

          body: RefreshIndicator(
            onRefresh: ()
            {
              print("Refresh Done");

              return Future(() => false);
            },
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 25,),
                    Text("Top Rated",
                    style: GoogleFonts.doHyeon(
                      fontSize: 50,),
                    ),

                    FutureBuilder<TopRatedMovies>(
                      future: futureTopRatedMovie,
                      builder: (context,snapshot)
                      {

                        if (snapshot.hasData)
                        {
                          var movieData = snapshot.data;
                          String imageLink = "https://image.tmdb.org/t/p/w600_and_h900_bestv2";
                          topRatedItemCount = movieData.results.length;


                          return SizedBox(
                            height: 408,
                            width: MediaQuery.of(context).size.width,
                            child: PageView.builder(
                              controller: PageController(initialPage: 0, viewportFraction: 0.7),
                              itemBuilder: (BuildContext context, int index)
                              {

                                topRatedMoviesTitles.add(movieData.results[index].title);
                                topRatedMoviesID.add(movieData.results[index].id);
                                topRatedPosterPath.add("${imageLink.toString()}${movieData.results[index].posterPath}");



                                //var bannerMovie = listBanner[index % 7];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      selectedIndexTopRated = index;
                                      print("index: $selectedIndexTopRated");

                                      if(selectedIndexTopRated == index)
                                      {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context)
                                                {
                                                  return SelectedMovieBasedOnID(
                                                    selectedMoviesID: topRatedMoviesID[selectedIndexTopRated],
                                                    selectedMovieTitle: topRatedMoviesTitles[selectedIndexTopRated],
                                                  );
                                                }
                                            )
                                        );
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Container(
                                          color:Colors.blueGrey,
                                          child: Center(
                                              child: Image.network(topRatedPosterPath[index],)
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {print("IndexFavTop: $index");} ,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                              child: Icon(Icons.favorite_border,color: Colors.red,size: 50,)
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 65),
                                              child: RaisedButton(
                                                disabledColor: Colors.red,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.star_border,size: 40,color: Colors.white,),
                                                    SizedBox(width: 20,),
                                                    Text(movieData.results[index].voteAverage.toString(),
                                                      style: GoogleFonts.doHyeon(color: Colors.white,fontSize: 25),),
                                                  ],
                                                ),
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: 5,

                            ),
                            );

                        }
                        if(snapshot.hasError)
                        {
                          return Text("${snapshot.error}");
                        }
                        else
                        {
                          return Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                  child: Center(
                                      child: CircularProgressIndicator())),
                            ),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0,top: 15.0,),
                      child: GestureDetector(
                        onTap: ()
                        {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context)
                              {
                                return AllTopRatedMovies();
                              }),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("View All",
                              style: GoogleFonts.doHyeon(
                                fontSize: 25,),
                            ),
                            Icon(Icons.keyboard_arrow_right,size: 40,),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50,),
                    Text("Most Popular",
                      style: GoogleFonts.doHyeon(
                        fontSize: 50,),
                    ),
                    FutureBuilder<PopularMovie>(
                      future: futurePopularMovie,
                      builder: (context,snapshot)
                      {

                        if (snapshot.hasData)
                        {
                          var movieData = snapshot.data;
                          String imageLink = "https://image.tmdb.org/t/p/w600_and_h900_bestv2/";
                          popularItemCount = movieData.results.length;

                          return SizedBox(
                            height: 408,
                            child: PageView.builder(
                              controller: PageController(initialPage: 0,viewportFraction: 0.7),
                              itemBuilder: (BuildContext context, int index)
                              {

                                popularMoviesTitles.add(movieData.results[index].title);
                                popularMoviesID.add(movieData.results[index].id);
                                popularPosterPath.add("${imageLink.toString()}${movieData.results[index].posterPath}");

                                //var bannerMovie = listBanner[index % 7];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      selectedIndexPopular = index;
                                      print("index: $selectedIndexPopular");

                                      if(selectedIndexPopular == index)
                                      {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context)
                                                {
                                                  return SelectedMovieBasedOnID(
                                                    selectedMoviesID: popularMoviesID[selectedIndexPopular],
                                                    selectedMovieTitle: popularMoviesTitles[selectedIndexPopular],
                                                  );
                                                }
                                            )
                                        );
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Container(
                                          color:Colors.blueGrey,
                                          child: Center(
                                              child: Image.network(popularPosterPath[index],)
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {print("IndexFavPop: $index");} ,
                                          child: Align(
                                              alignment: Alignment.topRight,
                                              child: Icon(Icons.favorite_border,color: Colors.red,size: 50,)
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 65),
                                              child: RaisedButton(
                                                disabledColor: Colors.red,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.star_border,size: 40,color: Colors.white,),
                                                    SizedBox(width: 20,),
                                                    Text(movieData.results[index].voteAverage.toString(),
                                                      style: GoogleFonts.doHyeon(color: Colors.white,fontSize: 25),),
                                                  ],
                                                ),
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: 5,

                            ),
                          );

                        }
                        if(snapshot.hasError)
                        {
                          return Text("${snapshot.error}");
                        }
                        else
                        {
                          return Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                  child: Center(
                                      child: CircularProgressIndicator())),
                            ),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0,top: 15.0,),
                      child: GestureDetector(
                        onTap: ()
                        {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context)
                                {
                                  return AllMostPopularMovies();
                                }),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("View All",
                              style: GoogleFonts.doHyeon(
                                fontSize: 25,),
                            ),
                            Icon(Icons.keyboard_arrow_right,size: 40,),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 25,),


                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  createAlertAfterCancel(BuildContext context)
  {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context)
        {
          return WillPopScope
            (
            onWillPop: () {},
            child: AlertDialog(
              backgroundColor: Colors.red,
              title: Text("Already Favorited".toString(),textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),),
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("BACK",style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.bold),),
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    textColor: Colors.white,
                    onPressed: (){
                      setState(()
                      {
                        Navigator.of(context).pop();
                      });
                    },
                    focusColor: Colors.green,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
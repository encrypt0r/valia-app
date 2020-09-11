import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app_imdb/SearchResultsPage.dart';
import 'package:test_app_imdb/allMostPopularMovies.dart';
import 'package:test_app_imdb/allNowPlayingMovies.dart';
import 'package:test_app_imdb/allNowUpcomingMovies.dart';
import 'package:test_app_imdb/allTopRatedMovies.dart';
import 'package:test_app_imdb/jsonFiles/nowPlayingMovies.dart';
import 'package:test_app_imdb/jsonFiles/popularMovies.dart';
import 'package:test_app_imdb/jsonFiles/topRatedMovies.dart';
import 'package:test_app_imdb/jsonFiles/upcomingMovies.dart';
import 'package:test_app_imdb/selectedMovieBasedOnIDPage.dart';


class HomePage extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  final ScrollController _scrollController = ScrollController();

  TextEditingController _textEditingController = TextEditingController();


  Future<PopularMovie> futurePopularMovie;
  Future<TopRatedMovies> futureTopRatedMovie;
  Future<NowPlayingMovies> futureNowPlayingMovie;
  Future<UpcomingMovies> futureUpcomingMovie;



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

    Future.delayed(Duration(seconds: 2), ()
    {
      setState(()
      {
        futureNowPlayingMovie = NowPlayingMovies().fetchNowPlayingMovies(1);
      });
    });

    Future.delayed(Duration(seconds: 2), ()
    {
      setState(()
      {
        futureUpcomingMovie = UpcomingMovies().fetchNowPlayingMovies(1);
      });
    });
  }

  int selectedIndexTopRated;
  int topRatedItemCount;
  int favoriteIndexTopRated;
  bool favoriteBoolIconTopRated = false;

  int selectedIndexPopular;
  int popularItemCount;
  int favoriteIndexPopular;
  bool favoriteBoolIconPopular = false;

  int selectedIndexNowPlaying;
  int nowPlayingItemCount;
  int favoriteIndexNowPlaying;
  bool favoriteBoolIconNowPlaying = false;

  int selectedIndexUpcoming;
  int upcomingItemCount;
  int favoriteIndexUpcoming;
  bool favoriteBoolIconUpcoming = false;


  String title = null ?? "Welcome";

  //not pushed
  List<String> popularMoviesTitles = [];
  List<String> popularPosterPath = [];
  List<int> popularMoviesID = [];

  List<String> topRatedMoviesTitles = [];
  List<String> topRatedPosterPath = [];
  List<int> topRatedMoviesID = [];

  List<String> nowPlayingMoviesTitles = [];
  List<String> nowPlayingPosterPath = [];
  List<int> nowPlayingMoviesID = [];

  List<String> upcomingMoviesTitles = [];
  List<String> upcomingPosterPath = [];
  List<int> upcomingMoviesID = [];

  String searchString;


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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey,)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)
                          ),
                          labelStyle: GoogleFonts.doHyeon(
                            color: Colors.white,
                            fontSize: 20,
                            decorationColor: Colors.white,
                          ),
                          hintStyle: GoogleFonts.tajawal(
                            color: Colors.white,
                            fontSize: 20,
                            decorationColor: Colors.white,
                          ),
                          labelText: "Search Movie",
                          hintText: "Enter A Movie Name",
                          prefix: Visibility(
                            visible: !(searchString == null || searchString == ""),
                            child: FloatingActionButton(
                              heroTag: "Button1",
                              child: Icon(Icons.cancel),
                              backgroundColor: Colors.transparent,
                              mini: true,
                              elevation: 0,
                              tooltip: "Erase Text",
                              onPressed: (){
                                setState(()
                                {
                                  _textEditingController.clear();
                                  searchString = "";
                                });
                              },
                            ),
                          ),
                          suffix: FloatingActionButton(
                            heroTag: "Button2",
                            child: Icon(Icons.search,color: Colors.white,size: 25,),
                            backgroundColor: searchString == null || searchString == "" ? Colors.transparent:Colors.blueGrey,
                            mini: true,
                            tooltip: "Search",
                            disabledElevation: 0,
                            onPressed: searchString == null || searchString == "" ?
                            null
                                :
                            ()
                            {
                              print(searchString.toLowerCase());
                              String movieNameEncoded = Uri.encodeComponent(searchString);
                              print("movieNameEncoded: $movieNameEncoded");

                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context)
                                      {
                                        return SearchResultsPage(
                                          searchedMovieTitle: movieNameEncoded ,
                                        );
                                      }
                                  )
                              );
                            },
                          ),
                        ),
                        style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontSize: 24,
                          decorationColor: Colors.white,
                        ),
                        onChanged: (val)
                        {
                          setState(()
                          {
                            searchString = val;
                          });
                        },
                        controller: _textEditingController,
                      ),
                    ),

                    SizedBox(height: 25,),
                    Text("Now Playing",
                    style: GoogleFonts.doHyeon(
                      fontSize: 50,),
                    ),
                    FutureBuilder<NowPlayingMovies>(
                      future: futureNowPlayingMovie,
                      builder: (context,snapshot)
                      {

                        if (snapshot.hasData)
                        {
                          var movieData = snapshot.data;
                          String imageLink = "https://image.tmdb.org/t/p/w600_and_h900_bestv2";
                          nowPlayingItemCount = movieData.results.length;


                          return SizedBox(
                            height: 408,
                            width: MediaQuery.of(context).size.width,
                            child: PageView.builder(
                              controller: PageController(initialPage: 0, viewportFraction: 0.7),
                              itemBuilder: (BuildContext context, int index)
                              {

                                nowPlayingMoviesTitles.add(movieData.results[index].title);
                                nowPlayingMoviesID.add(movieData.results[index].id);
                                nowPlayingPosterPath.add("${imageLink.toString()}${movieData.results[index].posterPath}");



                                //var bannerMovie = listBanner[index % 7];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      selectedIndexNowPlaying = index;
                                      print("index: $selectedIndexNowPlaying");

                                      if(selectedIndexNowPlaying == index)
                                      {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context)
                                                {
                                                  return SelectedMovieBasedOnID(
                                                    selectedMoviesID: nowPlayingMoviesID[selectedIndexNowPlaying],
                                                    selectedMovieTitle: nowPlayingMoviesTitles[selectedIndexNowPlaying],
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
                                              child: Image.network(movieData.results[index].posterPath == null ?
                                              "https://www.fcmlindia.com/images/fifty-days-campaign/no-image.jpg"
                                                  :
                                              nowPlayingPosterPath[index],)
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
                                  return AllNowPlayingMovies();
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


                    Text("Upcoming",
                      style: GoogleFonts.doHyeon(
                        fontSize: 50,),
                    ),
                    FutureBuilder<UpcomingMovies>(
                      future: futureUpcomingMovie,
                      builder: (context,snapshot)
                      {

                        if (snapshot.hasData)
                        {
                          var movieData = snapshot.data;
                          String imageLink = "https://image.tmdb.org/t/p/w600_and_h900_bestv2";
                          upcomingItemCount = movieData.results.length;


                          return SizedBox(
                            height: 408,
                            width: MediaQuery.of(context).size.width,
                            child: PageView.builder(
                              controller: PageController(initialPage: 0, viewportFraction: 0.7),
                              itemBuilder: (BuildContext context, int index)
                              {

                                upcomingMoviesTitles.add(movieData.results[index].title);
                                upcomingMoviesID.add(movieData.results[index].id);
                                upcomingPosterPath.add("${imageLink.toString()}${movieData.results[index].posterPath}");



                                //var bannerMovie = listBanner[index % 7];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      selectedIndexUpcoming = index;
                                      print("index: $selectedIndexUpcoming");

                                      if(selectedIndexUpcoming == index)
                                      {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context)
                                                {
                                                  return SelectedMovieBasedOnID(
                                                    selectedMoviesID: upcomingMoviesID[selectedIndexUpcoming],
                                                    selectedMovieTitle: upcomingMoviesTitles[selectedIndexUpcoming],
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
                                              child: Image.network(movieData.results[index].posterPath == null ?
                                              "https://www.fcmlindia.com/images/fifty-days-campaign/no-image.jpg"
                                                  :
                                              upcomingPosterPath[index],)
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
                                  return AllNowUpcomingMovies();
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
                                              child: Image.network(movieData.results[index].posterPath == null ?
                                              "https://www.fcmlindia.com/images/fifty-days-campaign/no-image.jpg"
                                                  :
                                              topRatedPosterPath[index],)
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
                                              child: Image.network(movieData.results[index].posterPath == null ?
                                              "https://www.fcmlindia.com/images/fifty-days-campaign/no-image.jpg"
                                                  :
                                              popularPosterPath[index],)
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
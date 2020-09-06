import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'jsonFiles/SelectedMovieBasedOnID.dart';

class SelectedMovieBasedOnID extends StatefulWidget {

  final int selectedMoviesID;
  final String selectedMovieTitle;


  const SelectedMovieBasedOnID({Key key,this.selectedMoviesID,this.selectedMovieTitle}) : super(key: key);

  @override
  _SelectedMovieBasedOnIDState createState() => _SelectedMovieBasedOnIDState();
}

class _SelectedMovieBasedOnIDState extends State<SelectedMovieBasedOnID> {

  final ScrollController _scrollController = ScrollController();


  var selectedMovieGenres = [];
  String selectedMovieTitle;
  String selectedPosterPath;
  int selectedMoviesID;
  String selectedReleaseDates ;
  String selectedOverview ;
  bool selectedAdult ;
  dynamic selectedVoteAverage ;
  String selectedOriginalLanguage ;
  String selectedBackDropPath ;

  Future<MovieID> futureMovieID;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("MOVIE ID: ${widget.selectedMoviesID} ");
    print("MOVIE TITLE: ${widget.selectedMovieTitle} ");

    Future.delayed(Duration(seconds: 2), ()
    {
      setState(()
      {
        futureMovieID = MovieID().fetchMovieID(widget.selectedMoviesID);
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Padding(
        padding: EdgeInsets.only(
          bottom:
          mediaQuery.padding.bottom == 0 ? 16.0 : mediaQuery.padding.bottom,
        ),
        child: FutureBuilder<MovieID>(
            future: futureMovieID,
            // ignore: missing_return
            builder: (context,snapshot)
            {
              if(snapshot.hasData)
                {
                  String imageLink = "https://image.tmdb.org/t/p/w600_and_h900_bestv2";
                  var movieID = snapshot.data;
                  int lengthOfGenres = movieID.genres.length;

                  for(int i =0; i<lengthOfGenres;i++)
                  {
                    selectedMovieGenres.add(movieID.genres[i].name);
                  }

                  selectedMovieTitle = movieID.title;
                  selectedPosterPath = movieID.posterPath;
                  selectedVoteAverage = movieID.voteAverage;
                  selectedOverview = movieID.overview;
                  selectedOriginalLanguage = movieID.originalLanguage;
                  selectedAdult = movieID.adult;
                  selectedMoviesID = movieID.id;
                  selectedBackDropPath = movieID.backdropPath;
                  selectedReleaseDates = movieID.releaseDate;


                  return Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          BackdropImage(imageLink + selectedPosterPath),
//                          _buildWidgetAppBar(mediaQuery, context),
                          _buildWidgetFloatingActionButton(mediaQuery),
                          _buildWidgetIconBuyAndShare(mediaQuery),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            _buildWidgetTitleMovie(context,selectedMovieTitle),
                            SizedBox(height: 4.0),
                            _buildWidgetGenreMovie(context,selectedMovieGenres,lengthOfGenres),
                            SizedBox(height: 16.0),
                            _buildWidgetRating(),
                            SizedBox(height: 16.0),
                            _buildWidgetShortDescriptionMovie(context,selectedOriginalLanguage,selectedAdult,selectedReleaseDates),
                            SizedBox(height: 16.0),
                            _buildWidgetSynopsisMovie(context,selectedOverview),
                            SizedBox(height: 16.0),
//                            _buildWidgetScreenshots(mediaQuery, context),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              if(snapshot.hasError)
                {
                  Text("PAGE HAS ERROR");
                }else
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

            }
        ),
      ),
    );
  }

  Widget _buildWidgetAppBar(MediaQueryData mediaQuery, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        top: mediaQuery.padding.top == 0 ? 16.0 : mediaQuery.padding.top + 8.0,
        right: 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Image.asset(
              'assets/images/img_netflix_logo.png',
              height: 20.0,
            ),
          ),
          Icon(
            Icons.favorite_border,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetFloatingActionButton(MediaQueryData mediaQuery) {
    return Column(
      children: <Widget>[
        SizedBox(height: mediaQuery.size.height / 1.75),
        Center(
          child: FloatingActionButton(
            onPressed: () {
              // TODO: do something in here
            },
            child: Icon(
              Icons.play_arrow,
              color: Colors.red,
              size: 32.0,
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetIconBuyAndShare(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: mediaQuery.size.height / 1.7,
          ),
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.favorite_border),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.share),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetTitleMovie(BuildContext context,String selectedMovieTitle) {
    return Center(
      child: Text(
        selectedMovieTitle,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }

  Widget _buildWidgetGenreMovie(BuildContext context,List selectedMovieGenres,int lengthOfGenres) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 25,),
          Text('Genres',
            style: Theme.of(context).textTheme.subtitle.merge(
              TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: lengthOfGenres,
            itemBuilder: (context, index)
            {
              return  Column(
                children: [
                  SizedBox(height: 5,),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: selectedMovieGenres[index],
                            style: Theme.of(context).textTheme.subtitle.merge(
                              TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ]
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetRating() {
    return Center(
      child: RatingBar(
        initialRating: 4.0,
        itemCount: 5,
        allowHalfRating: true,
        direction: Axis.horizontal,
        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
        itemBuilder: (BuildContext context, int index) {
          return Icon(
            Icons.star,
            color: Colors.red,
          );
        },
        tapOnlyMode: true,
        itemSize: 24.0,
        unratedColor: Colors.black,
        onRatingUpdate: (rating) {
          /* Nothing to do in here */
        },
      ),
    );
  }

  Widget _buildWidgetShortDescriptionMovie(BuildContext context,String selectedOriginalLanguage,bool selectedAdult,String selectedReleaseDates) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Language\n',
                  style: Theme.of(context).textTheme.subtitle.merge(
                    TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
                TextSpan(
                  text: selectedOriginalLanguage.toUpperCase(),
                  style: Theme.of(context).textTheme.subtitle.merge(
                    TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Release Date\n',
                  style: Theme.of(context).textTheme.subtitle.merge(
                    TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
                TextSpan(
                  text: selectedReleaseDates,
                  style: Theme.of(context).textTheme.subtitle.merge(
                    TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Rated\n',
                  style: Theme.of(context).textTheme.subtitle.merge(
                    TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
                TextSpan(
                  text: selectedAdult == false ?  "PG" : "+18",
                  style: Theme.of(context).textTheme.subtitle.merge(
                    TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetSynopsisMovie(BuildContext context,String selectedOverview) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: Text(
          selectedOverview,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _buildWidgetScreenshots(
      MediaQueryData mediaQuery, BuildContext context) {
    var listScreenshotsMovie = [
      'assets/images/screenshot_1_backdrop_path.jpeg',
      'assets/images/screenshot_2_backdrop_path.jpeg',
      'assets/images/screenshot_3_backdrop_path.jpeg',
      'assets/images/screenshot_4_backdrop_path.jpeg',
      'assets/images/screenshot_5_backdrop_path.jpeg',
    ];
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Screenshots',
                  style: Theme.of(context).textTheme.subhead.merge(
                    TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          width: mediaQuery.size.width,
          height: 100.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: index == listScreenshotsMovie.length - 1 ? 16.0 : 0.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    listScreenshotsMovie[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            itemCount: listScreenshotsMovie.length,
          ),
        ),
      ],
    );
  }
}

class BackdropImage extends StatelessWidget {
  final String backdropPath;

  BackdropImage(this.backdropPath);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return ClipPath(
      child: Image.network(
        backdropPath,
        height: mediaQuery.size.height / 1.5,
        width: mediaQuery.size.width,
        fit: BoxFit.cover,
      ),
      clipper: BottomWaveClipper(),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 80.0);

    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 80.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, size.height - 70.0);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app_imdb/jsonFiles/nowPlayingMovies.dart';
import 'package:test_app_imdb/selectedMovieBasedOnIDPage.dart';

class AllNowPlayingMovies extends StatefulWidget {
  @override
  _AllNowPlayingMoviesState createState() => _AllNowPlayingMoviesState();
}

class _AllNowPlayingMoviesState extends State<AllNowPlayingMovies>
{
  //Future<TopRatedMovies> futureTopRatedMovie;

  final ScrollController scrollController = ScrollController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    Future.delayed(Duration(seconds: 2), ()
//    {
//      setState(()
//      {
//        futureTopRatedMovie = TopRatedMovies().fetchTopRatedMovie(currentPage);
//      });
//    });
  }


  String title = null ?? "Now Playing Movies";


  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      resizeToAvoidBottomPadding: false,

      appBar: AppBar(
        title: Text("${title.toString()}"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        elevation: 10.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              FutureBuilder<NowPlayingMovies>(
                future: NowPlayingMovies().fetchNowPlayingMovies(1),
                builder: (context,snapshot)
                {

                  if (snapshot.hasData)
                  {
//                    var movieData = snapshot.data;
//                    String imageLink = "https://image.tmdb.org/t/p/w600_and_h900_bestv2";
//                    topRatedItemCount = movieData.results.length;


                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: MovieList(NowPlayingMovies1: snapshot.data,),
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
            ],
          ),
        ),
      ),
    );
  }
}

class MovieList extends StatefulWidget {
  final NowPlayingMovies NowPlayingMovies1;

  const MovieList ({this.NowPlayingMovies1, Key key}) : super (key:key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {

  ScrollController scrollController = new ScrollController();
  List<Results> movie;
  int currentPage = 1;

  int selectedIndexNowPlaying;

  bool onNotification(ScrollNotification notification)
  {
    if(notification is ScrollUpdateNotification)
    {
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent)
      {
        print("End Scroll Top Rated");
        NowPlayingMovies().fetchNowPlayingMovies(currentPage + 1).then((val)
        {
          currentPage = val.page;
          setState(()
          {
            movie.addAll(val.results);
          });
        });
      }
    }
    return true;
  }

  @override
  void initState()
  {
    movie = widget.NowPlayingMovies1.results;
    super.initState();
  }
  @override
  void dispose()
  {
    super.dispose();
  }
  @override

  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotification,
      child: ListView.builder(
        itemCount: movie.length,
        controller: scrollController,
        itemBuilder: (BuildContext context, int index)
        {

//                            topRatedMoviesTitles.add(movieData.results[index].title);
//                            topRatedMoviesID.add(movieData.results[index].id);
//                            topRatedPosterPath.add("${imageLink.toString()}${movieData.results[index].posterPath}");



          //var bannerMovie = listBanner[index % 7];

          return Column(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
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
                                  selectedMoviesID: movie[selectedIndexNowPlaying].id,
                                  selectedMovieTitle: movie[selectedIndexNowPlaying].title,
                                );
                              }
                          )
                      );
                    }
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Container(
                        color:Colors.blueGrey,
                        child: Center(
                            child: Image.network(movie[index].posterPath == null ?
                            "https://www.fcmlindia.com/images/fifty-days-campaign/no-image.jpg"
                                :
                            "https://image.tmdb.org/t/p/w600_and_h900_bestv2" + movie[index].posterPath)
                        ),
                      ),
                      GestureDetector(
                        onTap: () {print("IndexFavTop: $index");} ,
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.favorite_border,color: Colors.red,size: 50,)
                        ),
                      ),
                      Container(
                        height: 437,
                        child: Align(
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
                                    Text(movie[index].voteAverage.toString(),
                                      style: GoogleFonts.doHyeon(color: Colors.white,fontSize: 25),),
                                  ],
                                ),
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 100,),
            ],
          );
        },
      ),
    );
  }
}

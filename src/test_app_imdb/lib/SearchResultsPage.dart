import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app_imdb/jsonFiles/searchMovies.dart';
import 'package:test_app_imdb/selectedMovieBasedOnIDPage.dart';

class SearchResultsPage extends StatefulWidget {


  final String searchedMovieTitle;

  const SearchResultsPage({Key key,this.searchedMovieTitle}) : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage>
{

  final ScrollController scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();

  String searchString;

  @override
  void initState() {
    // TODO: implement initState

    setState(()
    {
      _textEditingController.text = Uri.decodeComponent(widget.searchedMovieTitle);
      searchString = Uri.decodeComponent(widget.searchedMovieTitle);
    });
    super.initState();

  }


  String title = null ?? "Search Results";




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
                            searchString = null;
                          });
                        },
                      ),
                    ),
                    suffix: FloatingActionButton(
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
              FutureBuilder<SearchMovies>(
                future: SearchMovies().fetchSearchMovie(widget.searchedMovieTitle,1),
                builder: (context,snapshot)
                {

                  if (snapshot.hasData)
                  {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: MovieList(SearchMovies1: snapshot.data,),
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
  final SearchMovies SearchMovies1;
  const MovieList ({this.SearchMovies1, Key key}) : super (key:key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {

  ScrollController scrollController = new ScrollController();
  List<Results> movie;
  int currentPage = 1;

  int selectedIndexMostPopular;


  bool onNotification(ScrollNotification notification)
  {
    if(notification is ScrollUpdateNotification)
    {
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent)
      {
        print("End Scroll Most Popular");
        SearchMovies().fetchSearchMovie(SearchResultsPage().searchedMovieTitle,currentPage + 1).then((val)
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
    movie = widget.SearchMovies1.results;
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
                    selectedIndexMostPopular = index;
                    print("index: $selectedIndexMostPopular");

                    if(selectedIndexMostPopular == index)
                    {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context)
                              {
                                return SelectedMovieBasedOnID(
                                  selectedMoviesID: movie[selectedIndexMostPopular].id,
                                  selectedMovieTitle: movie[selectedIndexMostPopular].title,
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
                            ("https://www.fcmlindia.com/images/fifty-days-campaign/no-image.jpg")
                                :
                            "https://image.tmdb.org/t/p/w600_and_h900_bestv2${movie[index].posterPath.toString()}",)
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

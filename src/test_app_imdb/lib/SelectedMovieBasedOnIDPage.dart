//import 'package:flutter/material.dart';
//import 'package:test_app_imdb/jsonFiles/SelectedMovieBasedOnID.dart';
//
//
//class SelectedMovieBasedOnID extends StatefulWidget
//{
//
//  final int selectedMoviesID;
//  final String selectedMovieTitle;
//
//
//  const SelectedMovieBasedOnID({Key key,this.selectedMoviesID,this.selectedMovieTitle}) : super(key: key);
//
//
//  @override
//  _SelectedMovieBasedOnID createState() => _SelectedMovieBasedOnID();
//}
//
//
//
//class _SelectedMovieBasedOnID extends State<SelectedMovieBasedOnID> {
//
//
//  final ScrollController _scrollController = ScrollController();
//
//
//  var selectedMovieGenres = [];
//  String selectedMovieTitle;
//  String selectedPosterPath;
//  int selectedMoviesID;
//  String selectedReleaseDates ;
//  String selectedOverview ;
//  bool selectedAdult ;
//  dynamic selectedVoteAverage ;
//  String selectedOriginalLanguage ;
//  String selectedBackDropPath ;
//
//  Future<MovieID> futureMovieID;
//
//
//  @override
//  void initState()
//  {
//
//
//    // TODO: implement initState
//    super.initState();
//
//    print("MOVIE ID: ${widget.selectedMoviesID} ");
//    print("MOVIE TITLE: ${widget.selectedMovieTitle} ");
//
//    Future.delayed(Duration(seconds: 2), ()
//    {
//      setState(()
//      {
//        futureMovieID = MovieID().fetchMovieID(widget.selectedMoviesID);
//      });
//    });
//  }
//
//  bool clickToExpandBool = false;
//
//  @override
//  Widget build(BuildContext context)
//  {
//    return Scaffold(
//          backgroundColor: Colors.grey,
//          resizeToAvoidBottomPadding: false,
//
//          appBar: AppBar(
//            title: Text("${widget.selectedMovieTitle}"),
//            centerTitle: true,
//            backgroundColor: Colors.blueGrey,
//            elevation: 10.0,
//          ),
//
//          body: FutureBuilder<MovieID>(
//            future: futureMovieID,
//            builder: (context,snapshot)
//            {
//
//              if(snapshot.hasData)
//                {
//
//                  String imageLink = "https://image.tmdb.org/t/p/w600_and_h900_bestv2/";
//                  var movieID = snapshot.data;
//
//
//
//                  int lengthOfGenres = movieID.genres.length;
//
//                  for(int i =0; i<lengthOfGenres;i++)
//                    {
//                     selectedMovieGenres.add(movieID.genres[i].name);
//                    }
//
//                  selectedMovieTitle = movieID.title;
//                  selectedPosterPath = movieID.posterPath;
//                  selectedVoteAverage = movieID.voteAverage;
//                  selectedOverview = movieID.overview;
//                  selectedOriginalLanguage = movieID.originalLanguage;
//                  selectedAdult = movieID.adult;
//                  selectedMoviesID = movieID.id;
//                  selectedBackDropPath = movieID.backdropPath;
//                  selectedReleaseDates = movieID.releaseDate;
//
//
//
//
//                  return SingleChildScrollView(
//                    child: Center(
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: [
//                          Column(
//                            children: [
//                              SizedBox(height: 20,),
//                              Container(
//                                width: 350,
//                                color: Colors.blueGrey,
//                                child: Column(
//                                  mainAxisAlignment: MainAxisAlignment.center,
//                                  crossAxisAlignment: CrossAxisAlignment.center,
//                                  children: [
//                                    SizedBox(height: 20,),
//                                    Container(
//                                      decoration: BoxDecoration(
//                                        borderRadius: BorderRadius.circular(20),
//                                        color: Colors.black38,
//                                      ),
//                                      width: 200,
//                                      child: Text("${selectedMovieTitle.toString()}",style: TextStyle(
//                                          color: Colors.white,
//                                          fontSize: 30,
//                                          fontWeight: FontWeight.bold),
//                                          textAlign: TextAlign.center),
//                                    ),
//                                    SizedBox(height: 20,),
//                                    Container(
//                                      decoration: BoxDecoration(
//                                        border: Border.all(
//                                          color: Colors.black54,
//                                          width: 20,
//                                          style: BorderStyle.solid,
//                                        ),
//                                      ),
//                                      child: Image.network("${imageLink.toString()}${movieID.posterPath}"),
//                                    ),
//
//
//                                    SizedBox(height: 50,),
//
//                                    Card(
//                                      color: Colors.black38,
//                                      child: ExpansionTile(
//                                        leading: Icon(Icons.info_outline,size: 40,color: Colors.white,),
//                                        trailing: Icon(clickToExpandBool ? Icons.arrow_drop_up : Icons.arrow_drop_down ,
//                                          size: 40,
//                                          color: Colors.white,),
//
//                                        backgroundColor: Colors.black38,
//                                        title: Text("Overview",style: TextStyle(
//                                            color: Colors.white,
//                                            fontSize: 18,
//                                            fontWeight: FontWeight.bold),
//                                          textAlign: TextAlign.center,),
//                                        onExpansionChanged: (bool)
//                                        {
//                                          if(bool == true)
//                                          {
//                                            setState(()
//                                            {
//                                              clickToExpandBool = true;
//                                            });
//                                          }else
//                                          {
//                                            setState(()
//                                            {
//                                              clickToExpandBool = false;
//                                            });
//                                          }
//
//                                          return false;
//                                        },
//                                        children: [
//                                          SizedBox(height: 40,),
//                                          Text(selectedOverview.toString(),style: TextStyle(
//                                              color: Colors.white,
//                                              fontSize: 18,
//                                              fontWeight: FontWeight.bold),
//                                            textAlign: TextAlign.center,),
//                                          SizedBox(height: 40,),
//
//                                        ],
//                                      ),
//                                    ),
//
//                                    SizedBox(height: 50,),
//
//                                    Card(
//                                      color: Colors.black38,
//                                      child: ExpansionTile(
//                                        leading: Icon(Icons.info_outline,size: 40,color: Colors.white,),
//                                        trailing: Icon(clickToExpandBool ? Icons.arrow_drop_up : Icons.arrow_drop_down ,
//                                          size: 40,
//                                          color: Colors.white,),
//                                        backgroundColor: Colors.black38,
//                                        title: Text("Genres",style: TextStyle(
//                                            color: Colors.white,
//                                            fontSize: 18,
//                                            fontWeight: FontWeight.bold),
//                                          textAlign: TextAlign.center,),
//                                        onExpansionChanged: (bool)
//                                        {
//                                          if(bool == true)
//                                          {
//                                            setState(()
//                                            {
//                                              clickToExpandBool = true;
//                                            });
//                                          }else
//                                          {
//                                            setState(()
//                                            {
//                                              clickToExpandBool = false;
//                                            });
//                                          }
//
//                                          return false;
//                                        },
//                                        children: [
//                                          ListView.builder(
//                                            controller: _scrollController,
//                                            shrinkWrap: true,
//                                            itemCount: lengthOfGenres,
//                                            itemBuilder: (context,index)
//                                            {
//                                              return Column(
//                                                children: [
//                                                  SizedBox(height: 25,),
//                                                  Center(child: Text("${selectedMovieGenres[index].toString()}",style: TextStyle(
//                                                      color: Colors.white,
//                                                      fontSize: 18,
//                                                      fontWeight: FontWeight.bold),
//                                                    textAlign: TextAlign.center,),
//                                                  ),
//                                                  SizedBox(height: 25,),
//                                                ],
//                                              );
//                                            },
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                    SizedBox(height: 50,),
//
//                                    Text("Vote Average: ${selectedVoteAverage.toString()}/10",style: TextStyle(
//                                        color: Colors.white,
//                                        fontSize: 18,
//                                        fontWeight: FontWeight.bold),
//                                      textAlign: TextAlign.center,),
//                                    SizedBox(height: 20,),
//                                    Text("Language: ${selectedOriginalLanguage.toString().toUpperCase()}",style: TextStyle(
//                                        color: Colors.white,
//                                        fontSize: 18,
//                                        fontWeight: FontWeight.bold),
//                                      textAlign: TextAlign.center,),
//                                    SizedBox(height: 20,),
//                                    Text("Release Date: ${selectedReleaseDates.toString()}",style: TextStyle(
//                                        color: Colors.white,
//                                        fontSize: 18,
//                                        fontWeight: FontWeight.bold),
//                                      textAlign: TextAlign.center,),
//                                    SizedBox(height: 20,),
//                                    Text("Type: ${selectedAdult == false?  "PG" : "+18"}",style: TextStyle(
//                                        color: Colors.white,
//                                        fontSize: 18,
//                                        fontWeight: FontWeight.bold),
//                                      textAlign: TextAlign.center,),
//                                    SizedBox(height: 20,),
//                                    Text("Movie ID: ${selectedMoviesID.toString()}",style: TextStyle(
//                                        color: Colors.white,
//                                        fontSize: 18,
//                                        fontWeight: FontWeight.bold),
//                                      textAlign: TextAlign.center,),
//                                    SizedBox(height: 50,),
//                                  ],
//                                ),
//                              ) ?? CircularProgressIndicator(),
//                              SizedBox(height: 50,),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  );
//                }
//              if(snapshot.hasError)
//              {
//                return Text("${snapshot.error}");
//              }
//              else
//              {
//                return Center(
//                  child: Container(
//                    height: MediaQuery.of(context).size.height,
//                    width: MediaQuery.of(context).size.width,
//                    child: Container(
//                        child: Center(
//                            child: CircularProgressIndicator())),
//                  ),
//                );
//              }
//
//
//            },
//          ),
//    );
//  }
//}
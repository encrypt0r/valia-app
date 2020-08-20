import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app_imdb/jsonFiles/popularMovies.dart';
import 'package:test_app_imdb/SelectedMovieBasedOnIDPage.dart';
import 'package:test_app_imdb/jsonFiles/topRatedMovies.dart';


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
        futurePopularMovie = PopularMovie().fetchPopularMovie();
      });
    });

    Future.delayed(Duration(seconds: 2), ()
    {
      setState(()
      {
        futureTopRatedMovie = TopRatedMovies().fetchTopRatedMovie();
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
              child: Column(
                children: [
                  SizedBox(height: 25,),
                  FutureBuilder<TopRatedMovies>(
                    future: futureTopRatedMovie,
                    builder: (context,snapshot)
                    {

                      if (snapshot.hasData)
                      {
                        var movieData = snapshot.data;
                        String imageLink = "https://image.tmdb.org/t/p/w600_and_h900_bestv2/";


                        return Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Card(
                                    color: Colors.black38,
                                    child: ExpansionTile(
                                      leading: Icon(Icons.star,size: 40,color: Colors.white,),
                                      trailing: Icon(clickToExpandTopRatedMovieBool ? Icons.arrow_drop_up : Icons.arrow_drop_down ,
                                        size: 40,
                                        color: Colors.white,),
                                      backgroundColor: Colors.blueGrey,
                                      title: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            text: "Top Rated",
                                            style: TextStyle(
                                                fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                            children: <TextSpan>
                                            [
                                              TextSpan(text: ' Movies',style: TextStyle(
                                                  fontSize: 25,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal
                                              )),
                                            ]
                                        ),
                                      ),
                                      onExpansionChanged: (bool)
                                      {
                                        if(bool == true)
                                        {
                                          setState(()
                                          {
                                            clickToExpandTopRatedMovieBool = true;
                                            topRatedItemCount = movieData.results.length;
                                          });
                                        }else
                                        {
                                          setState(()
                                          {
                                            clickToExpandTopRatedMovieBool = false;
                                            topRatedItemCount = 0;
                                          });
                                        }

                                        return false;
                                      },
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            itemCount: topRatedItemCount,
                                            shrinkWrap: true,
                                            itemBuilder: (builder,index)
                                            {


                                              topRatedMoviesTitles.add(movieData.results[index].title);
                                              topRatedMoviesID.add(movieData.results[index].id);
                                              topRatedPosterPath.add("${imageLink.toString()}${movieData.results[index].posterPath}");


                                              return Column(
                                                children: [
                                                  SizedBox(height: 30,),
                                                  Card(
                                                      color: Colors.black,
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width - 110,
                                                        color: Colors.grey,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            SizedBox(height: 30,),
                                                            InkWell(
                                                              onTap: ()
                                                              {
                                                                setState(()
                                                                {
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
                                                                });


                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                  color: Colors.black38,
                                                                ),
                                                                width: 200,
                                                                child: Text("${topRatedMoviesTitles[index]}",style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.bold),
                                                                    textAlign: TextAlign.center),
                                                              ),
                                                            ),
                                                            SizedBox(height: 20,),
                                                            IconButton(
                                                              icon:
                                                              favoriteBoolIconTopRated && favoriteIndexTopRated==index ?
                                                              Icon(Icons.favorite,color: Colors.red,size: 40,)
                                                                  :
                                                              Icon(Icons.favorite_border,color: Colors.red,size: 40,),
                                                              onPressed:
                                                              () {
                                                                setState(()
                                                                {
                                                                  favoriteIndexTopRated = index;
                                                                  favoriteBoolIconTopRated = !favoriteBoolIconTopRated;
                                                                });

//                                                                if(favoriteIndexTopRated == index)
//                                                                {
//                                                                  var usersRef = Firestore.instance.collection('MyFavorites')
//                                                                      .document(topRatedMoviesID[favoriteIndexTopRated].toString());
//
//                                                                  usersRef.get().then((docSnapshot) =>
//                                                                  {
//                                                                    if(docSnapshot.exists)
//                                                                      {
//                                                                        createAlertAfterCancel(context),
//                                                                      }
//                                                                    else
//                                                                      {
//                                                                      Firestore.instance.collection('MyFavorites')
//                                                                      .document("${topRatedMoviesID[favoriteIndexTopRated]}").setData(
//                                                                      {
//                                                                        'movieID': topRatedMoviesID[favoriteIndexTopRated].toString(),
//                                                                        'movieName': topRatedMoviesTitles[favoriteIndexTopRated].toString(),
//                                                                        'favoriteBool': true,
//                                                                      }),
//                                                                        print("ADDED TO FAVORITES"),
//                                                                      }
//                                                                  });
//
//
//
//
//                                                                }
                                                              },
                                                            ),
                                                            SizedBox(height: 20,),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color: Colors.black54,
                                                                  width: 25,
                                                                  style: BorderStyle.solid,
                                                                ),
                                                              ),
                                                              child: Image.network(topRatedPosterPath[index],
                                                                height: 320,),
                                                            ),

                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                  FutureBuilder<PopularMovie>(
                    future: futurePopularMovie,
                    builder: (context,snapshot)
                    {

                      if (snapshot.hasData)
                      {
                        var movieData = snapshot.data;
                        String imageLink = "https://image.tmdb.org/t/p/w600_and_h900_bestv2/";


                        return Column(
                          children: [
                            SizedBox(height: 20,),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Card(
                                    color: Colors.black38,
                                    child: ExpansionTile(
                                      leading: Icon(Icons.star,size: 40,color: Colors.white,),
                                      trailing: Icon(clickToExpandPopularMovieBool ? Icons.arrow_drop_up : Icons.arrow_drop_down ,
                                        size: 40,
                                        color: Colors.white,),
                                      backgroundColor: Colors.blueGrey,
                                      title: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            text: "Popular",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic),
                                            children: <TextSpan>
                                            [
                                              TextSpan(text: ' Movies',style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle: FontStyle.normal
                                              )),
                                            ]
                                        ),
                                      ),
                                      onExpansionChanged: (bool)
                                      {
                                        if(bool == true)
                                        {
                                          setState(()
                                          {
                                            clickToExpandPopularMovieBool = true;
                                            popularItemCount = movieData.results.length;
                                          });
                                        }else
                                        {
                                          setState(()
                                          {
                                            clickToExpandPopularMovieBool = false;
                                            popularItemCount = 0;
                                          });
                                        }

                                        return false;
                                      },
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: ListView.builder(
                                              controller: _scrollController,
                                              itemCount: popularItemCount,
                                              shrinkWrap: true,
                                              itemBuilder: (builder,index)
                                              {


                                                popularMoviesTitles.add(movieData.results[index].title);
                                                popularMoviesID.add(movieData.results[index].id);
                                                popularPosterPath.add("${imageLink.toString()}${movieData.results[index].posterPath}");


                                                return Column(
                                                  children: [
                                                    SizedBox(height: 30,),
                                                    Card(
                                                        color: Colors.black,
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width - 110,
                                                          color: Colors.grey,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              SizedBox(height: 30,),
                                                              InkWell(
                                                                onTap: ()
                                                                {
                                                                  setState(()
                                                                  {
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
                                                                  });


                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    color: Colors.black38,
                                                                  ),
                                                                  width: 200,
                                                                  child: Text("${popularMoviesTitles[index]}",style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 30,
                                                                      fontWeight: FontWeight.bold),
                                                                      textAlign: TextAlign.center),
                                                                ),
                                                              ),
                                                              SizedBox(height: 20,),
                                                              IconButton(
                                                                icon:
                                                                favoriteBoolIconPopular && favoriteIndexPopular == index
                                                                    ?
                                                                Icon(Icons.favorite,color: Colors.red,size: 40,)
                                                                    :
                                                                Icon(Icons.favorite_border,color: Colors.red,size: 40,),
                                                                onPressed:
                                                                ()
                                                                {
                                                                  setState(()
                                                                  {
                                                                    favoriteIndexPopular = index;
                                                                    favoriteBoolIconPopular = !favoriteBoolIconPopular;
                                                                  });

//                                                                  if(favoriteIndexPopular == index)
//                                                                  {
//                                                                    var usersRef = Firestore.instance.collection('MyFavorites')
//                                                                        .document(popularMoviesID[favoriteIndexPopular].toString());
//
//                                                                    usersRef.get().then((docSnapshot) =>
//                                                                    {
//                                                                      if(docSnapshot.exists)
//                                                                        {
//                                                                          createAlertAfterCancel(context),
//                                                                        }
//                                                                      else
//                                                                        {
//                                                                          Firestore.instance.collection('MyFavorites')
//                                                                              .document("${popularMoviesID[favoriteIndexPopular]}").setData(
//                                                                              {
//                                                                                'movieID': popularMoviesID[favoriteIndexPopular].toString(),
//                                                                                'movieName': popularMoviesTitles[favoriteIndexPopular].toString(),
//                                                                                'favoriteBool': true,
//                                                                              }),
//                                                                          print("ADDED TO FAVORITES"),
//                                                                        }
//                                                                    });
//                                                                  }
                                                                },
                                                              ),
                                                              SizedBox(height: 20,),
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    color: Colors.black54,
                                                                    width: 25,
                                                                    style: BorderStyle.solid,
                                                                  ),
                                                                ),
                                                                child: Image.network(popularPosterPath[index],
                                                                  height: 320,),
                                                              ),

                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                  ],
                                                );
                                              },
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50,),

                          ],
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
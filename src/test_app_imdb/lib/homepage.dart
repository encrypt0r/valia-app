import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app_imdb/jsonFiles/popularMovies.dart';
import 'package:test_app_imdb/selectedPopularMovie.dart';


class HomePage extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  final ScrollController _scrollController = ScrollController();




  Future<Movie> futureMovie;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 2), ()
    {
      setState(()
      {
        futureMovie = Movie().fetchMovie();
      });
    });

//    Firestore.instance.collection('MyFavorites')
//        .document().setData(
//        {
//          'movieID': "",
//          'favoriteBool': false,
//        });

  }


  bool clickToExpandBool = false;
  int selectedIndexPopular;
  int popularItemCount;

  int favoriteIndexPopular;


  String title = null ?? "Welcome";

  //not pushed
  List<String> moviesTitles = [];
  List<String> posterPath = [];
  List<int> moviesID = [];

  //pushed down via Navigator:
  List<String> releaseDates = [];
  List<String> overview = [];
  List<bool> adult = [];
  List<dynamic> voteAverage = [];
  List<String> originalLanguage = [];
  List<String> backdropPath = [];


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
                  FutureBuilder<Movie>(
                    future: futureMovie,
                    builder: (context,snapshot)
                    {

                      if (snapshot.hasData)
                      {
                        var movieData = snapshot.data;
                        String imageLink = "https://image.tmdb.org/t/p/w600_and_h900_bestv2/";







                        return Column(
                          children: [
                            SizedBox(height: 20,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Card(
                                color: Colors.black38,
                                child: ExpansionTile(
                                  leading: Icon(Icons.star,size: 40,color: Colors.white,),
                                  trailing: Icon(clickToExpandBool ? Icons.arrow_drop_up : Icons.arrow_drop_down ,
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
                                        clickToExpandBool = true;
                                        popularItemCount = movieData.results.length;
                                      });
                                    }else
                                    {
                                      setState(()
                                      {
                                        clickToExpandBool = false;
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


                                          moviesTitles.add(movieData.results[index].title);
                                          moviesID.add(movieData.results[index].id);
                                          posterPath.add("${imageLink.toString()}${movieData.results[index].posterPath}");

                                          //pushed with Navigator
                                          overview.add(movieData.results[index].overview);
                                          releaseDates.add(movieData.results[index].releaseDate);
                                          adult.add(movieData.results[index].adult);
                                          voteAverage.add(movieData.results[index].voteAverage);
                                          originalLanguage.add(movieData.results[index].originalLanguage);
                                          backdropPath.add("${imageLink.toString()}${movieData.results[index].backdropPath}");


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
                                                                          return SelectedPopularMovie(
                                                                            selectedMovieTitle: moviesTitles[selectedIndexPopular],
                                                                            selectedPosterPath: posterPath[selectedIndexPopular],
                                                                            selectedMoviesID: moviesID[selectedIndexPopular],
                                                                            selectedAdult: adult[selectedIndexPopular],
                                                                            selectedBackDropPath: backdropPath[selectedIndexPopular],
                                                                            selectedOriginalLanguage: originalLanguage[selectedIndexPopular],
                                                                            selectedOverview: overview[selectedIndexPopular],
                                                                            selectedReleaseDates: releaseDates[selectedIndexPopular],
                                                                            selectedVoteAverage: voteAverage[selectedIndexPopular],
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
                                                            child: Text("${moviesTitles[index]}",style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.bold),
                                                                textAlign: TextAlign.center),
                                                          ),
                                                        ),
                                                        SizedBox(height: 20,),
                                                        IconButton(
                                                          icon:
                                                          favoriteIndexPopular == index
                                                              ?
                                                          Icon(Icons.favorite,color: Colors.red,size: 40,)
                                                              :
                                                          Icon(Icons.favorite_border,color: Colors.red,size: 40,),
                                                          onPressed:
                                                          (index == favoriteIndexPopular) ? null : ()
                                                          {
                                                            setState(()
                                                            {
                                                              favoriteIndexPopular = index;
                                                            });

                                                            if(favoriteIndexPopular == index)
                                                            {
                                                              var usersRef = Firestore.instance.collection('MyFavorites')
                                                                  .document(moviesID[favoriteIndexPopular].toString());

                                                              usersRef.get().then((docSnapshot) =>
                                                              {
                                                                if(docSnapshot.exists)
                                                                  {
                                                                    createAlertAfterCancel(context),
                                                                  }
                                                                else
                                                                  {
                                                                  Firestore.instance.collection('MyFavorites')
                                                                  .document("${moviesID[favoriteIndexPopular]}").setData(
                                                                  {
                                                                    'movieID': moviesID[favoriteIndexPopular].toString(),
                                                                    'movieName': moviesTitles[favoriteIndexPopular].toString(),
                                                                    'favoriteBool': true,
                                                                  }),
                                                                    print("ADDED TO FAVORITES"),
                                                                  }
                                                              });




                                                            }
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
                                                          child: Image.network(posterPath[index],
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
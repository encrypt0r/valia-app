import 'package:flutter/material.dart';


class SelectedPopularMovie extends StatefulWidget
{


  final String selectedMovieTitle;
  final String selectedPosterPath;
  final int selectedMoviesID;

  final String selectedReleaseDates ;
  final String selectedOverview ;
  final bool selectedAdult ;
  final dynamic selectedVoteAverage ;
  final String selectedOriginalLanguage ;
  final String selectedBackDropPath ;

  const SelectedPopularMovie({
    Key key,
    this.selectedMovieTitle,
    this.selectedPosterPath,
    this.selectedMoviesID,
  this.selectedReleaseDates,
  this.selectedOverview,
  this.selectedAdult,
  this.selectedVoteAverage,
  this.selectedOriginalLanguage,
  this.selectedBackDropPath}) : super(key: key);


  @override
  _SelectedPopularMovie createState() => _SelectedPopularMovie();
}



class _SelectedPopularMovie extends State<SelectedPopularMovie> {





  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
  }

  bool clickToExpandBool = false;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.grey,
      resizeToAvoidBottomPadding: false,


      appBar: AppBar(
        title: Text("${widget.selectedMovieTitle}"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        elevation: 10.0,
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(height: 20,),
                  Container(
                    width: 350,
                    color: Colors.blueGrey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black38,
                          ),
                          width: 200,
                          child: Text("${widget.selectedMovieTitle.toString()}",style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black54,
                              width: 20,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Image.network(widget.selectedPosterPath.toString(),),
                        ),
                        SizedBox(height: 50,),
                        Card(
                          color: Colors.black38,
                          child: ExpansionTile(
                            leading: Icon(Icons.info_outline,size: 40,color: Colors.white,),
                            trailing: Icon(clickToExpandBool ? Icons.arrow_drop_up : Icons.arrow_drop_down ,
                              size: 40,
                              color: Colors.white,),

                            backgroundColor: Colors.black38,
                            title: Text("Overview",style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                            onExpansionChanged: (bool)
                            {
                              if(bool == true)
                              {
                                setState(()
                                {
                                  clickToExpandBool = true;
                                });
                              }else
                              {
                                setState(()
                                {
                                  clickToExpandBool = false;
                                });
                              }

                              return false;
                            },
                            children: [
                              SizedBox(height: 40,),
                              Text(widget.selectedOverview.toString(),style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,),
                              SizedBox(height: 40,),

                            ],
                          ),
                        ),

                        SizedBox(height: 50,),
                        Text("Vote Average: ${widget.selectedVoteAverage.toString()}/10",style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),
                        SizedBox(height: 20,),
                        Text("Language: ${widget.selectedOriginalLanguage.toString().toUpperCase()}",style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),
                        SizedBox(height: 20,),
                        Text("Release Date: ${widget.selectedReleaseDates.toString()}",style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),
                        SizedBox(height: 20,),
                        Text("Type: ${widget.selectedAdult == false?  "PG" : "+18"}",style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),
                        SizedBox(height: 20,),
                        Text("Movie ID: ${widget.selectedMoviesID.toString()}",style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,),
                        SizedBox(height: 50,),
                      ],
                    ),
                  ) ?? CircularProgressIndicator(),
                  SizedBox(height: 50,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app/Model/DataModel.dart';

class listData extends StatefulWidget
{
  final String title;

  // This Widget accepts the arguments as constructor
  // parameters. It does not extract the arguments from
  // the ModalRoute.
  //
  // The arguments are extracted by the onGenerateRoute
  // function provided to the MaterialApp widget.
  const listData({Key? key, required this.title,}) : super(key: key);
  //final FirebaseApp app;
  State<listData> createState()=> _listData();
}

class _listData extends State<listData>
{
  late DatabaseReference _dataRef;
  List<DataModel> data = [];

  @override
  void initState() {
    super.initState();
   // final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _dataRef=FirebaseDatabase.instance.reference().child('ymg');
    //_dataRef=database.reference().child('ymg');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Center(child: Text(widget.title),),
      ),
      body: FutureBuilder(
          future: _dataRef.once(),
          builder: (context,AsyncSnapshot<DataSnapshot> snapshot) {
            return snapshot.hasData?listOfQuotes(snapshot):
                Center(child: CircularProgressIndicator(),);
          }
      ),
    );
  }

  Widget listOfQuotes(AsyncSnapshot<DataSnapshot> snapshot)
  {
    if (snapshot.hasData) {
      data.clear();
      Map<dynamic, dynamic> values = snapshot.data!.value;
      values.forEach((key, values) {
        String catg=values["category"];
        if(catg==widget.title)
        {
          DataModel categorieModel = new DataModel();
          categorieModel.title=values["title"].toString();
          data.add(categorieModel);
        }
      });
    }
    return  ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context,int index)=>
            Container(
              margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
              child:Card(
                elevation: 20,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                child:SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 270,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: ,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 230,
                          color: Colors.black,
                          child:Center(
                              child:Padding(padding: EdgeInsets.all(15),
                                child:Text(data[index].title,style: TextStyle(color: Colors.white,fontSize: 18),) ,)
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(8, 6, 8, 6),
                        child:Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Row(children: [
                                  Icon(Icons.favorite_border),
                                  Text("Like")
                                ],)),
                            Expanded(
                                flex: 2,
                                child: Row(children: [
                                  Icon(Icons.download_rounded),
                                  Text("Save")
                                ],)),
                            Expanded(
                                flex: 2,
                                child: Row(children: [
                                  Icon(Icons.copy),
                                  Text("Copy")
                                ],)),
                            Expanded(
                                flex: 2,
                                child: Row(children: [
                                  Icon(Icons.share),
                                  Text("Share")
                                ],))
                          ],
                        ),
                      )
                    ],
                  ),
                )

              )
            )
    );
  }

}
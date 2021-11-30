import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app/Model/DataModel.dart';
import 'package:quotes_app/list_data.dart';

import 'Model/Category.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  runApp(MyHomePage(app:app));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.app});
  final FirebaseApp app;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late DatabaseReference _categoryRef;
  late DatabaseReference _dataRef;
  List<CategorieModel> categories = [];
  List<DataModel> data=[];

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _categoryRef=database.reference().child('categories');
    _dataRef=database.reference().child('ymg');
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Center(child: Text("Monday Motivation"),),
          ),
          body:DefaultTabController(
                    length: 2,
                    child:Container(
                      child: Column(
                        children: [
                          const TabBar(
                              labelColor: Colors.black,
                              tabs: [
                                Tab(child:Text('Status')),
                                Tab(child: Text('Categories'),)
                              ]
                          ),
                          Expanded(
                              child: TabBarView(
                                  children: [
                                    FutureBuilder(
                                    future: _dataRef.once(),
                                    builder: (context,AsyncSnapshot<DataSnapshot> snapshot) {
                                    return snapshot.hasData?listOfQuotes(snapshot):
                                     Center(child: CircularProgressIndicator(),);
                                    }),
                                    FutureBuilder(
                                    future: _categoryRef.once(),
                                     builder: (context,AsyncSnapshot<DataSnapshot> snapshot) {
                                      return snapshot.hasData?listOfCatogries(snapshot,context):
                                              Center(child: CircularProgressIndicator(),);
                                    })
                                  ])
                          )
                        ],
                      ),
                    )
                )
          )
    );
  }

  Widget listOfQuotes(AsyncSnapshot<DataSnapshot> snapshot)
  {
    if (snapshot.hasData) {
      data.clear();
      Map<dynamic, dynamic> values = snapshot.data!.value;
      values.forEach((key, values) {
        DataModel categorieModel = new DataModel();
        categorieModel.title=values["title"].toString();
        data.add(categorieModel);
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
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 230,
                            color: Colors.black,
                            child:Center(
                                child:Padding(padding: EdgeInsets.all(15),
                                  child:Text(data[index].title,style: TextStyle(color: Colors.white,fontSize: 18),) ,)
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

  Widget listOfCatogries(AsyncSnapshot<DataSnapshot> snapshot,BuildContext context)
  {
    if (snapshot.hasData) {
      categories.clear();
      Map<dynamic, dynamic> values = snapshot.data!.value;
      values.forEach((key, values) {
        CategorieModel categorieModel = new CategorieModel();
        categorieModel.categorieName=key;
        categorieModel.imgUrl=values["thumbnail"].toString();
        categories.add(categorieModel);
      });
    }
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(categories.length, (index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) =>  listData(title: categories[index].categorieName)));
          },
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  width: 100.0,
                  height: 100.0,
                  decoration:BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image:NetworkImage(categories[index].imgUrl)
                    ),
                  )),
              Text(categories[index].categorieName)
            ],
          ),
        );
      }),
    );
  }
}

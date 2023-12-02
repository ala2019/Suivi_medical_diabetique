import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'consulterpatient.dart';
int idmed ;




Future <List<Data>> fetchData() async {

  
  final response =
      await http.post('http://192.168.43.4:8080/pfe/listpatient.php', body: {
           "idmed" : idmed.toString() ,
           
        });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final String index;
  final String type ;
  
  final String nom;
  final String prenom;

  Data({this.index, this.type , this.nom,this.prenom});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      index: json['index'],
      type:json['type_diabete'] ,
      nom: json['nom_patient'],
      prenom:json['patient_prenom']
    );
  }
}



void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {






  Future <List<Data>> futureData;



 
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    _loadCounter();
  }


  

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idmed = (prefs.getInt('idmed') ?? '');
      
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'suivi medical',
      home: Scaffold(
        appBar: AppBar(
          title: Text('List patients'),
        ),
        body: Center(
          child: FutureBuilder <List<Data>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Data> data = snapshot.data;
                return 
                ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                          color: Colors.white,
                          
                          child: Container(
                            
                            width: 200,
                            height: 60,
                           /* padding: EdgeInsets.only(
                          left: 10.0, right:10.0, top: 20, bottom: 10),*/



                            
                          decoration: BoxDecoration(
                             border: Border.all(width: 2.0,color: Colors.blueAccent),
                          borderRadius: BorderRadius.all(Radius.circular(7.0)
                            
                          ),),
                           child :
                            

                           
                          
                          
                            new InkWell(

                              
                             onTap: () {
                              Navigator.push(context,
                                 MaterialPageRoute(builder: (context) => consulterpatient(),)); 
            
                                                 },
                                  child: Row(
                                 children: <Widget>[

                                Container(margin: EdgeInsets.all(10),child: Text(data[index].index)),
                                 Container(height: 20,width: 2,color: Colors.blueAccent,),
                                Container(margin:EdgeInsets.only(top:10,bottom: 10,left:10),child: 
                                Column(children: <Widget>[
                                   Text(data[index].nom+"  "+data[index].prenom,style:TextStyle( fontSize: 15),textAlign:TextAlign.start,),
                                   Text(" Diabéte de "+data[index].type,style:TextStyle( fontSize: 15))


                                ],
                                )
                                )
                                        ],
                                            ),
                                         )
                         ) 
                         );
                }
              );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:suivi_medical/m%C3%A9decin/consulterpatient.dart';
import 'package:shared_preferences/shared_preferences.dart';

int idmed ;




Future <List<Data>> consulterlistpatient() async {

  
  final response =
      await http.post('http://192.168.43.4:8080/suivimedical/controller/dossiermedical_controllers/dossiermedicalmed.php', body: {
           "idmed" : idmed.toString() ,
           
        });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    print(jsonResponse) ;
    print (idmed) ;
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
      index: json['patient_index'],
      type:json['type_diabete'] ,
      nom: json['nom_patient'],
      prenom:json['prenom_patient']
    );
  }
}



class liste_patient extends StatefulWidget {
  @override
  _liste_patientState createState() => _liste_patientState();
}

class _liste_patientState extends State<liste_patient> {
  
  
     Future <List<Data>> futureData;



 
  @override
  void initState() {
    super.initState();
    _loadCounter();
    futureData = consulterlistpatient();
    
  }

   _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idmed = (prefs.getInt('idmed') ?? '');
      
      
    });
  }




  

 


  

 



  


  
  @override
  Widget build(BuildContext context) {
    
    
    
    
    return  Scaffold(
        appBar: AppBar(
          title: Text('List de patients'),
        ),
        body: Center(
          child: FutureBuilder <List<Data>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //futureData =fetchData() ;
                List<Data> data = snapshot.data;
                return 
                ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                
                  return 
                  

                   Card(
                          color: Colors.white,
                          
                          child: Container(
                            
                            width: 200,
                            height: 60,
                          



                            
                             decoration: BoxDecoration(
                             border: Border.all(width: 2.0,color: Colors.blueAccent),
                             borderRadius: BorderRadius.all(Radius.circular(7.0)
                            
                              ),),
                              child :
                            

                           
                          
                          
                            new InkWell(

                              
                             onTap: () {
                              Navigator.push(context,
                                 MaterialPageRoute(builder: (context) => consulterpatient(indexpt: data[index].index.toString() , idmed : idmed ),)); 
            
                                                 },
                                  child: Row(
                                 children: <Widget>[

                                Container(margin: EdgeInsets.all(10),child: Text(data[index].index)),
                                 Container(height: 20,width: 2,color: Colors.blueAccent,),
                                Container(margin:EdgeInsets.only(top:10,bottom: 10,left:10),child: 
                                Column(children: <Widget>[
                                   Text(data[index].nom+" "+data[index].prenom,style:TextStyle( fontSize: 15),textAlign:TextAlign.start,),
                                  // Text(data[index].prenom,style:TextStyle( fontSize: 15),textAlign:TextAlign.start,),
                                   data[index].type==null ?
                                   Text("aucun type de diabéte ",style:TextStyle( fontSize: 15))
                                   :Text("diabete de "+data[index]?.type,style:TextStyle( fontSize: 15))


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
              }/* else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }*/
              // By default show a loading spinner.
              return Center (child :CircularProgressIndicator());
            },
          ),
        ),
      );
    
  }


}


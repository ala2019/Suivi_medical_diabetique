import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:suivi_medical/m%C3%A9decin/charttype2.dart';
import 'package:suivi_medical/m%C3%A9decin/converpatient.dart';
import 'package:suivi_medical/m%C3%A9decin/donnerrdv.dart';
import 'package:suivi_medical/m%C3%A9decin/modifierdossiermedical.dart';
import 'package:suivi_medical/patient/accueil_patient.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';




import 'charttype1.dart';

import 'liste_patient.dart';




 
class consulterpatient extends StatefulWidget {
 String indexpt ;
 int idmed ;


 
consulterpatient({this.indexpt,this.idmed}) ;

  @override
  _consulterpatientState createState() => _consulterpatientState(indexpt,idmed);
}

class _consulterpatientState extends State<consulterpatient> {
  
   String indexpt ;
   int idmed ;
   List pt ;

  _consulterpatientState(this.indexpt,this.idmed);



  






 
 

 

  





  @override
 
  Widget build(BuildContext context) {

    List data = new List();

     Future<List> getdossiermedical() async {
    
     
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/dossiermedical_controllers/dossiermed2.php",
        body: {
           "index" : indexpt.toString() ,
           "idmed": idmed.toString()
        });
        //headers: {"Accept": "application/json"});

        data = json.decode(response.body) ;
        //print(data[0]) ;
        print (idmed) ;
        return data ;
       
  }
    //print(getpatient()) ;

    print(data) ;


     
    return  new Scaffold(
      appBar: new AppBar(title: Text('PATIENT')),
      body:/* Row(
         crossAxisAlignment: CrossAxisAlignment.start,
        
        children: <Widget> [*/
      
      FutureBuilder(
        future: getdossiermedical(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Container(
                child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Card(
                   margin: EdgeInsets.all(12),
                   elevation: 4,
                 color: Colors.white,


                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center ,

                    children:<Widget>[
                      Column(
                         mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start ,
                        children:<Widget>[
                       Text("Index :                   "+snapshot.data[index]['patient_index'],style:TextStyle( fontSize: 17)),
                       Text("Nom :                     "+snapshot.data[index]['nom_patient'],style:TextStyle( fontSize: 17)),
                       Text("Prenom :               "+snapshot.data[index]['prenom_patient'],style:TextStyle( fontSize: 17)),
                       Text("Sexe :                     "+snapshot.data[index]['sexe'],style:TextStyle( fontSize: 17)),

            
                       Text("Telephone :           "+snapshot.data[index]['telephone1'],style:TextStyle( fontSize: 17)),
                       snapshot.data[index]['telephone2']==null
                        ?Text("Type :   aucun tel 2",style:TextStyle( fontSize: 17))
                       :Text("Telephone 2 :        "+snapshot.data[index]['telephone2'],style:TextStyle( fontSize: 17)),
                       Text("Email :                    "+snapshot.data[index]['email'],style:TextStyle( fontSize: 17)),
                       snapshot.data[index]['type_diabete']==null || snapshot.data[index]['type_diabete']==""
                       ?Text("Type :   aucun type de diabéte",style:TextStyle( fontSize: 17))
                       :Text(" Type de diabete:   "+snapshot.data[index]['type_diabete'],style:TextStyle( fontSize: 17)),
                       snapshot.data[index]['poids']==null || snapshot.data[index]['poids']==0
                       ?Text(" poids:     aucun poids        ",style:TextStyle( fontSize: 17))
                       :Text(" poids:                      "+snapshot.data[index]['poids'],style:TextStyle( fontSize: 17)),
                        ],
                      ),
                        
                       


                        SizedBox(height: 40),
                        /*SizedBox(height: 30),
                        SizedBox(height: 30),
                        SizedBox(height: 30),*/



                      Container(
                height: 40,
                width: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xff374ABE), Color(0xff64B6FF)]),
                  color: Colors.white, // Border Color
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(
                          4.0) //                 <--- border radius here
                      ),
                ),
                child: FlatButton(
                  onPressed: () {

                     Navigator.push(
                             context,
                           MaterialPageRoute(builder: (context) => donnerrdv(index : snapshot.data[index]['patient_index'] ,idmed: idmed )),
                              );
                             

                    
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('donner rendez_vous',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                  /*color: Colors.purple,*/
                ),
              ),


                 SizedBox(height: 30),
                 Container(
                height: 40,
                width: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xff374ABE), Color(0xff64B6FF)]),
                  color: Colors.white, // Border Color
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(
                          4.0) //                 <--- border radius here
                      ),
                ),
                child: FlatButton(
                  onPressed: () {

                    if (snapshot.data[index]['type_diabete']=="type1"){
                     Navigator.push(context,
                                 MaterialPageRoute(builder: (context) => BarChartSample2(indexpt: indexpt , nom : snapshot.data[index]['nom_patient']+' '+snapshot.data[index]['prenom_patient'] ),));
                    } 
                    else if(snapshot.data[index]['type_diabete']=="type2") {

                      
                                 
                                 Navigator.push(context,
                                 MaterialPageRoute(builder: (context) => LineChartSample2(indexpt: indexpt,nom:snapshot.data[index]['nom_patient']+' '+snapshot.data[index]['prenom_patient']),));
                    }  
                    else {

                     Fluttertoast.showToast(
                     msg: "Cette patient na pas un type de diabéte , Vous pouvez lui donner un type ",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 3,
                     backgroundColor: Colors.grey,

                     );
                    }         
                    
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('afficher les tests',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                  /*color: Colors.purple,*/
                ),
              ),
               SizedBox(height: 30),




               Container(
                height: 40,
                width: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xff374ABE), Color(0xff64B6FF)]),
                  color: Colors.white, // Border Color
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(
                          4.0) //                 <--- border radius here
                      ),
                ),
                child: FlatButton(
                  onPressed: () {
                     Navigator.push(context,
                                 MaterialPageRoute(builder: (context) => converpatient(indexpt: indexpt , idmed : idmed , nom : snapshot.data[index]['nom_patient']+' '+snapshot.data[index]['prenom_patient'] ),));
                                
                    
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Contacter patient',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                  /*color: Colors.purple,*/
                ),
              ),




               SizedBox(height: 30),




               Container(
                height: 40,
                width: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xff374ABE), Color(0xff64B6FF)]),
                  color: Colors.white, // Border Color
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(
                          4.0) //                 <--- border radius here
                      ),
                ),
                child: FlatButton(
                  onPressed: () {
                     
                    if (snapshot.data[index]['type_diabete']==null&&snapshot.data[index]['poids']==null){
                       Navigator.push(
                             context,
                           MaterialPageRoute(builder: (context) => modifierdossiermedical( numdossier :int.parse(snapshot.data[index]['numdossier']), type : "aucun type" ,poids:0 )),
                              );

                    }else {
                  

                     Navigator.push(
                             context,
                           MaterialPageRoute(builder: (context) => modifierdossiermedical( numdossier :int.parse(snapshot.data[index]['numdossier']), type : snapshot.data[index]['type_diabete'] ,poids: int.parse(snapshot.data[index]['poids']))),
                              );}
                    
                    
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Modifier Dossier médical',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                  /*color: Colors.purple,*/
                ),
              ),

                        

               SizedBox(height: 30),
               SizedBox(height: 30),



















                    ]
                  ),
                );
              },
                ),
            );
          }
          else if(snapshot.hasError){
            throw snapshot.error;
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),


     

      

      


    );
  
}

}




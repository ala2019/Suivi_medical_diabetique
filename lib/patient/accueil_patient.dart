import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:suivi_medical/patient/conseils.dart';
import 'package:suivi_medical/patient/demanderdv.dart';
import 'package:suivi_medical/patient/type1.dart';
import 'type2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';
import 'package:carousel_pro/carousel_pro.dart';

String index ;

class accueil_patient extends StatefulWidget {
  @override
  _accueil_patientState createState() => _accueil_patientState();
}

class _accueil_patientState extends State<accueil_patient> {







  @override
  Widget build(BuildContext context) {
    return card1() ;
      
  }
}

class card1 extends StatefulWidget {
  @override
  _card1State createState() => _card1State();
}

class _card1State extends State<card1> {

  int id_med ;


  Future<String> gettype() async {
    List datadm;
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/dossiermedical_controllers/dossiermed.php",
        body: {
           "index" :index ,
           
        });
        //headers: {"Accept": "application/json"});
        datadm = json.decode(response.body) ;
        print(datadm) ;
        int idmed = int.parse(datadm[0]["medecin_idmedecin"]) ;
        int num_d = int.parse(datadm[0]["numdossier"]) ;

        _incrementCounter() async {
           SharedPreferences prefs = await SharedPreferences.getInstance();
         setState(() {
          id_med = idmed ;
          });
    prefs.setInt('id_med', id_med);
    prefs.setInt('num_d', num_d);
    prefs.setString('nomprenom', datadm[0]["nom_patient"]+" "+datadm[0]['prenom_patient']);
    print(id_med);
  }
  _incrementCounter();
  print(datadm) ;
         
        if (datadm[0]["type_diabete"]=="type1"){

           Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => type1()),
      );
        
        }
        else if(datadm[0]["type_diabete"]=="type2") {
         Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => type2()),
         );

        }
        else if(datadm[0]["type_diabete"]==null) {
           Fluttertoast.showToast(
                     msg: "aucun type de diabéte",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 2,
                     backgroundColor: Colors.grey,

                     );
        }

  }
  

    @override
           void initState() {
           super.initState();
            _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      index = (prefs.getString('index') ?? '');
      
      
    });
  }

 
 
  
  @override
  Widget build(BuildContext context) {

 

    return Scaffold(
      appBar: AppBar(
              title: Text('Dashbord'),),
      
      body: Column( 
      crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //SizedBox(height: 20.0,),
        SizedBox(
          height: 150.0,
          width: 400.0,
         
            child: Carousel(
            images: [
             
              ExactAssetImage("images/1.jpg"),
              ExactAssetImage("images/2.jpg"),
              ExactAssetImage("images/3.jpg"),
              ExactAssetImage("images/4.jpg"),
              ExactAssetImage("images/5.jpg"),
            ],
                 boxFit: BoxFit.cover,
                 autoplay: true,
                 autoplayDuration: Duration(milliseconds: 10000) ,
                 animationCurve: Curves.fastOutSlowIn,
                 animationDuration: Duration(milliseconds: 1000),
                 dotSize: 6.0,
                 dotIncreasedColor: Colors.blueAccent,
                 dotColor: Colors.black,
                 dotBgColor: Colors.transparent,
                 dotPosition: DotPosition.bottomCenter,
                 dotVerticalPadding: 10.0,
                 showIndicator: false,
                 indicatorBgPadding: 7.0,
          ),
            
          ),
           SizedBox(height: 20.0,),
        
       
    Card(
           
         color: Colors.white,
         elevation: 5,
         child:Container(

           decoration: BoxDecoration(
             
           border: Border.all(
        color: Colors.blueAccent, width: 1  // red as border color
          ),
          borderRadius: BorderRadius.all(Radius.circular(3.0)
      ),
        ),
         
       child :ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 
        18.0),
        dense:true,
      leading: Icon(Icons.analytics , color: Colors.blueAccent, size: 25,),
      tileColor: Colors.transparent,
      subtitle: Center (child :Text("")) ,
      isThreeLine: true,
      //contentPadding: EdgeInsets.all(10),
      trailing: Icon(Icons.navigate_next_rounded , color: Colors.blueAccent,size : 30) ,
      onTap: gettype ,
      title: Text( 'inscrire votre resultat de test de diabéte',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15 , color: Colors.black),) ,
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.horizontal(right: Radius.circular(3)),
     
         ),
      
      
      ),
      )
      ),
SizedBox(width: 20) ,
 Card(
         color: Colors.transparent,
         elevation: 5,
         
       child :
       Container(
          decoration: BoxDecoration(
             
           border: Border.all(
        color: Colors.pinkAccent, width: 1  // red as border color
          ),
          borderRadius: BorderRadius.all(Radius.circular(3.0)
      ),
        ),
         
         
         child :
       
       ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 
        18.0),
        dense:true,
      leading: Icon(Icons.calendar_today , color: Colors.pinkAccent, size: 25,),
      tileColor: Colors.white,
      subtitle: Center (child :Text("")) ,
      isThreeLine: true,
      //contentPadding: EdgeInsets.all(10),
      trailing: Icon(Icons.navigate_next_rounded , color: Colors.pinkAccent,size : 30) ,
      onTap: (){
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => demanderdv(),));

      },
      title: Text( 'demander un rendez-vous avec votre médecin',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15 , color: Colors.black),) ,
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.horizontal(right: Radius.circular(3)),
     
         ),
      
      
      ),),),
       Card(
         color: Colors.transparent,
         elevation: 5,
         
       child :
       Container(
          decoration: BoxDecoration(
             
           border: Border.all(
        color: Colors.deepPurpleAccent, width: 1  // red as border color
          ),
          borderRadius: BorderRadius.all(Radius.circular(3.0)
      ),
        ),
         
         
         child :
       
       ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 
        18.0),
        dense:true,
      leading: Icon(Icons.book , color: Colors.greenAccent, size: 25,),
      tileColor: Colors.white,
      subtitle: Center (child :Text("")) ,
      isThreeLine: true,
      //contentPadding: EdgeInsets.all(10),
      trailing: Icon(Icons.navigate_next_rounded , color: Colors.greenAccent,size : 30) ,
      onTap: (){
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => conseils(),));

      },
      title: Text( 'Conseils pour les patients diabétiques',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15 , color: Colors.black),) ,
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.horizontal(right: Radius.circular(3)),
     
         ),
      
      
      ),),),
      Card(
         color: Colors.transparent,
         elevation: 5,
         
       child :
       Container(
          decoration: BoxDecoration(
             
           border: Border.all(
        color: Colors.deepPurpleAccent, width: 1  // red as border color
          ),
          borderRadius: BorderRadius.all(Radius.circular(3.0)
      ),
        ),
         
         
         child :
       
       ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 
        18.0),
        dense:true,
      leading: Icon(Icons.book , color: Colors.deepPurpleAccent, size: 25,),
      tileColor: Colors.white,
      subtitle: Center (child :Text("")) ,
      isThreeLine: true,
      //contentPadding: EdgeInsets.all(10),
      trailing: Icon(Icons.navigate_next_rounded , color: Colors.deepPurpleAccent,size : 30) ,
      onTap: (){
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => demanderdv(),));

      },
      title: Text( 'Actualité de COVID-19 dans  le monde ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15 , color: Colors.black),) ,
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.horizontal(right: Radius.circular(3)),
     
         ),
      
      
      ),),),





       ] ));
  }
}

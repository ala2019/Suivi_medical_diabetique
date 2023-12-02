import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:suivi_medical/patient/changermdpp.dart';
import 'package:suivi_medical/patient/conversation_patient.dart';
import 'package:suivi_medical/patient/login_patient.dart';
import 'package:suivi_medical/patient/modifierprofile.dart';

import '../first_page.dart';

String index ;

class profile_patient extends StatefulWidget {
  @override
  _profile_patientState createState() => _profile_patientState();
}

class _profile_patientState extends State<profile_patient> {
List dosspt=[] ;
  List pt=[] ;

  @override
           void initState() {
           super.initState();
            _loadCounter();
            getpatient().then((value) {
      setState(() {
        pt = value;
      });
    });
      getdosspatient().then((value1) {
      setState(() {
        dosspt = value1;
      });
    });
  }
  

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      index = (prefs.getString('index') ?? '');
      
      
    });
  }

  Future<List> getpatient() async {
    List rp1= new List();
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/patient_controllers/getpatient.php",
        body: {
          "index" : index.toString() ,
          
           
        }
        );
      
          rp1 = json.decode(response.body.toString()) ;
          
        
        return rp1 ;
             
    }  
  
    Future<List> getdosspatient() async {
    List rp= new List();
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/dossiermedical_controllers/dossiermed.php",
        body: {
          "index" : index.toString() ,
          
           
        }
        );
       
          rp = json.decode(response.body.toString()) ;
          
        
        return rp ;
            
    }  

  




  @override
  Widget build(BuildContext context) {
    
   print (pt) ;
   print(dosspt) ;
  
   return  MaterialApp(
    debugShowCheckedModeBanner: false,
    home : Scaffold(

      appBar: AppBar(
         centerTitle: true,
        title: Text('Profile'),
          actions: <Widget>[
    Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
                 _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
           await prefs.clear();
  }
  _incrementCounter();
           
            Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => firstpage()),
      );

        },
        child: Icon(
          Icons.logout,
          size: 26.0,
        ),
      )
    ),]
        ),

      body: pt==null  
   ? Center(child: CircularProgressIndicator(strokeWidth: 1.0,))
   
     
      :Column(
      children: <Widget> [
        Container(height:20),
        Center(child:
        Container(
          
          decoration: BoxDecoration(

           border: Border.all(color: Colors.blueAccent,width: 1),
           borderRadius: BorderRadius.all(Radius.circular(
                            60.0),)
          ),
            height: 100,
          width:100,
           child: CircleAvatar(
                      radius: 60.0,
                      backgroundColor: const Color(0xFF778899),
                      backgroundImage: pt[0]['image'] != null



 
                  ?  NetworkImage("http://192.168.43.4:8080/suivimedical/controller/patient_controllers/uploads/"+pt[0]['image'])
                    
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.blueAccent,width: 2),
                          borderRadius: BorderRadius.circular(100)),
                      width: 120,
                      height: 120,
                      child: Icon(
                        Icons.person,
                        color: Colors.blueAccent,
                      ),
                    ),
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      // for Network image

                    ),
                       ),
                       ),
    Container(height: 5,),
    
    Center(child :
    Text(dosspt[0]['nom_patient']+" "+dosspt[0]['prenom_patient'],style:TextStyle( fontSize: 18 , fontWeight: FontWeight.bold)),
    
    ),
    Container(height: 20,),
   /* Card(
     elevation: 7,
     child:*/ Column(children: [
      ListTile(leading: Icon(Icons.person,color: Colors.blueAccent,),
                    title : Text(pt[0]['username'].toString()),),
                    ListTile(leading: Icon(Icons.email,color: Colors.blueAccent,),
                    title : Text(dosspt[0]['email'].toString()),),
                    ListTile(leading: Icon(Icons.call,color: Colors.blueAccent,),
                    title : Text(dosspt[0]['telephone1'].toString()),),
                     ListTile(leading: Icon(Icons.map,color: Colors.blueAccent,),
                    title : Text(dosspt[0]['déligation_de_residence'].toString()),),
                    Container(height: 10,),
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
                     /* Navigator.push(context,
                      MaterialPageRoute(builder: (context) => modifierprofilepatient(id:idmed , usern : med[0]['username'].toString() , tele : med[0]['gsm'] , emailm : med[0]['email'].toString()) ,));
                  */

                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => mdfprofilepatient(index: index , usernp : pt[0]['username'].toString() , telp : dosspt[0]['telephone1'] , emailp : dosspt[0]['email'].toString() , adressep : dosspt[0]['déligation_de_residence'].toString() ) ,));
                  
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('modifier profile',
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
              Container(height: 5,),

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
                       MaterialPageRoute(builder: (context) => changermdpp(index:index , pass : pt[0]['password'].toString() )),
                        );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('modifier mot de passe',
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
//Container(height: 10,),


     ],),


   // )


      ],


      )
       
    
    ),
    ) ;
  }
}
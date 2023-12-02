

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:suivi_medical/first_page.dart';
import 'package:suivi_medical/m%C3%A9decin/changermdp.dart';
import 'package:suivi_medical/m%C3%A9decin/mdfprofile.dart';

import 'login_médecin.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
int idmed  ;




class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {



  @override
           void initState() {
           super.initState();
            _loadCounter();
            getmed().then((value) {
      setState(() {
        med = value;
      });
    });
            //print(idmed);
            
            
           
  }
  

 _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idmed = (prefs.getInt('idmed') ?? 0);
     

      
      
    });
  }
  List med=[] ;
   Future<List> getmed() async {
    List data = new List();
     
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/medecin_controllers/getmed.php",
        body: {
           
           "idmed": idmed.toString()
        });
        //headers: {"Accept": "application/json"});

        data = json.decode(response.body) ;
        //print(data[0]) ;
       
        return data ;
       
  }
  @override
  Widget build(BuildContext context) {

    

    
    return MaterialApp(
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

      body:
     
      Column(
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
                      backgroundImage: NetworkImage("http://192.168.43.4:8080/suivimedical/controller/medecin_controllers/uploads/"+med[0]['image']), // for Network image

                    ),
                       ),
                       ),
    Container(height: 5,),
    
    Center(child :
    Text(med[0]['nom']+" "+med[0]['prenom'],style:TextStyle( fontSize: 18 , fontWeight: FontWeight.bold)),
    
    ),
    Container(height: 20,),
   /* Card(
     elevation: 7,
     child:*/ Column(children: [
      ListTile(leading: Icon(Icons.person,color: Colors.blueAccent,),
                    title : Text(med[0]['username'].toString()),),
                    ListTile(leading: Icon(Icons.email,color: Colors.blueAccent,),
                    title : Text(med[0]['email'].toString()),),
                    ListTile(leading: Icon(Icons.call,color: Colors.blueAccent,),
                    title : Text(med[0]['gsm'].toString()),),
                     ListTile(leading: Icon(Icons.security,color: Colors.blueAccent,),
                    title : Text("********")),
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
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => modifierprofile(id:idmed , usern : med[0]['username'].toString() , tele : med[0]['gsm'] , emailm : med[0]['email'].toString()) ,));
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
                       MaterialPageRoute(builder: (context) => changermdp(id:idmed , password : med[0]['password'].toString() )),
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

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:suivi_medical/m%C3%A9decin/rendezvous.dart';
import 'package:suivi_medical/patient/notificationpatient.dart';
import 'rendezvous_patient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_patient.dart';
import 'conversation_patient.dart';
import 'accueil_patient.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:async';
String index;


class page_accueil_patient extends StatefulWidget {
  List senddata ;
   page_accueil_patient({this.senddata}) ;
  @override
  _page_accueil_patientState createState() => _page_accueil_patientState(senddata);
}

class _page_accueil_patientState extends State<page_accueil_patient> {
   int _currentindex = 0;
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
    prefs.setInt('idmedecin', id_med);
    prefs.setInt('num_dossier', num_d);
    print(id_med);
  } 
  _incrementCounter();
  print(datadm) ;
         
      
       

  }

   @override
           void initState() {
           super.initState();
            _loadCounter();
            gettype() ;
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      index = (prefs.getString('index') ?? '') ;
      
      
    });
  }
  

   
    
  
  
   
  final List<Widget> _children = [
    accueil_patient(),
    rendezvous_patient(),
   
    conversation_patient(),
    notpatient(),
    profile_patient()
  ];
  final tabs = [
    Center(
        child: Text(
      'Accueil',
      style: TextStyle(fontSize: 30),
    )),
    Center(
        child: Text(
      'Rendez-vous',
      style: TextStyle(fontSize: 30),
    )),
    Center(
        child: Text(
      'Conversation',
      style: TextStyle(fontSize: 30),
    )),
    Center(
        child: Text(
      'notification',
      style: TextStyle(fontSize: 30),
    )),
    Center(
        child: Text(
      'Profile',
      style: TextStyle(fontSize: 30),
    ))
  ];
   List senddata ;
   _page_accueil_patientState(this.senddata) ;
   
  
    
  

  @override
 
  
  Widget build(BuildContext context) {
   
    
     return Scaffold(
      /*appBar: AppBar(
        title: Text(senddata[0]['username'])
        
      ),*/
      body: _children[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        type: BottomNavigationBarType.fixed,
        iconSize: 25,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('home'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              title: Text('Rendez-vous'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text('conversation'),
              backgroundColor: Colors.blue),
              BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text('notification'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('profile'),
              backgroundColor: Colors.blue),
        ],
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },
      ),
    );
  }
}
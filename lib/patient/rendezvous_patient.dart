

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suivi_medical/m%C3%A9decin/demandesrdv.dart';
import 'package:suivi_medical/m%C3%A9decin/profile.dart';
import 'package:suivi_medical/patient/profile_patient.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel ;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
String indexpt ;



class rendezvous_patient extends StatefulWidget {
  @override
  _rendezvous_patientState createState() => _rendezvous_patientState();
}

class _rendezvous_patientState extends State<rendezvous_patient> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
  length: 2,
    child : Scaffold(
      appBar: AppBar(
      bottom: TabBar(
        tabs: [
          Tab(child:Text("passés")),
          Tab(child:Text("A lavenir")),
          //Tab(icon: Icon(Icons.directions_car)),
        ],
      ),
      title: Text('Rendez vous'),
    ),
    body:TabBarView(
      children: <Widget>[
        passe() ,
        avenir(),
      ], 


    ),),);
  }
}

class passe extends StatefulWidget {
  @override
  _passeState createState() => _passeState();
}

class _passeState extends State<passe> {


  @override
           void initState() {
           super.initState();
            _loadCounter();
           
           
            
           
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
     
      indexpt = (prefs.getString('index') ?? '');

      
      
    });
  }



  
  @override
  Widget build(BuildContext context) {
    Future<List> getrdvpasse() async {
    List rp;
    List rp1=[] ;
   
     
   
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/getrdvpatient.php",
        body: {
         
          "index" : indexpt.toString() ,

           
           
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
       
          rp = json.decode(response.body) ;
          print(rp) ;
           for (var i=0 ; i < rp.length;i++){
       
        if (rp[i]['statuts']=="donne" || rp[i]['statuts']=="modifié" || rp[i]['statuts']=="accepté"){
           DateTime date = DateTime.tryParse(rp[i]['date_rdv']+" "+rp[i]['time_rdv']) ; 
           if (date.isBefore(DateTime.now())){
        rp1.add(rp[i]); }
      }}
        
       
        
       
        return rp1 ;
         
     

  }
    return Center(
          child: FutureBuilder <List>(
            future: getrdvpasse(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List data = snapshot.data;
                return 
                ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                 /* print(data[index]['date_rdv']);

                  DateTime date = DateTime.tryParse(data[index]['date_rdv']+" "+data[index]['time_rdv']) ;
                  print (date) ;
                  
                 
                 if (date.isBefore(DateTime.now())){*/
                
                  return 
                  ListTile(
                    leading: Icon(Icons.calendar_today_sharp,color: Colors.blueAccent,),
                    title : Text(data[index]['date_rdv'].toString()),
                    subtitle: Text(data[index]['time_rdv'].toString()),
                  ); 
                  
                 }

                   
                
              );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),);
  }
}


class avenir extends StatefulWidget {
  @override
  _avenirState createState() => _avenirState();
}

class _avenirState extends State<avenir> {


   @override
           void initState() {
           super.initState();
            _loadCounter();
            print(indexpt);
           
            
           
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
     
      indexpt = (prefs.getString('index') ?? '');

      
      
    });
  }



 
  @override
  Widget build(BuildContext context) {

     Future<List> getrdvavenir() async {
    List rp;
    List rp1=[] ;
   
     
   
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/getrdvpatient.php",
        body: {
         
          "index" : indexpt.toString() ,

           
           
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
       
          rp = json.decode(response.body) ;
          //print(rp) ;
          for (var i=0 ; i < rp.length;i++){
        
        if ((rp[i]['statuts']=="donne" || rp[i]['statuts']=="modifié" || rp[i]['statuts']=="accepté" ) ){
        DateTime date = DateTime.tryParse(rp[i]['date_rdv']+" "+rp[i]['time_rdv']) ; 
        if (date.isAfter(DateTime.now())){
        rp1.add(rp[i]); }
      }}
        
       
        
       
        return rp1 ;
         
     

  }
    return Center(
          child: FutureBuilder <List>(
            future: getrdvavenir(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List data = snapshot.data;
                return 
                ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                 /* print(data[index]['date_rdv']);

                  DateTime date = DateTime.tryParse(data[index]['date_rdv']+" "+data[index]['time_rdv']) ;
                  print (date) ;
                  DateTime datenow = DateTime.now() ;
                  //print (DateTime.now());
                  
                 
                 if (date.isAfter(datenow)){*/
                
                  return 
                  ListTile(
                    leading: Icon(Icons.calendar_today_sharp,color: Colors.blueAccent,),
                    title : Text(data[index]['date_rdv'].toString()),
                    subtitle: Text(data[index]['time_rdv'].toString()),
                  ); 
                  
                 }

                   
                
              );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),);
  }
}

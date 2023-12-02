import 'dart:core';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suivi_medical/m%C3%A9decin/donnerrdv.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel ;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:suivi_medical/m%C3%A9decin/modifierrdv.dart';
import 'package:table_calendar/table_calendar.dart' show TableCalendar;
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_slidable/flutter_slidable.dart';



int id_med ;
String nom ;
String prenom ;

 
 List  jsonResponse1=[]  ;


  Future <List<Data1>> getrdv() async {
      final List<Appointment> appointments = <Appointment>[];
      List jsonResponse =[];

  
  final response =
      await http.post('http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/getrdv.php', body: {
           "id_med" : id_med.toString() ,
           
        });
  if (response.statusCode == 200) {
   
    
    jsonResponse1 = json.decode(response.body);
    
    print(jsonResponse1) ;
    
    for (var i=0 ; i < jsonResponse1.length;i++){
      //print(jsonResponse1[i]);
      if (jsonResponse1[i]['statuts']=="donne"){
        jsonResponse.add(jsonResponse1[i]); 
      }
    } 
     
   


   // print(jsonResponse) ;


    //return jsonResponse ;
    
    //return jsonResponse.map((data) => new Data1.fromJson(data)).toList();
     return jsonResponse.map((data) => new Data1.fromJson(data)).toList();
   
    


    
   
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data1 {
  final String id ;
  final String  date_rdv;
  final String time_rdv ;
  
  final String statuts;
  final String patient_index;
  final String idmed ;

  Data1({this.id, this.date_rdv , this.time_rdv,this.statuts,this.patient_index,this.idmed});

  factory Data1.fromJson(Map<String,dynamic> json) {
    return Data1(
      id: json['id'] == null ? null : json['id'] as String,
      date_rdv:json['date_rdv'] == null ? null : json['date_rdv'] as String,
      time_rdv: json['time_rdv'] == null ? null : json['time_rdv'] as String,
      statuts:json['statuts'] == null ? null : json['statuts'] as String,
      patient_index:json['patient_index'] == null ? null : json['patient_index'] as String,
      idmed:json['medecin_idmedecin'] == null ? null : json['medecin_idmedecin'] as String,
    );
  }
}

  


class rendezvous extends StatefulWidget {
  @override
  _rendezvousState createState() => _rendezvousState();
}

class _rendezvousState extends State<rendezvous> {
  Future <List<Data1>> futureData;
    TabController _tabController;

  

  List<Appointment> _appointmentDetails=<Appointment>[];

    @override
           void initState() {
           super.initState();
            _loadCounter();
            futureData = getrdv();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_med = (prefs.getInt('idmed') ?? 0);
      nom = (prefs.getString('nommedecin') ?? "");
      prenom = (prefs.getString('prenommedecin') ?? "");
      
      
    });
  }

  




 
   
    @override
    Widget build(BuildContext context) {
      
      return  DefaultTabController(
                 length: 3,
                 initialIndex: 0,
      
      
            child :  /* Scaffold(
      
      body:*/ Column(
          children: <Widget>[
             SfCalendar(
                view: CalendarView.month,
                dataSource: getCalendarDataSource(),
               // onTap: calendarTapped,
              ),
               
              
               TabBar(tabs: [
              Tab(child:Text("passés",style: TextStyle(color : Colors.black),)),
              Tab(child:Text("aujourdhui",style: TextStyle(color : Colors.black),)),
              Tab(child:Text("a l avenir",style: TextStyle(color : Colors.black),)),

              ] ,
              controller: _tabController,
              ),
              
              Expanded(child:  TabBarView(
                children: <Widget>[
                  passe() ,
                  
                  today() ,

                  avenir()

        
                   ], 
                  controller: _tabController,


    ),)
            
          ],
      ) );
    
      
    }

   

 


  _DataSource getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    Future <List<Data1>> futureData;
  

 // List<Appointment> _appointmentDetails=<Appointment>[];

    @override
           void initState() {
           super.initState();
            //_loadCounter();
            futureData = getrdv();
  }
      
      print(futureData.toString()) ;
     FutureBuilder <List<Data1>> (
        future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Data1> data = snapshot.data;
                for(int i ; i< data.length ; i++){

                 appointments.add(Appointment(
                 startTime: DateTime.parse(data[i].date_rdv+''+data[i].time_rdv),
                 endTime: DateTime.parse((data[i].date_rdv+''+data[i].time_rdv)),
                 subject: 'render_vous',
                 color: Color(0xFFfb21f66),
                 )); }


                
                }
                
                
                }


     ) ;
   

  
   
    
    
   
    
             
   

    return _DataSource(appointments);
  }

 

  


  }
  class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}


class passe extends StatefulWidget {
  List  jsonResponse1=[]  ;


  
  @override
  _passeState createState() => _passeState();
}

class _passeState extends State<passe> {

   Future <List<Data1>> futureData;
  

  List<Appointment> _appointmentDetails=<Appointment>[];

    @override
           void initState() {
           super.initState();
            _loadCounter();
            futureData = getrdv();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_med = (prefs.getInt('idmed') ?? 0);
      
      
    });
  }


  @override
  Widget build(BuildContext context) {

    Future <List<Data1>> getrdvpasse() async {
     // final List<Appointment> appointments = <Appointment>[];
      List jsonResponse =[];

  
  final response =
      await http.post('http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/getrdv.php', body: {
           "id_med" : id_med.toString() ,
           
        });
  if (response.statusCode == 200) {
   
    
    jsonResponse1 = json.decode(response.body);
    
    //print(jsonResponse1) ;
    DateTime now = DateTime.now() ;
    //final f = new DateFormat('yyyy-MM-dd hh:mm');

     //Text(f.format(new DateTime.fromMillisecondsSinceEpoch(values[index]["start_time"]*1000)));
    
    for (var i=0 ; i < jsonResponse1.length;i++){
      
       
        if ((jsonResponse1[i]['statuts']=="donne" || jsonResponse1[i]['statuts']=="modifié" || jsonResponse1[i]['statuts']=="accepté" )){
           DateTime date = DateTime.tryParse((jsonResponse1[i]['date_rdv']+" "+jsonResponse1[i]['time_rdv']) as String) ;  
           if ( now.isAfter(date)){
        jsonResponse.add(jsonResponse1[i]); 
      }}
    } 
     return jsonResponse.map((data) => new Data1.fromJson(data)).toList(); 
  } else {
    throw Exception('Unexpected error occured!');
  }
}
    return  FutureBuilder <List<Data1>>(
            future: getrdvpasse(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Data1> data = snapshot.data;
                return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                //resizeToAvoidBottomPadding: false,

                itemCount: data.length,
                
                itemBuilder: (BuildContext context, int index) {
                 print(data[index].date_rdv);

                  DateTime date = DateTime.tryParse(data[index].date_rdv+" "+data[index].time_rdv) ;
                  print (date) ;
                  
                 
                // if (date.isBefore(DateTime.now())){
                  if (date.isBefore(DateTime.now())){
                

                
                   return  Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      //delegate: new SlidableDrawerDelegate(),
                      actionExtentRatio: 0.25,
                      child:  Container(
                       
                          



                            
                            
                       
                      color: Colors.white,
                      child:  Card(
                        child: Container(
                           width: 200,
                            height: 60,
                          



                            
                             decoration: BoxDecoration(
                             border: Border.all(width: 2.0,color: Colors.blueAccent),
                             borderRadius: BorderRadius.all(Radius.circular(7.0)
                            
                              ),),
                                  child: Row(
                                 children: <Widget>[

                                Container(margin: EdgeInsets.all(10),child: Text(data[index].patient_index)),
                                  Text("       "),
                                 Container(height: 20,width: 2,color: Colors.blueAccent,),
                                Container(margin:EdgeInsets.only(top:10,bottom: 10,left:10),child: 
                                Column(children: <Widget>[
                                   Text(data[index].date_rdv,style:TextStyle( fontSize: 15),textAlign:TextAlign.start,),
                                  // Text(data[index].prenom,style:TextStyle( fontSize: 15),textAlign:TextAlign.start,),
                                   Text(data[index].time_rdv,style:TextStyle( fontSize: 15))


                                ],
                                )
                                )
                                        ],
                                            ),



                        ),
                     /* leading:Text(data[index].patient_index),
                       title: Text(data[index].date_rdv.toString()),
                      subtitle:  Text(data[index].time_rdv.toString()),*/
                      ),
                       ),
 
                      secondaryActions: <Widget>[
                       IconSlideAction(
                      caption: 'modifier',
                      color: Colors.greenAccent,
                      icon: Icons.edit ,
                      onTap: (){
                          Navigator.push(
                             context,
                           MaterialPageRoute(builder: (context) => modifierrdv(id: snapshot.data[index].id , date: snapshot.data[index].date_rdv,time :snapshot.data[index].time_rdv,idmed : id_med)),
                              );


                      },
                      ),
                        IconSlideAction(
                       caption: 'Anuuler',
                       color: Colors.red,
                      icon: Icons.delete,
                       onTap:(){
      Future<void> _showMyDialog() async {
      return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Annuler rendez vous'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                print(snapshot.data[index].id);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } 
  _showMyDialog() ;



                       },
                       ),
                       ],
                      
                       );}
                        else {
                        print(index+1) ;
                       }
                  
                },
                );
                  
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("${snapshot.error}");
                
              }
              // By default show a loading spinner.
              return Center (child :CircularProgressIndicator());
              
              
            },
          
           
          
            );
            
  }
}


class today extends StatefulWidget {
  @override
  _todayState createState() => _todayState();
}

class _todayState extends State<today> {
   Future <List<Data1>> futureData;
  

  List<Appointment> _appointmentDetails=<Appointment>[];

    @override
           void initState() {
           super.initState();
            _loadCounter();
            futureData = getrdv();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_med = (prefs.getInt('idmed') ?? 0);
       nom = (prefs.getString('nommedecin') ?? "");
      prenom = (prefs.getString('prenommedecin') ?? "");
      
    });
  }
  @override
  Widget build(BuildContext context) {
    Future <List<Data1>> getrdvtoday() async {
     
      List jsonResponse =[];

  
  final response =
      await http.post('http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/getrdv.php', body: {
           "id_med" : id_med.toString() ,
           
        });
  if (response.statusCode == 200) {
   
    
    jsonResponse1 = json.decode(response.body);
    
    print(jsonResponse1) ;
    
    for (var i=0 ; i < jsonResponse1.length;i++){
        
        if ((jsonResponse1[i]['statuts']=="donne" || jsonResponse1[i]['statuts']=="modifié" || jsonResponse1[i]['statuts']=="accepté") ){
         DateTime date = DateTime.tryParse(jsonResponse1[i]['date_rdv']+" "+jsonResponse1[i]['time_rdv']) ;
         if (/*DateTime.now().difference(date).inDays == 0*/DateTime.now().month ==date.month && DateTime.now().day==date.day && DateTime.now().year==date.year ){
        jsonResponse.add(jsonResponse1[i]); }
      }
    } 
     return jsonResponse.map((data) => new Data1.fromJson(data)).toList(); 
  } else {
    throw Exception('Unexpected error occured!');
  }
}
    return  FutureBuilder <List<Data1>>(
            future: getrdvtoday(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Data1> data = snapshot.data;
                return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                //resizeToAvoidBottomPadding: false,

                itemCount: data.length,
                
                itemBuilder: (BuildContext context, int index) {
                 
                

                
                   return  Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      //delegate: new SlidableDrawerDelegate(),
                      actionExtentRatio: 0.25,
                      child:  Container(
                       
                          



                            
                            
                       
                      color: Colors.white,
                      child:  Card(
                        child: Container(
                           width: 200,
                            height: 60,
                          



                            
                             decoration: BoxDecoration(
                             border: Border.all(width: 2.0,color: Colors.blueAccent),
                             borderRadius: BorderRadius.all(Radius.circular(7.0)
                            
                              ),),
                                  child: Row(
                                 children: <Widget>[

                                Container(margin: EdgeInsets.all(10),child: Text(data[index].patient_index)),
                                  Text("       "),
                                 Container(height: 20,width: 2,color: Colors.blueAccent,),
                                Container(margin:EdgeInsets.only(top:10,bottom: 10,left:10),child: 
                                Column(children: <Widget>[
                                   Text(data[index].date_rdv,style:TextStyle( fontSize: 15),textAlign:TextAlign.start,),
                                  // Text(data[index].prenom,style:TextStyle( fontSize: 15),textAlign:TextAlign.start,),
                                   Text(data[index].time_rdv,style:TextStyle( fontSize: 15))


                                ],
                                )
                                )
                                        ],
                                            ),



                        ),
                    
                      ),
                       ),
 
                      secondaryActions: <Widget>[
                       IconSlideAction(
                      caption: 'modifier',
                      color: Colors.greenAccent,
                      icon: Icons.edit ,
                      onTap: (){
                          Navigator.push(
                             context,
                           MaterialPageRoute(builder: (context) => modifierrdv(id: snapshot.data[index].id , date: snapshot.data[index].date_rdv,time :snapshot.data[index].time_rdv,idmed : id_med)),
                              );


                      },
                      ),
                        IconSlideAction(
                       caption: 'Anuuler',
                       color: Colors.red,
                      icon: Icons.delete,
                       onTap:(){
      Future<void> _showMyDialog() async {
      return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Annuler rendez vous'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('confirmer'),
              onPressed: () {
                print(snapshot.data[index].id);
      Future <String> anuulerrdv() async {
      
      final response =
      await http.post('http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/annullerrdv.php', body: {
      "idrdv" : snapshot.data[index].id.toString() ,
      "statut" : "annullé"
       });
      if (response.statusCode == 200) {
      String reponse  = json.decode(response.body);
      print(reponse ) ;
      return reponse ;
      } else {
      throw Exception('Unexpected error occured!');
      }
      }
      anuulerrdv();
    
     
       Future<String> addnot() async {
    String rp;
    String title = ("Dr "+nom+" "+prenom) ;
    String date = snapshot.data[index].date_rdv ;
    String heure = snapshot.data[index].time_rdv ;
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/notifications_controllers/addnot.php",
        body: {
          "title" : title.toString() ,
          "contenu" : ("Votre médecin a annulé votre rendez-vous que pragrammé le $date $heure   ").toString() ,

           "date" : DateFormat("yyyy-MM-dd").format(DateTime.now()).toString() ,
           "heure" : DateFormat("hh:mm:ss").format(DateTime.now()).toString() ,
           "index" : snapshot.data[index].patient_index.toString() , 
           "idmed" : id_med.toString(),
           "sender" : id_med.toString()
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
       setState(() {
          rp = json.decode(response.body.toString()) ;
        print(rp) ;
          });  
          return rp ;  
    } 
    addnot();
      Fluttertoast.showToast(
                     msg: "Rendez vous annullé",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     //backgroundColor: Colors.greenAccent,

                     );
      Navigator.of(context).pop();
      },
      ),
            TextButton(
              child: Text('anuuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } 
  _showMyDialog() ;



                       },
                       ),
                       ],
                      
                       );
                  
                },
                );
                  
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("${snapshot.error}");
                
              }
              // By default show a loading spinner.
              return Center (child :CircularProgressIndicator());
              
              
            },
          
           
          
            );
  }
}


class avenir extends StatefulWidget {
  @override
  _avenirState createState() => _avenirState();
}

class _avenirState extends State<avenir> {

   Future <List<Data1>> futureData;
  

  List<Appointment> _appointmentDetails=<Appointment>[];

    @override
           void initState() {
           super.initState();
            _loadCounter();
            futureData = getrdv();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_med = (prefs.getInt('idmed') ?? 0);
      
      
    });
  }
  @override
  Widget build(BuildContext context) {
    Future <List<Data1>> getrdvavenir() async {
      //final List<Appointment> appointments = <Appointment>[];
      List jsonResponse =[];

  
  final response =
      await http.post('http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/getrdv.php', body: {
           "id_med" : id_med.toString() ,
           
        });
  if (response.statusCode == 200) {
   
    
    jsonResponse1 = json.decode(response.body);
    
    print(jsonResponse1) ;
    
    for (var i=0 ; i < jsonResponse1.length;i++){
      //DateTime time = DateTime.tryParse(jsonResponse1[i]['time_rdv']) ;
      //print (jsonResponse1[i]['time_rdv']) ;
       
       //print (date) ; 
        if ((jsonResponse1[i]['statuts']=="donne" || jsonResponse1[i]['statuts']=="modifié" || jsonResponse1[i]['statuts']=="accepté" ) ){
        DateTime date = DateTime.tryParse(jsonResponse1[i]['date_rdv']+" "+jsonResponse1[i]['time_rdv']) ; 
        if(DateTime.now().isBefore(date)){
        jsonResponse.add(jsonResponse1[i]); }
      }
    } 
     return jsonResponse.map((data) => new Data1.fromJson(data)).toList(); 
  } else {
    throw Exception('Unexpected error occured!');
  }
}
    return FutureBuilder <List<Data1>>(
            future: getrdvavenir(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Data1> data = snapshot.data;
                return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                //resizeToAvoidBottomPadding: false,

                itemCount: data.length,
                
                itemBuilder: (BuildContext context, int index) {
                
                

                
                   return  Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      //delegate: new SlidableDrawerDelegate(),
                      actionExtentRatio: 0.25,
                      child:  Container(
                       
                          



                            
                            
                       
                      color: Colors.white,
                      child:  Card(
                        child: Container(
                           width: 200,
                            height: 60,
                          



                            
                             decoration: BoxDecoration(
                             border: Border.all(width: 2.0,color: Colors.blueAccent),
                             borderRadius: BorderRadius.all(Radius.circular(7.0)
                            
                              ),),
                                  child: Row(
                                 children: <Widget>[

                                Container(margin: EdgeInsets.all(10),child: Text(data[index].patient_index)),
                                  Text("       "),
                                 Container(height: 20,width: 2,color: Colors.blueAccent,),
                                Container(margin:EdgeInsets.only(top:10,bottom: 10,left:10),child: 
                                Column(children: <Widget>[
                                   Text(data[index].date_rdv,style:TextStyle( fontSize: 15),textAlign:TextAlign.start,),
                                  // Text(data[index].prenom,style:TextStyle( fontSize: 15),textAlign:TextAlign.start,),
                                   Text(data[index].time_rdv,style:TextStyle( fontSize: 15))


                                ],
                                )
                                )
                                        ],
                                            ),



                        ),
                     
                      ),
                       ),
 
                      secondaryActions: <Widget>[
                       IconSlideAction(
                      caption: 'modifier',
                      color: Colors.greenAccent,
                      icon: Icons.edit ,
                      onTap: (){
                          Navigator.push(
                             context,
                           MaterialPageRoute(builder: (context) => modifierrdv(id: snapshot.data[index].id , date: snapshot.data[index].date_rdv,time :snapshot.data[index].time_rdv,idmed : id_med,index :snapshot.data[index].patient_index)),
                              );


                      },
                      ),
                        IconSlideAction(
                       caption: 'Anuuler',
                       color: Colors.red,
                      icon: Icons.delete,
                       onTap:(){
      Future<void> _showMyDialog() async {
      return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Annuler rendez vous'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //Text('This is a demo alert dialog.'),
                Text('Souhaitez-vous approuver lannulation de cette rendez-vous?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
      Future <String> anuulerrdv() async {
      
      final response =
      await http.post('http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/annullerrdv.php', body: {
      "idrdv" : snapshot.data[index].id.toString() ,
      "statut" : "annullé"
       });
      if (response.statusCode == 200) {
      String reponse  = json.decode(response.body);
      print(reponse ) ;
      return reponse ;
      } else {
      throw Exception('Unexpected error occured!');
      }
      }
      anuulerrdv();
         Future<String> addnot() async {
    String rp;
     String title = ("Dr "+nom+" "+prenom) ;
    String date = snapshot.data[index].date_rdv ;
    String heure = snapshot.data[index].time_rdv ;
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/notifications_controllers/addnot.php",
        body: {
          "title" : title.toString() ,
          "contenu" : ("Votre médecin a annulé votre rendez-vous que pragrammé le $date $heure   ").toString() ,

           "date" : DateFormat("yyyy-MM-dd").format(DateTime.now()).toString() ,
           "heure" : DateFormat("hh:mm:ss").format(DateTime.now()).toString() ,
           "index" : snapshot.data[index].patient_index.toString() , 
           "idmed" : id_med.toString(),
           "sender" : id_med.toString()
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
       setState(() {
          rp = json.decode(response.body.toString()) ;
        print(rp) ;
          });  
          return rp ;  
    }
    addnot();
      Fluttertoast.showToast(
                     msg: "Rendez vous annullé",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     //backgroundColor: Colors.greenAccent,

                     );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                 
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } 
  _showMyDialog() ;



                       },
                       ),
                       ],
                      
                       );}
                      
                  
                
                );
                  
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("${snapshot.error}");
                
              }
              // By default show a loading spinner.
              return Center (child :CircularProgressIndicator());
              
              
            },
          
           
          
            );
  }
}













  
 
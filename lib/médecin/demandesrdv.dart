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
String nomprenom ;
String nom ;
String prenom ;

List  jsonResponse1  ;


  Future <List<Data1>> getrdv() async {
      //final List<Appointment> appointments = <Appointment>[];
   List jsonResponse=[]  ;
  
  final response =
      await http.post('http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/getrdv.php', body: {
           "id_med" : id_med.toString() ,
           
        });
  if (response.statusCode == 200) {
    //print(id_med) ;
    jsonResponse1 = json.decode(response.body);
    
   // print(jsonResponse1) ;
    for (var i=0 ; i < jsonResponse1.length;i++){
      if (jsonResponse1[i]['statuts'].toString()=="demande"){
        jsonResponse.add(jsonResponse1[i]); 
      }
    }


    //print(jsonResponse) ;



    
    return jsonResponse.map((data) => new Data1.fromJson(data)).toList();
   
    


    
   
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data1 {
  final String id ;
  final String  date_rdv;
  final String time_rdv ;
  final String raison ;
  final String note ;
  
  final String statuts;
  final String patient_index;
  final String idmed ;

  Data1({this.id, this.date_rdv , this.time_rdv,this.raison , this.note ,this.statuts,this.patient_index,this.idmed});

  factory Data1.fromJson(Map<String,dynamic> json) {
    return Data1(
      id: json['id'].toString(),
      date_rdv:json['date_rdv'].toString() ,
      time_rdv: json['time_rdv'].toString(),
      raison : json['raison'].toString(),
      note : json['note'].toString(),
      statuts:json['statuts'].toString(),
      patient_index:json['patient_index'].toString(),
      idmed:json['medecin_idmedecin'].toString(),
    );
  }
}


class demandesrdv extends StatefulWidget {
  @override
  _demandesrdvState createState() => _demandesrdvState();
}

class _demandesrdvState extends State<demandesrdv> {

  Future <List<Data1>> futureData;
  

  List<Appointment> _appointmentDetails=<Appointment>[];

    @override
           void initState() {
           super.initState();
            _loadCounter();
            futureData = getrdv();
             getdetailpatient().then((value) {
            setState(() {
             pt = value;
             });
             });
              gettoutrdv().then((value) {
              setState(() {
               rdv = value;
      });
    });


            
            
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_med = (prefs.getInt('idmed') ?? 0);
      nom = (prefs.getString('nommedecin') ?? "");
      prenom = (prefs.getString('prenommedecin') ?? "");
      
    });
  }

  TextEditingController daterdv = TextEditingController();
   TextEditingController timerdv = TextEditingController();
   

  
  final _formKey = GlobalKey<FormState>();

   DateTime currentDate = DateTime.now();
    DateTime _date = new DateTime.now();
      TimeOfDay _time = new TimeOfDay.now();
      Duration initialtimer = new Duration();
      
      TimeOfDay _timePicked;
     
     
    
    Future<Null> _selectedTime(BuildContext context) async {
    _timePicked = await showTimePicker(
        context: context,
        initialTime: _time);

    if (_timePicked != null) {
      setState(() {
        _time =  _timePicked;
        timerdv.text = _time.format(context)  ;

      });
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
      
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate ?? currentDate;
        var date = DateTime.parse(currentDate.toString());
        var formattedDate = "${date.year}-${date.month}-${date.day}";
        daterdv.text= formattedDate.toString() ;
      });
  }


  
  
   var pt ;
   List listpatient  ;
   Future<List> getdetailpatient() async {
    
     
    http.Response response = await http.get(
        "http://192.168.43.4:8080/suivimedical/controller/dossiermedical_controllers/alldossiermed.php",
        headers: {"Accept": "application/json"}
       );
        
        setState(() {
         listpatient = json.decode(response.body) ;
         print(listpatient);
        });
       
       // print(listpatient[0]) ;
       
        return listpatient ;
       
  }
   
  List rdv=[];
    Future <List> gettoutrdv() async {
      List jsonResponse1 =[];
  final response =
      await http.post('http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/getrdv.php', body: {
           "id_med" : id_med.toString() ,  
        });
  if (response.statusCode == 200) {
    jsonResponse1 = json.decode(response.body);
        print(jsonResponse1) ;
    return jsonResponse1 ; 
  } else {
    throw Exception('Unexpected error occured!');
  }
}

  @override
  Widget build(BuildContext context) {
    //print(patient);
    
    return  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Demandes de RDV'),
        ),
        body:
    
    
    
    Container(
      padding: EdgeInsets.only(
                           top: 20),
          child: FutureBuilder <List<Data1>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                futureData = getrdv() ;
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
                                   Text(data[index].raison,style:TextStyle( fontSize: 15),textAlign:TextAlign.start,),
                                  // Text(data[index].prenom,style:TextStyle( fontSize: 15),textAlign:TextAlign.start,),
                                   Text(data[index].note,style:TextStyle( fontSize: 15))


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
                      caption: 'Accepter',
                      color: Colors.greenAccent,
                      icon: Icons.done ,
                      onTap: (){
           
          List ptdossier=[]; 
         for (int i=0;i<pt.length;i++){
          if (pt[i]['patient_index']==data[index].patient_index){
            ptdossier.add(pt[i]);
          }
         }
       
    

  
    
    
  
   
 

           
                          
   Future<void> _showMyDialog() async {
     //print(patient);
      return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          right: -40.0,
                          top: -40.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CircleAvatar(
                              child: Icon(Icons.close),
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                       
                              //SizedBox(height:30),
                         
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                Text("nom  :"+ptdossier[0]['nom_patient']),
                             Text("prenom: "+ptdossier[0]['prenom_patient'])
                             ,
                               Text("date naiss : "+ptdossier[0]['date_naiss'])
                              ,
                             Text("sexe :"+ptdossier[0]['sexe'])
                              ,
                              ptdossier[0]['type_diabete']==null
                               ?Text("type diabéte : aucun type de diabéte")
                               :Text("type diabéte :"+ptdossier[0]['type_diabete'])
                              ,
                               Text("adresse :"+ptdossier[0]['déligation_de_residence'])
                              ,
                              Text("email:"+ptdossier[0]['email'])
                              ,
                               Text("telephone :"+ptdossier[0]['telephone1'])
                              ,
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                    readOnly: true,

                     validator: (value1) {
                          if (value1.isEmpty) {
                            return 'champ invalid';
                          }
                          return null;
                        },
                        controller: daterdv,
                        
                    //obscureText: true,
                    onTap: (){_selectDate(context) ; },
                      

                      

                    
                    
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                      labelText: 'date de rendez-vous',
                    ),
                  ),
                              ),

                              




                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                    readOnly: true,

                     validator: (value1) {
                          if (value1.isEmpty) {
                            return 'champ invalid';
                          }
                          return null;
                        },
                        controller: timerdv,
                    //obscureText: true,
                    onTap: (){_selectedTime(context) ; },
                      

                      

                    
                    
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.timer),
                      border: OutlineInputBorder(),
                      labelText: 'heure de rendez-vous',
                    ),
                  ), 
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text("Accepter"),
                                  color: Colors.blueAccent,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Future<String> addnot() async {
    String rp;
    String title = ("Dr "+nom+" "+prenom) ;
    String datee = daterdv.text ;
    String timee = timerdv.text ;
    print (nomprenom);
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/notifications_controllers/addnot.php",
        body: {
          "title" : title.toString() ,
          "contenu" : ("Votre médecin a accepté votre demande de rendez-vous a $datee $timee").toString() ,

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
    
                                     Future <String> accepterrdv() async {
                                       final response =
                                       await http.post('http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/accepterrdv.php', body: {
                                       "idrdv" : data[index].id.toString() ,
                                       //"statut" : "accepté" ,
                                       "date" : daterdv.text.toString(),
                                       "time" : timerdv.text.toString(),
                                        });
                                      if (response.statusCode == 200) {
                                       String reponse  = json.decode(response.body);
                                       addnot();
                                        Fluttertoast.showToast(
                     msg: "demande accepté",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.greenAccent,
                        
                     );
                                       return reponse ;
                                        
                                         } else {
                                       throw Exception('Unexpected error occured!');
                                       }
                                         }  
                                    if (_formKey.currentState.validate()) {

                                      
                                         bool test= false ;
                       DateTime date = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(daterdv.text+" "+timerdv.text+":00")  ;
                       
                       for (var i=0 ; i<rdv.length ; i++){
                       if(rdv[i]['statuts']=="donne" || rdv[i]['statuts']=="modifié" || rdv[i]['statuts']=="accepté"){
                      DateTime date2 = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(rdv[i]['date_rdv']+" "+rdv[i]['time_rdv']) ;
                       
                     if (date.difference(date2).inMinutes==0){ 
                       test = true ;
                     }
                     }
                     }
                      
                     if ( test== true){
                        Fluttertoast.showToast(
                     msg: "vous avez un rendez-vous dans cette date",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.grey,
                        
                     );
                     }
                     else {
                       setState(() {
                       accepterrdv() ;
                    
        
                       Navigator.of(context).pop();
                                        
                      }); 
                     }
                                       
                                      
                    }
                                    
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
  } 
  _showMyDialog() ;

                      },
                      ),
                        IconSlideAction(
                       caption: 'Refuser',
                       color: Colors.red,
                      icon: Icons.cancel,
                       onTap:(){
      Future<void> _showMyDialog() async {
      return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('refuser rendez vous'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //Text('This is a demo alert dialog.'),
                Text('Souhaitez-vous accepter de refuser ce rendez-vous ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirmer'),
              onPressed: () {
                print(snapshot.data[index].id);
                            Future <String> anuulerrdv() async {
      
                final response =
                  await http.post('http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/annullerrdv.php', body: {
               "idrdv" : snapshot.data[index].id.toString() ,
               "statut" : "refusé"
                });
               if (response.statusCode == 200) {
               String reponse  = json.decode(response.body);
               print(reponse ) ;
               
               return reponse ;
               } else {
               throw Exception('Unexpected error occured!');
                }
                }
                setState(() {
                  anuulerrdv();
                  futureData = getrdv();
                   Future<String> addnot() async {
    String rp;
     String title = ("Dr "+nom+" "+prenom) ;
    
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/notifications_controllers/addnot.php",
        body: {
          "title" : title.toString() ,
          "contenu" : ("Votre médecin a refusé votre demande de rendez-vous ").toString() ,

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
                });
               
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
                      
                       );
                  
                },
                );
                  
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return Center(child:CircularProgressIndicator() ,) ;
              
              
            },
          
           
          
            ),));
      
    
  }
}




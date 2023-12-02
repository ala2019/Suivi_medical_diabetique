import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';
int idmed ;
int num_d ;
String index ;
String nompt ;
class demanderdv extends StatefulWidget {
  @override
  _demanderdvState createState() => _demanderdvState();
}

class _demanderdvState extends State<demanderdv> {
  TextEditingController raison = TextEditingController();
  TextEditingController note = TextEditingController();
  final _formKey = GlobalKey<FormState>();


   @override
           void initState() {
           super.initState();
            _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idmed = (prefs.getInt('id_med') ?? 0);
      num_d = (prefs.getInt('num_d') ?? 0);
      index = (prefs.getString('index') ?? '');
      nompt = (prefs.getString('nomprenom') ?? '');
      
      
    });
  }


  Future<String> demandrdv() async {
    String rp;
   
     
    if (_formKey.currentState.validate()){
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/demanderdv.php",
        body: {
          "idmed" : idmed.toString() ,
          "index" : index.toString() ,

           "raison" : raison.text.toString() ,
           "note" : note.text.toString() ,
           
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
       setState(() {
          rp = json.decode(response.body.toString()) ;
        print(rp) ;
          });
              addnot() ;
          Fluttertoast.showToast(
                     msg: " demande de rendez vous envoyée",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.greenAccent,

                     );
        

        return rp ;

        
       
        
         
    }  

  }

Future<String> addnot() async {
    String rp;
    String title =  index+"  "+nompt ;
    
    
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/notifications_controllers/addnot.php",
        body: {
          "title" : title.toString() ,
          "contenu" : "votre patient a demandé un rendez-vous",

           "date" : DateFormat("yyyy-MM-dd").format(DateTime.now()).toString() ,
           "heure" : DateFormat("hh:mm:ss").format(DateTime.now()).toString() ,
           "index" : index.toString() , 
           "idmed" : idmed.toString(),
           "sender" : index.toString()
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
       setState(() {
          rp = json.decode(response.body.toString()) ;
        print(rp) ;
          });  
          return rp ;  
    } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Demande de render vous'),
        ),
        body: Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 100, bottom: 30),
                child: Form(
               // autovalidate: true,
                key: _formKey,
            child: ListView(
              children: <Widget>[
               
                
               Container(
                 // height: 150,
                 padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                  child: TextFormField(
                     
                    
                    controller: raison,
                    decoration: InputDecoration(
                      
                      prefixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(),
                      labelText: 'Raison',
                    ),
                  ),
                ),
                  
                Container(
                 // height: 150,
                 padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: TextFormField(
                     
                    
                    controller: note,
                    decoration: InputDecoration(
                      
                      prefixIcon: Icon(Icons.comment),
                      border: OutlineInputBorder(),
                      labelText: 'Commentaire',
                    ),
                  ),
                ),

                SizedBox(height: 100),
                
                
                  //showImage(),
                
              
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                  height: 50,
                  //width: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xff374ABE), Color(0xff64B6FF)]),
                    color: Colors.white, // Border Color
                    border: Border.all(width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(
                            7.0) //                 <--- border radius here
                        ),
                  ),
                  child: FlatButton(
                    onPressed:(){ demandrdv();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Valider',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                    /*color: Colors.purple,*/
                  ),
                ),

             
                
                
              ],
            )
            )
    ));
  }
}
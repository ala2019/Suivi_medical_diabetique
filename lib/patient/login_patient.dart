import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suivi_medical/patient/inscrirepatient.dart';
import 'package:wifi/wifi.dart';
import 'package:get_ip/get_ip.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:flutter_ip/flutter_ip.dart';

import 'dart:convert';
import 'dart:async';
import 'package:flutter_session/flutter_session.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:suivi_medical/patient/page_accueil_patient.dart';

class login_patient extends StatefulWidget {
  @override
  _login_patientState createState() => _login_patientState();
}

class _login_patientState extends State<login_patient> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
   final _formKey = GlobalKey<FormState>();
 
  affichemesaage(){

   Fluttertoast.showToast(
                     msg: "Connexion avec succées",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.greenAccent,

                     );
  }
 afficheerreur(){
              Fluttertoast.showToast(
                     msg: "Mot de passe ou username inccorect",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.redAccent,

                     );}
 clickinscrire(){
                             Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => inscrirepatient(),));
                            }
  Future<List> _login() async {
    List data = [];
     
    http.Response response = await http.post(
          
        "http://192.168.43.4:8080/suivimedical/controller/patient_controllers/login.php",
        body: {
           "username" : nameController.text ,
           "password": passwordController.text
        });
    
        data = json.decode(response.body) ;
        
        if (_formKey.currentState.validate()) {

        if (data.length>0){

        

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      index = data[0]["index"];
    });
    prefs.setString('index', index);
  }
  _incrementCounter();



  
  affichemesaage() ;


   Navigator.push(context,
   MaterialPageRoute(builder: (context) => page_accueil_patient(senddata :data),));
                     

          
    
           
    }
            else {
             

               afficheerreur() ;
            }
            }
            return data ;

  }
  
  

 
 
  
  @override
  Widget build(BuildContext context) {
  
   
    return Scaffold(
       
        body: Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 70, bottom: 30),
                child: Form(
               // autovalidate: true,
                key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                     validator: (value) {
                          if (value.isEmpty) {
                            return 'taper votre username svp';
                          }
                          return null;
                        },
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                     validator: (value1) {
                          if (value1.isEmpty) {
                            return 'taper votre mot de passe svp';
                          }
                          return null;
                        },
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.security),
                      border: OutlineInputBorder(),
                      labelText: 'mot de passe',
                    ),
                  ),
                ),
                FlatButton(
                  padding: EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 40, bottom: 30),
                  onPressed: () {
                    //forgot password screen
                  },
                  textColor: Colors.blue,
                  child: Text('Mot de passe oublié'),
                ),
                Container(
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
                    onPressed: _login,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Connecter',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                    /*color: Colors.purple,*/
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 70, bottom: 30),
                    child: Row(
                      children: <Widget>[
                        Text('vous êtes nouveau?'),
                        FlatButton(
                          textColor: Colors.blueAccent,
                          child: Text(
                            'Inscrire',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                           
                            clickinscrire() ;
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            ))));
  }
}

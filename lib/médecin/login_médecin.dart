import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suivi_medical/m%C3%A9decin/inscriremed.dart';



import 'package:suivi_medical/m%C3%A9decin/page_accueil_medecin.dart';

class loginmedecin extends StatefulWidget {
  @override
  _loginmedecinState createState() => _loginmedecinState();
}

class _loginmedecinState extends State<loginmedecin> {
  

   


 
  final _formKey = GlobalKey<FormState>();
   TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int id_med ;
  var islogin = false ;
  
  Future<String> _loginmed() async {
    List data;
    http.Response response = await http.post(
     
        "http://192.168.43.4:8080/suivimedical/controller/medecin_controllers/loginmed.php",
        body: {
           "username" : nameController.text ,
           "password": passwordController.text
        },
        headers:{ 
         "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD"},
        );
        //headers: {"Accept": "application/json"});
        data = json.decode(response.body) ;
        print(data) ;
         if (_formKey.currentState.validate()) {
        if (data.length>0){
          int idmed = int.parse(data[0]["idmedecin"]) ;

           _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_med = idmed;
    });
    prefs.setInt('idmed', id_med);
    prefs.setString('nommedecin', data[0]['nom']);
    prefs.setString('prenommedecin', data[0]['prenom']);
    
    prefs.setBool('islogin', islogin=true) ;
  }
  _incrementCounter();
  Fluttertoast.showToast(
                     msg: "Connexion avec succées",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.greenAccent,

                     );


        Navigator.push(context,
            MaterialPageRoute(builder: (context) => page_acceuil_medecin(),));
        }

        else {
          Fluttertoast.showToast(
                     msg: "username ou mot de passe inccorect",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.redAccent,

                     );
        }
        
        }

  }

  @override


  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
        body: Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 60, bottom: 30),
            child: Form(
               // autovalidate: true,
                key: _formKey,
                child: Column(
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
                       padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 20, bottom: 20),
                      //padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
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
                      width: 340,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Color(0xff374ABE), Color(0xff64B6FF)]),
                        color: Colors.white, // Border Color
                        border: Border.all(width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(7.0) //                 <--- border radius here
                            ),
                      ),
                      child: FlatButton(
                        onPressed: _loginmed
                          

                        ,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('Connecter',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ],
                        ),
                        /*color: Colors.purple,*/
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 70, bottom: 0),
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
                                   Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => inscriremed(),));
                                }
                               
                                )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ))
                  ],
                ))));
  }
}

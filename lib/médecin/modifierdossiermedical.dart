import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';
class modifierdossiermedical extends StatefulWidget {
  String type ;
  int poids ;
  int valuet ;
  int numdossier ;
  modifierdossiermedical({this.type , this.poids ,this.numdossier,this.valuet});
  @override
  _modifierdossiermedicalState createState() => _modifierdossiermedicalState(type,poids,numdossier,valuet);
}

class _modifierdossiermedicalState extends State<modifierdossiermedical> {
  String type ;
  int poids ;
  int numdossier ;
  String valuechoose2;
  int valuet ;
  
 // int _value1;
 
  List listItem2 = ['type1', 'type2'];
  
  final _formKey = GlobalKey<FormState>();

  _modifierdossiermedicalState(this.type, this.poids, this.numdossier,this.valuet);
  int _value1 ;
 
  TextEditingController poidspt = TextEditingController();
 
  Future<String> modifier() async {
    String rp;
    String type = listItem2[_value1-1].toString() ;


        

     
    if (_formKey.currentState.validate()){
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/dossiermedical_controllers/modifierdossiermedical.php",
        body: {
          "numdossier" : numdossier.toString() ,
          "poids" : poidspt.text.toString() ,

           "type" : type.toString() ,
           
           
        }
       
        );
       
        
       setState(() {
          rp = json.decode(response.body.toString()) ;
        print(rp) ;
          });
          Fluttertoast.showToast(
                     msg: "dossier médical modifié",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.greenAccent,

                     );
        
       
        
         
    }  

  }


  @override
  Widget build(BuildContext context) {
    poidspt.text = poids.toString()  ;
   
    
    return Scaffold(
    
        appBar: AppBar(
          title: Text('Modifier dossier médical'),
        ),
        body: Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 100, bottom: 30),
                child: Form(
               // autovalidate: true,
                key: _formKey,
            child: ListView(
              children: <Widget>[
               
                
               Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 30, bottom: 30),
              child: Container(
                //padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
               // width: 350,
                height: 40,
                decoration: BoxDecoration(
                  // Border Color
                  border: Border.all(width: 2.0, color: Colors.blueAccent),
                  borderRadius: BorderRadius.all(Radius.circular(
                          4.0) //                 <--- border radius here
                      ),
                ),
                child: DropdownButton(
                    icon: Icon(
                      Icons.expand_more,
                      color: Colors.blueAccent,
                    ),
                    //hint: Text("    "),
                    value: _value1,
                    items: [
                      DropdownMenuItem(
                        child: Text("   type1                                                        "),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("   type2                                                        "),
                        value: 2,
                      ),
                    ],
                   // _value1= valuet ;
                    onChanged: (value1) {
                      _value1= value1 ;
                      
                      setState(() {

                        _value1 = value1;
                      });
                    }),
              )),
                  
                Container(
                 // height: 150,
                 padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: TextFormField(
                     
                    keyboardType: TextInputType.number,
                    
                    controller: poidspt,
                    validator: (value1) {
                          if (value1.isEmpty) {
                            return 'champ invalid';
                          }
                          return null;
                        },
                    decoration: InputDecoration(
                      
                      prefixIcon: Icon(Icons.comment),
                      border: OutlineInputBorder(),
                      labelText: 'poids',
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
                    onPressed: modifier ,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Modifier',
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
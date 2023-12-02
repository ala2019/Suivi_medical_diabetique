import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import "package:async/async.dart";

import 'dart:async';

import 'package:suivi_medical/m%C3%A9decin/profile.dart';
import 'package:suivi_medical/patient/accueil_patient.dart';
import 'package:suivi_medical/patient/conversation_patient.dart';

class mdfprofilepatient extends StatefulWidget {
  String index ;
  String usernp ;
String emailp ;
String telp ;
String adressep ;
  mdfprofilepatient({ Key key , this.index, this.usernp , this.adressep ,this.emailp , this.telp}) : super(key: key);

  @override
  _mdfprofilepatientState createState() => _mdfprofilepatientState();
}

class _mdfprofilepatientState extends State<mdfprofilepatient> {

 final _formKey = GlobalKey<FormState>();
   TextEditingController username = TextEditingController();
   TextEditingController email = TextEditingController();
   TextEditingController tel = TextEditingController();
   TextEditingController adresse = TextEditingController();
  File _image;
    _imgFromCamera() async {
  File image = (await ImagePicker.pickImage(
    source: ImageSource.camera, imageQuality: 50
  )) as File;

  setState(() {
    _image = image;
  });
}

_imgFromGallery() async {
  File image = (await  ImagePicker.pickImage(
      source: ImageSource.gallery, imageQuality: 50
  )) as File;

  setState(() {
    _image = image;
  });
}
void _showPicker(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Gallery'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
}


 Future modifierpr() async{


var uri = Uri.parse("http://192.168.43.4:8080/suivimedical/controller/patient_controllers/modifierprofilepatient.php");

var request = new http.MultipartRequest("POST", uri);

var pic = await http.MultipartFile.fromPath("image", _image.path);

request.files.add(pic);
request.fields['username'] =username.text.toString();//username.text.toString();
 //tel.text.toString();
request.fields['index'] = widget.index.toString(); //id.toString();


var respond = await request.send();

if(respond.statusCode==200){
   Fluttertoast.showToast(
                     msg: "profile modifié",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.greenAccent,

                     );
  //print(respond.request);
}else{
   Fluttertoast.showToast(
                     msg: "problem de modifier profile",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.grey,

                     );
 
}

 }
 
 
 Future<String> modifierdspt() async {
    String rp;
   
     
    
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/dossiermedical_controllers/modifierdm.php",
        body: {
         
          "index" : index.toString() ,

           "adresse" : adresse.text.toString() ,
           "tel" : tel.text.toString() ,
           "email" : email.text.toString() ,
           
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
       
          rp = json.decode(response.body.toString()) ;
        
        if (rp=="succes"){

          Fluttertoast.showToast(
                     msg: "profile modifié",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.greenAccent,

                     );
                     
        }
            
        

        return rp ;

        
       
        
         
    

  }
 
  @override


  Widget build(BuildContext context) {
     username.text = widget.usernp;
   tel.text = widget.telp ;
   email.text = widget.emailp ;
   adresse.text = widget.adressep ;
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text('modifier profile'),
        ),
      
      
      
      body: Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 10),
            child: Form(
               // autovalidate: true,
                key: _formKey,
                child: Column(
     children: [
        Container(height: 20,),
         Center(
          child: GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey,
              
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                    
                      child: Image.file(
                        _image,
                        width: 120,
                        height: 120,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.blueAccent,width: 2),
                          borderRadius: BorderRadius.circular(100)),
                      width: 120,
                      height: 120,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
            ),
          ),
        ),
  

      Container(
                       padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: TextFormField(
                        validator: (value1) {
                          if (value1.isEmpty) {
                            return 'username invalid';
                          }
                          return null;
                        },
                        //obscureText: true,
                        controller: username,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          labelText: 'username',
                        ),
                      ),
                    ),



                     Container(
                       padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: TextFormField(
                         validator: (value1) {
                          if (value1.isEmpty) {
                            return 'email invalid';
                          }
                          else if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value1)==false){
                            return 'email invalid';
                          }
                          return null;
                        },
                        //obscureText: true,
                        controller: email,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                          labelText: 'email',
                        ),
                      ),
                    ),

                    Container(
                       padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: TextFormField(
                         validator: (value1) {
                          if (value1.isEmpty) {
                            return 'adresse invalid';
                          }
                         
                          return null;
                        },
                        //obscureText: true,
                        controller: adresse,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.map),
                          border: OutlineInputBorder(),
                          labelText: 'adresse',
                        ),
                      ),
                    ),




                     Container(
                       padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: TextFormField(
                         keyboardType: TextInputType.number,
                        validator: (value1) {
                          if (value1.isEmpty) {
                            return 'télephone invalid';
                          } else if(value1.length!=8){
                            return 'télephone invalid';
                          }
                          else if(double.tryParse(value1) == null){
                           return 'telephone invalid';  
                          }
                          return null;
                        },
                        //obscureText: true,
                        controller: tel,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.call),
                          border: OutlineInputBorder(),
                          labelText: 'telephone',
                        ),
                      ),
                    ),
                     Container(height: 30,),

                     Container(
                      height: 50,
                      width: 310,
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
                        onPressed: (){
                          if (_formKey.currentState.validate()){

                          modifierpr();
                          modifierdspt();
                          Navigator.of(context).pop();
                          }
                          
                          }
                        
                          
                           
                        ,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('enregistrer',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ],
                        ),
                        /*color: Colors.purple,*/
                      ),
                    ),



     ],)
     
     )
      ) 
    );
  }
}
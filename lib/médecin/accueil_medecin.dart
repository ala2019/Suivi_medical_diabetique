import 'package:flutter/material.dart';
import 'package:suivi_medical/m%C3%A9decin/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

import 'demandesrdv.dart';
import 'liste_patient.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
int id_med ;




class acceuil_medecin extends StatefulWidget {
  @override
  _acceuil_medecinState createState() => _acceuil_medecinState();
}

class _acceuil_medecinState extends State<acceuil_medecin> {
  List data;
 
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard',textAlign: TextAlign.center,),
        ),
   body: 
     Column(
      children: <Widget> [
       Flexible(child: dashbord()),
       Flexible(child: list()),
      // Flexible(child: card4()),
       
    
       
        
      ]
     )
      
     
    );
   
  
    
 
     
    
    
    
    
    
    
    
    
    

    
  }
}
class dashbord extends StatefulWidget {
  @override
  _dashbordState createState() => _dashbordState();
}

class _dashbordState extends State<dashbord> {

 

    @override
           void initState() {
           super.initState();
            
            _loadCounter();
             totalpatients().then((value) {
      setState(() {
        patients = value;
      });
    });
     totalrdv().then((value1) {
      setState(() {
        rdvs = value1;
      });
    });
    getrdvtoday().then((value1) {
      setState(() {
        rdvtoday = value1;
      });
    });
            
            
  }
  

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_med = (prefs.getInt('idmed') ?? 0);
      
      
    });
  }
List patients ;
Future<List> totalpatients() async {
    List rp = new List();
    
   
     
    
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/dossiermedical_controllers/dossiermedicalmed.php",
        body: {
          "idmed" : id_med.toString() ,
          
           
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
      
          rp = json.decode(response.body.toString()) ;
       

        return rp ;
         
        
       
        
         
      

  }
  List rdvs ;
Future<List> totalrdv() async {
    List rp = new List();
    List rp1 = new List();
   
     
    
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/rdv_controllers/getrdv.php",
        body: {
          "id_med" : id_med.toString() ,
          
           
           
        }
       // headers: {"Accept": "application/json"}
        );
       
        
      
          rp = json.decode(response.body.toString()) ;
           for (int i=0 ; i< rp.length ; i++ ){

          if (rp[i]['statuts']!="annullé" && rp[i]['statuts']!="demande" && rp[i]['statuts']!="refusé" ){
            rp1.add(rp[i]) ;
          }
        }
        
        return rp1 ;
         
        
       
        
         
      

  }
List rdvtoday ;
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


  
  
  @override
  Widget build(BuildContext context) {
    // List data;
   // getData() ;
    //int a = data.length;
    print(id_med);
    return
     
     Card(
      margin: EdgeInsets.all(12),
       elevation: 4,
       color: Colors.white,
        child: Padding(
       padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
       child: Row(
        children: <Widget>[
           
          Column(
            
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
             
            children: <Widget>[
             
              
              Icon(Icons.bar_chart_sharp ,color: Colors.blueAccent,size: 50,),
              
              Text("Total Patiens", style: TextStyle(color: Colors.blueAccent,fontSize: 10)),
              SizedBox(height: 10),
              patients==null 
              ? SizedBox(width:22 , height: 22,child :CircularProgressIndicator(strokeWidth: 1.0,))
              :Text("${patients.length}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20,fontStyle:FontStyle.normal),textAlign: TextAlign.center,),
            ],
          ),
          Spacer(),

          Column(
            
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
             
            children: <Widget>[
             
              
              Icon(Icons.bar_chart,color: Colors.greenAccent,size: 50,),
              
              Text("Total RDV", style: TextStyle(color: Colors.greenAccent,fontSize: 10)),
              SizedBox(height: 10),
               rdvs==null 
              ? SizedBox(width:22 , height: 22,child :CircularProgressIndicator(strokeWidth: 2.0,))
              :Text("${rdvs.length}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20,fontStyle:FontStyle.normal),textAlign: TextAlign.center,),
            ],
          ),    
                    Spacer(),
              Column(
            
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
             
            children: <Widget>[
             
              
              Icon(Icons.bar_chart_sharp ,color: Colors.pinkAccent,size: 50,),
              
              Text("RDV d'aujourd'hui", style: TextStyle(color: Colors.pinkAccent,fontSize: 10)),
              SizedBox(height: 10),
              rdvtoday==null 
              ? SizedBox(width:22 , height: 22,child :CircularProgressIndicator(strokeWidth: 2.0,))
              :Text("${rdvtoday.length}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20,fontStyle:FontStyle.normal),textAlign: TextAlign.center,),
            ],
          ),        ],
      
    ),
    ),
    );
 
     
  
  }
  
}






class list extends StatefulWidget {
  @override
  _listState createState() => _listState();
}

class _listState extends State<list> {
  @override
  Widget build(BuildContext context) {
    return Column(
     
      children: <Widget>[  
         Card(
           
         color: Colors.white,
         elevation: 5,
         child:Container(

           decoration: BoxDecoration(
             
           border: Border.all(
        color: Colors.blueAccent, width: 1  // red as border color
          ),
          borderRadius: BorderRadius.all(Radius.circular(3.0)
      ),
        ),
         
       child :ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 
        18.0),
        dense:true,
      leading: Icon(Icons.sick , color: Colors.blueAccent, size: 25,),
      tileColor: Colors.transparent,
      subtitle: Center (child :Text("")) ,
      isThreeLine: true,
      //contentPadding: EdgeInsets.all(10),
      trailing: Icon(Icons.navigate_next_rounded , color: Colors.blueAccent,size : 30) ,
      onTap: (){
        consulterlistpatients(){
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => liste_patient(),));}
        consulterlistpatients() ;

      },
      title: Text( 'consulter votre list de     patients ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15 , color: Colors.black),) ,
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.horizontal(right: Radius.circular(3)),
     
         ),
      
      
      ),
      )
      ),
       Card(
         color: Colors.transparent,
         elevation: 5,
         child:Container(

           decoration: BoxDecoration(
             
           border: Border.all(
        color: Colors.pinkAccent, width: 1  // red as border color
          ),
          borderRadius: BorderRadius.all(Radius.circular(3.0)
      ),
        ),
         
       child :ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 
        18.0),
        dense:true,
      leading: Icon(Icons.calendar_today , color: Colors.pinkAccent, size: 25,),
      tileColor: Colors.white,
      subtitle: Center (child :Text("")) ,
      isThreeLine: true,
      //contentPadding: EdgeInsets.all(10),
      trailing: Icon(Icons.navigate_next_rounded , color: Colors.pinkAccent,size : 30) ,
      onTap: (){
        consulterlistlesdemandes(){
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => demandesrdv(),));
        } 
        consulterlistlesdemandes();
      },
      title: Text( 'consulter les demandes de rendez-vous',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15 , color: Colors.black),) ,
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.horizontal(right: Radius.circular(3)),
     
         ),
      
      
      ),),),
      
       Card(
         color: Colors.transparent,
         elevation: 5,
         child:Container(

           decoration: BoxDecoration(
             
           border: Border.all(
        color: Colors.deepPurpleAccent, width: 1  // red as border color
          ),
          borderRadius: BorderRadius.all(Radius.circular(1.0)
      ),
        ),
         
       child :ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 
        18.0),
        dense:true,
      leading: Icon(Icons.book , color: Colors.deepPurpleAccent, size: 25,),
      tileColor: Colors.white,
      subtitle: Center (child :Text("")) ,
      isThreeLine: true,
      //contentPadding: EdgeInsets.all(10),
      trailing: Icon(Icons.navigate_next_rounded , color: Colors.deepPurple,size : 30) ,
      onTap: (){
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => demandesrdv(),));

      },
      title: Text( 'actualité de diabéte dans le monde ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15 , color: Colors.black),) ,
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.horizontal(right: Radius.circular(3)),
     
         ),
      
      
      ),),),
    
  
      ],
      
    );
  }
}




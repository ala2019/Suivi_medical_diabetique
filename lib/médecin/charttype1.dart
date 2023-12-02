import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';


import 'package:http/http.dart' as http;

import 'dart:async';

import 'package:intl/intl.dart';

class BarChartSample2 extends StatefulWidget {
   String indexpt ;
  String nom ;
  BarChartSample2({this.indexpt,this.nom} ) ;
  @override
  State<StatefulWidget> createState() => BarChartSample2State(indexpt,nom);
}

class BarChartSample2State extends State<BarChartSample2> {
  /*final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);*/
   BarChartSample2State(this.indexpt, this.nom);
   var tests ;
  Future<List> gettests() async {
    List rp;
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/analyse_type1_controllers/getteststype1.php",
        body: { 
          "index" : indexpt.toString() ,  
        }
        ); 
       setState(() {
          rp = json.decode(response.body) ;
        //print(rp) ;
          });
          return rp ;
  }
  @override
  void initState() {
    super.initState();
    gettests().then((value) {
      setState(() {
        tests = value;
      });
    });
    
  }
  final double width = 3;

  String indexpt ;
  String nom ;
  

   List<BarChartGroupData> rawBarGroups;
   List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  

 


  @override
  Widget build(BuildContext context) {
    print(tests);

    List<double> l1=[] ;
    List<double> l2=[] ;
    List<double> l3=[] ;
    List<double> l4=[] ;
    List<double> l5=[] ;
    List<double> l6=[] ;
    List<double> l7=[] ;
    List<String> date= [];



    for (int i=0 ; i<tests.length ; i++){
      if(tests[i]['créneau']=='a jeun'){
      date.add(tests[i]['date']+" "+tests[i]['time']);}
    }
   
     
    for (int i=0 ; i<tests.length ; i++){
      if (tests[i]['créneau']=='a jeun'){
      l1.add(double.parse( tests[i]['resultat'])/100);}
    }
    for (int i=0 ; i<tests.length ; i++){
      if (tests[i]['créneau']=='avant dejeun'){
      l2.add(double.parse( tests[i]['resultat'])/100);}
    }
   for (int i=0 ; i<tests.length ; i++){
      if (tests[i]['créneau']=='apres dejeun'){
      l3.add(double.parse( tests[i]['resultat'])/100);}
    }
   for (int i=0 ; i<tests.length ; i++){
      if (tests[i]['créneau']=='avant diner'){
      l4.add(double.parse( tests[i]['resultat'])/100);}
    }
    for (int i=0 ; i<tests.length ; i++){
      if (tests[i]['créneau']=='apres diner'){
      l5.add(double.parse( tests[i]['resultat'])/100);}
    }
   /* for (int i=tests.length-10 ;i< tests.length-5 ; i++){
      l6.add(double.parse( tests[i]['resultat'])/100);
    }
    for (int i=tests.length-5 ; i<tests.length ; i++){
      l7.add(double.parse( tests[i]['resultat'])/100);
    } */
    //print(l1) ;
    //print(l7);
    //print(l1[0]);
    /*  final barGroup1 = makeGroupData(0, l1[0], l1[1],l1[2],l1[3],l1[4]);
    final barGroup2 = makeGroupData(1, l2[0]==null ? 0 : l2[0], l2[1]==null ? 0 : l2[1],l2[2],l2[3],l2[4]);
    final barGroup3 = makeGroupData(2, l3[0], l3[1],l3[2],l3[3],l3[4]);
    final barGroup4 = makeGroupData(3, l4[0], l4[1],l4[2],l4[3],l4[4]);
    final barGroup5 = makeGroupData(4, l5[0], l5[1],l5[2],l5[3],l5[4]);
    final barGroup6 = makeGroupData(5, l6[0], l6[1],l6[2],l6[3],l6[4]);
    final barGroup7 = makeGroupData(6, l7[0], l7[1],l7[2],l7[3],l7[4]); */


    /*  final barGroup1 = makeGroupData(0, l1[0]==null ? 0 : l1[0], l2[0]==null ? 0 : l2[0],l3[0]==null ? 0 : l3[0],l4[0]==null ? 0 : l4[0],l5[0]==null ? 0 : l5[0]);
    final barGroup2 = makeGroupData(1, l1[1]==null ? 0 : l1[1], l2[1]==null ? 0 : l2[1],l3[1]==null ? 0 : l3[1],l4[1]==null ? 0 : l4[1],l5[1]==null ? 0 : l5[1]);
    final barGroup3 = makeGroupData(2, l1[2]==null ? 0 : l1[2], l2[2]==null ? 0 : l2[2],l3[2]==null ? 0 : l3[2],l4[2]==null ? 0 : l4[2],l5[2]==null ? 0 : l5[2]);
    final barGroup4 = makeGroupData(3, l1[3]==null ? 0 : l1[3], l2[3]==null ? 0 : l2[3],l3[3]==null ? 0 : l3[3],l4[3]==null ? 0 : l4[3],l5[3]==null ? 0 : l5[3]);
    final barGroup5 = makeGroupData(4, l1[4]==null ? 0 : l1[4], l2[4]==null ? 0 : l2[4],l3[4]==null ? 0 : l3[4],l4[4]==null ? 0 : l4[4],l5[4]==null ? 0 : l5[4]);
    final barGroup6 = makeGroupData(5, l1[5]==null ? 0 : l1[5], l2[5]==null ? 0 : l2[5],l3[5]==null ? 0 : l3[5],l4[5]==null ? 0 : l4[5],l5[5]==null ? 0 : l5[5]);
    final barGroup7 = makeGroupData(6, l1[6]==null ? 0 : l1[6], l2[6]==null ? 0 : l2[6],l3[6]==null ? 0 : l3[6],l4[6]==null ? 0 : l4[6],l5[6]==null ? 0 : l5[6]);*/


    final barGroup1 = makeGroupData(0, l1.length==0 ? 0 : l1[0], l2.length==0 ? 0 : l2[0],l3.length < 1 ? 0 : l3[0],l4.length < 1 ? 0 : l4[0],l5.length < 1 ? 0 : l5[0]);
    final barGroup2 = makeGroupData(1, l1.length<2 ? 0 : l1[1], l2.length<2 ? 0 : l2[1],l3.length < 2  ? 0 : l3[1],l4.length < 2  ? 0 : l4[1],l5.length < 2 ? 0 : l5[1]);
    final barGroup3 = makeGroupData(2, l1.length<3  ? 0 : l1[2], l2.length<3 ? 0 : l2[2],l3.length < 3 ? 0 : l3[2],l4.length < 3  ? 0 : l4[2],l5.length < 3 ? 0 : l5[2]);
    final barGroup4 = makeGroupData(3, l1.length<4  ? 0 : l1[3], l2.length<4 ? 0 : l2[3],l3.length < 4 ? 0 : l3[3],l4.length < 4  ? 0 : l4[3],l5.length < 4 ? 0 : l5[3]);
    final barGroup5 = makeGroupData(4, l1.length<5  ? 0 : l1[4], l2.length<5 ? 0 : l2[4],l3.length < 5  ? 0 : l3[4],l4.length < 5  ? 0 : l4[4],l5.length < 5 ? 0 : l5[4]);
    final barGroup6 = makeGroupData(5, l1.length<6 ? 0 : l1[5], l2.length<6 ? 0 : l2[5],l3.length < 6  ? 0 : l3[5],l4.length < 6  ? 0 : l4[5],l5.length < 6 ? 0 : l5[5]);
    final barGroup7 = makeGroupData(6, l1.length<7 ? 0 : l1[6], l2.length<7 ? 0 : l2[6],l3.length < 7  ? 0 : l3[6],l4.length < 7  ? 0 : l4[6],l5.length < 7 ? 0 : l5[6]);
    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;


    
    return Scaffold( 
      appBar: AppBar(
      backgroundColor: Color(0xff2c4260),
      title: Text('graphique de tests'),
        
      ),
      backgroundColor: Color(0xff2c4260),
      body:/* AspectRatio(
      aspectRatio: 1,
      child: */
     Padding(
        padding: const EdgeInsets.only(left:2,right: 2,top: 0,bottom: 40),
      child :Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: Padding(
          padding: const EdgeInsets.only(left:5,right: 20,top: 20,bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //makeTransactionsIcon(),
                  const SizedBox(
                    width: 38,
                  ),
                   Text(
                    'les resultas de tests de '+nom,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                   Text(
                    DateTime.now().year.toString(),
                    style: TextStyle(color: Color(0xff77839a), fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(left:5,right: 20,top: 20,bottom: 0),
                 // padding: const EdgeInsets.symmetric(horizontal: 8.0 ,),
                  child: BarChart(
                    
                    BarChartData(
                      maxY: 3,
                      
                      
                      barTouchData: BarTouchData(
                          
                          touchTooltipData: BarTouchTooltipData(
                            //handleBuiltInTouches: true,
                            tooltipBgColor: Colors.grey,
                            getTooltipItem: (_a, _b, _c, _d) => null,
                          ),
                          touchCallback: (response) {
                            if (response.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex = response.spot.touchedBarGroupIndex;

                            setState(() {
                              if (response.touchInput is PointerExitEvent ||
                                  response.touchInput is PointerUpEvent) {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              } else {
                                showingBarGroups = List.of(rawBarGroups);
                                if (touchedGroupIndex != -1) {
                                  var sum = 0.0;
                                  for (var rod in showingBarGroups[touchedGroupIndex].barRods) {
                                    sum += rod.y;
                                  }
                                  final avg =
                                      sum / showingBarGroups[touchedGroupIndex].barRods.length;

                                  showingBarGroups[touchedGroupIndex] =
                                      showingBarGroups[touchedGroupIndex].copyWith(
                                    barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                                      return rod.copyWith(y: avg);
                                    }).toList(),
                                  );
                                }
                              }
                            });
                          }),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                          margin: 20,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              
                              case 0:
                                return (DateTime.tryParse(date[0]).day.toString()+"\n"+DateFormat('MMM').format(DateTime.tryParse(date[0])));
                              
                              case 1:
                                return (DateTime.tryParse(date[1]).day.toString()+"\n"+DateFormat('MMM').format(DateTime.tryParse(date[1])));
                              
                              case 2:
                                return (DateTime.tryParse(date[2]).day.toString()+"\n"+DateFormat('MMM').format(DateTime.tryParse(date[2])));
                                case 3:
                                return (DateTime.tryParse(date[3]).day.toString()+"\n"+DateFormat('MMM').format(DateTime.tryParse(date[3])));
                                case 4:
                                return (DateTime.tryParse(date[4]).day.toString()+"\n"+DateFormat('MMM').format(DateTime.tryParse(date[4])));
                                case 5:
                                return (DateTime.tryParse(date[5]).day.toString()+"\n"+DateFormat('MMM').format(DateTime.tryParse(date[5])));
                                case 6:
                                return (DateTime.tryParse(date[6]).day.toString()+"\n"+DateFormat('MMM').format(DateTime.tryParse(date[6])));
                              default:
                                return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                          margin: 32,
                          reservedSize: 14,
                          getTitles: (value) {
                            if (value == 0) {
                              return '0g';
                            } else if (value == 1) {
                              return '1g';
                            } else if (value == 2) {
                              return '2g';}
                              else if (value ==3 ) {
                              return '3g';
                            } else {
                              return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                       gridData: FlGridData(
                       show: false,
       
       
                         ),
                      barGroups: showingBarGroups,
                    
                    ),
                  ),
                ),
              ),
              /*const SizedBox(
                height: 50,
              ),*/
             
     /* Text(""),
      Text(""),*/
              Center(
      
      child :Row(
        
     children: [
       Text("              "),
  Center (child : Container(
    padding: EdgeInsets.only(
    left: 20.0, top: 0 ),
    height: 15,
    width: 15,
    
    decoration: BoxDecoration(
   
    color: Colors.blueAccent, // Border Color
    border: Border.all(width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0) //                 <--- border radius here
    ),
    ),),),

    Text('  :  a jeun ',style: TextStyle(color: Color(0xff68737d))),

     ]
     ),),
      Text(""),
      
     Center(
      
      child :Row(
        
     children: [
       Text("              "),
  Center (child : Container(
    padding: EdgeInsets.only(
    left: 20.0, ),
    height: 15,
    width: 15,
    decoration: BoxDecoration(
   
    color: Colors.redAccent, // Border Color
    border: Border.all(width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0) //                 <--- border radius here
    ),
    ),),),

    Text('  :  avant dejeun ',style: TextStyle(color: Color(0xff68737d))),

     ]
     ),),
     Text(""),
      
     Center(
      
      child :Row(
        
     children: [
       Text("              "),
  Center (child : Container(
    padding: EdgeInsets.only(
    left: 20.0, ),
    height: 15,
    width: 15,
    decoration: BoxDecoration(
   
    color: Colors.white, // Border Color
    border: Border.all(width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0) //                 <--- border radius here
    ),
    ),),),

    Text('  :  apres dejeun ',style: TextStyle(color: Color(0xff68737d))),

     ]
     ),),
     Text(""),
      
     Center(
      
      child :Row(
        
     children: [
       Text("              "),
  Center (child : Container(
    padding: EdgeInsets.only(
    left: 20.0, ),
    height: 15,
    width: 15,
    decoration: BoxDecoration(
   
    color: Colors.greenAccent, // Border Color
    border: Border.all(width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0) //                 <--- border radius here
    ),
    ),),),

    Text('  :  avant diner ',style: TextStyle(color: Color(0xff68737d))),

     ]
     ),),
     Text(""),
      
     Center(
       
      
      child :
      Padding(
         padding: const EdgeInsets.only(bottom: 200),
      
      child :Row(
        
     children: [
       Text("              "),
  Center (child : Container(
    padding: EdgeInsets.only(
    left: 20.0, ),
    height: 15,
    width: 15,
    decoration: BoxDecoration(
   
    color: Colors.purpleAccent, // Border Color
    border: Border.all(width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0) //                 <--- border radius here
    ),
    ),),),

    Text('  :  apres diner ',style: TextStyle(color: Color(0xff68737d))),

     ]
     ),),),
            ],
          ),
        ),
      ),
    ),);
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2,double y3,double y4 ,double y5) {
    return BarChartGroupData(barsSpace: 2, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors:[Colors.blueAccent] ,
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [Colors.redAccent],
        width: width,
      ),
       BarChartRodData(
        y: y3,
        colors: [Colors.white],
        width: width,
      ),
       BarChartRodData(
        y: y4,
        colors: [Colors.greenAccent],
        width: width,
      ),
       BarChartRodData(
        y: y5,
        colors: [Colors.purpleAccent],
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const width = 4.0;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
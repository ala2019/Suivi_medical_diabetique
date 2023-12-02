import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'dart:async';


class LineChartSample2 extends StatefulWidget {
  String indexpt ;
  String nom ;
  LineChartSample2({this.indexpt,this.nom} ) ;
  @override
  _LineChartSample2State createState() => _LineChartSample2State(indexpt,nom);
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

   @override
           void initState() {
           super.initState();
            gettests().then((value) {
      setState(() {
        tests = value;
      });
    });
            
           
  }

  bool showAvg = false;
  String indexpt ;
  String nom ;
  _LineChartSample2State(this.indexpt,this.nom);
  var tests ;
  Future<List> gettests() async {
    List rp;
    http.Response response = await http.post(
        "http://192.168.43.4:8080/suivimedical/controller/analyse_type2_controllers/gettests.php",
        body: { 
          "index" : indexpt.toString() ,  
        }
        ); 
       setState(() {
          rp = json.decode(response.body) ;
        print(rp) ;
          });
          return rp ;
  }

  List <FlSpot> spots =  [] ;
   List<double> values ; 
   
 

  @override
  Widget build(BuildContext context) {
    print(tests.length) ;
    double j = 0 ;
    if (tests.length < 6){
    for(int i=0 ; i<tests.length;i++){
      spots.add(FlSpot(j,double.parse( tests[i]['taux_hbA1c'])));
      j=j+2 ;
    }}
    else if (tests.length>= 6 ){
     for(int i=tests.length-6 ; i<tests.length;i++){
      spots.add(FlSpot(j,double.parse( tests[i]['taux_hbA1c'])));
      j=j+2 ;
    }

    }
    
  
    
    return
    Scaffold(
      appBar: AppBar(
      backgroundColor: Color(0xff232d37),
      title: Text('graphique de tests'),
        
      ),
      backgroundColor: Color(0xff232d37),
     body : 
     tests==null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )

     : Column(children: [
     SizedBox(height: 10,),
     Center (child: Text('les resultats de tests de '+nom,style: TextStyle(color: Color(0xff68737d)))),
     Center(child: Text(DateTime.now().year.toString(),style: TextStyle(color: Color(0xff68737d)))),
     SizedBox(height: 10,),
     
  
    
    
    
     Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: Color(0xff232d37)),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 10.0, top: 2, bottom: 0),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
       
      ],
    ),
    SizedBox(height: 30,),
    Text('Axe vertical : les resultats de les analyses ',style: TextStyle(color: Color(0xff68737d))),
    SizedBox(height: 20,),
    Text('Axe horizental : les dates de les analyses ',style: TextStyle(color: Color(0xff68737d))),
    SizedBox(height: 20,),
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
    gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xff23b6e6), Color(0xff02d39a)]),
    color: Colors.white, // Border Color
    border: Border.all(width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0) //                 <--- border radius here
    ),
    ),),),

    Text('  :  bar d analyses ',style: TextStyle(color: Color(0xff68737d))),

     ]
     ),),

    



    
    ],));
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
              const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 12),
          getTitles: (value) {
            if (tests.length==1){
             switch (value.toInt()) {
             
              case 0:
                return (DateTime.tryParse(tests[tests.length-1]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-1]['date'])));
                
              
            }

            }
            else if (tests.length==2){
           
            switch (value.toInt()) {
             
              case 0:
                return (DateTime.tryParse(tests[tests.length-2]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-2]['date'])));
                 case 2:
                return (DateTime.tryParse(tests[tests.length-1]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-1]['date'])));
              
            }}
            else if(tests.length==3) {

              switch (value.toInt()) {
                case 0:
                return (DateTime.tryParse(tests[tests.length-3]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-3]['date'])));
             
              case 2:
                return (DateTime.tryParse(tests[tests.length-2]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-2]['date'])));
                 case 4:
                return (DateTime.tryParse(tests[tests.length-1]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-1]['date'])));
              
            }

            }
             else if(tests.length==4) {

              switch (value.toInt()) {
                case 0:
                return (DateTime.tryParse(tests[tests.length-4]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-4]['date'])));
                case 2:
                return (DateTime.tryParse(tests[tests.length-3]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-3]['date'])));
             
              case 4:
                return (DateTime.tryParse(tests[tests.length-2]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-2]['date'])));
                 /*case 6:
                return(DateTime.tryParse(tests[tests.length-1]['date']).day.toString()+"\n"+DateTime.tryParse(tests[tests.length-1]['date']).month.toString());*/
                 case 6 :
                 return (DateTime.tryParse(tests[tests.length-1]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-1]['date'])));
              
            }

            }
             else if(tests.length==5) {

              switch (value.toInt()) {
                 case 0:
                return (DateTime.tryParse(tests[tests.length-5]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-5]['date'])));
                case 2:
                return (DateTime.tryParse(tests[tests.length-4]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-4]['date'])));
                case 4:
                return (DateTime.tryParse(tests[tests.length-3]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-3]['date'])));
             
              case 6:
                return (DateTime.tryParse(tests[tests.length-2]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-2]['date'])));
                 case 8:
                return (DateTime.tryParse(tests[tests.length-1]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-1]['date'])));
              
            }

            }
            else if(tests.length>=6) {

              switch (value.toInt()) {
                case 0:
                return (DateTime.tryParse(tests[tests.length-6]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-6]['date'])));
                
                 case 2:
                return (DateTime.tryParse(tests[tests.length-5]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-5]['date'])));
                case 4:
                return (DateTime.tryParse(tests[tests.length-4]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-4]['date'])));
                case 6:
                return (DateTime.tryParse(tests[tests.length-3]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-3]['date'])));
             
              case 8:
                return (DateTime.tryParse(tests[tests.length-2]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-2]['date'])));
                 
                 case 10:
                return (DateTime.tryParse(tests[tests.length-1]['date']).day.toString()+"\n"+DateFormat('MMMM').format(DateTime.tryParse(tests[tests.length-1]['date'])));
              
            }

            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1%';
              case 2:
                return '2%';
              case 3:
                return '3%';
                case 4:
                return '4%';
                case 5:
                return '5%';
                case 6:
                return '6%';
                case 7:
                return '7%';
                case 8:
                return '8%';
                case 9:
                return '9%';
                case 10:
                return '10%';
                 case 11:
                return '11%';
                 case 12:
                return '12%';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
          FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 12,
    
      lineBarsData: [
        
        LineChartBarData(
          
          
           spots: spots /*[
            
           
            FlSpot(1,  double.parse( tests[0]['taux_hbA1c'])),
            FlSpot(3, double.parse( tests[1]['taux_hbA1c'])),
           
          ],*/,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

 
}


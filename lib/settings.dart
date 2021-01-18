import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_tzabar/main.dart';
import 'Palette.dart';


void main() async{
  

}
class settings extends StatefulWidget {
  @override
  _settingsState createState() => _settingsState();
}
      
    class _settingsState extends State<settings> { 
        bool symptoms = false;
        bool proximity = false;
        bool fever = false;
        bool allergy = false;
        bool fluvaccine = false;

     void initState() {
      super.initState();
    getSwitchValues();
     }    
     
  getSwitchValues() async {
    symptoms = await getSymptomsState();
    proximity = await getProximityState();
    fever = await getFeverState();
    allergy = await getAllergyState();
    fluvaccine = await getfluvaccineState();

    setState(() {});
  }

  Future<bool> saveSwitchState(String answer, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(answer, value);
    print('Switch Value saved $value');
    return prefs.setBool(answer, value);
  }

  Future<bool> getSymptomsState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("symptoms"))
    prefs.setBool("symptoms", false);
    bool symptoms = prefs.getBool("symptoms");
    return symptoms;
  }

  Future<bool> getProximityState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("proximity"))
    prefs.setBool("proximity", false);
    bool proximity = prefs.getBool("proximity");
    return proximity;
  }
  Future<bool> getFeverState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("fever"))
    prefs.setBool("fever", false);
    bool fever = prefs.getBool("fever");
    return fever;
  }
 Future<bool> getAllergyState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("allergy"))
    prefs.setBool("allergy", false);
    bool allergy = prefs.getBool("allergy");
    return allergy;
  }
   Future<bool> getfluvaccineState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("fluvaccine"))
    prefs.setBool("fluvaccine", false);
    bool fluvaccine = prefs.getBool("fluvaccine");
    return fluvaccine;
  }

     bool isSick = false; 

  @override
  Widget build(BuildContext context) {  

     return new WillPopScope(
      onWillPop: ()  async {
        Navigator.pop(context);
      return await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => homepage())
              );
           },
  
  child: Scaffold(
         appBar: AppBar(title: Text("הצהרת בריאות אוטומטית"),
               flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
              Palette.color01_appbar,
              Palette.color02_appbar,
            ])          
         ), 
               ),   
        centerTitle: true,),
        body: SingleChildScrollView(
          
          child: Column(
        children: <Widget>[
          BuildSubTitle(),
          BuildInformation(),
          Column(
                          children: [
                           Row(     
                               mainAxisAlignment: MainAxisAlignment.center,
                            children: [   

                              
             Wrap(  
               children: [               
            Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFeb3941), Color(0xFFe2373f)],
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
              child: Row(
     mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                              Switch(
                  value: symptoms,
                        onChanged: (bool value) {
                          setState(() {
                            symptoms = value;
                            saveSwitchState("symptoms",value);
                            print('Saved state is $symptoms');
                          });
                          print(symptoms);
                        },
                        inactiveTrackColor: Colors.white60,
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                         textAlign: TextAlign.center,
                         text:
                       TextSpan(
                         text: "קיום סיפטומים",
                         
                         style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                           fontSize: 16.0,
                           
                         )
                         ),
                         ))
                            ]
                            )
                            
)
                                                                                  ]
                            )
                          ],
                        ),
                             SizedBox(height: 10),
          
                            Row(     
                               mainAxisAlignment: MainAxisAlignment.center,
                            children: [   

                              
             Wrap(  
               children: [               
            Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFeb3941), Color(0xFFe2373f)],
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
              child: Row(
     mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                              Switch(
                  value: proximity,
                        onChanged: (bool value) {
                          setState(() {
                            proximity = value;
                            saveSwitchState("proximity",value);
                            print('Saved state is $proximity');
                          });
                          print(proximity);
                        },
                   inactiveTrackColor: Colors.white60,
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                     Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  RichText(
                         textAlign: TextAlign.center,
                         text:
                       TextSpan(
                         text: "מגע עם חולה ב12 ימים האחרונים",
                         
                         style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                           fontSize: 16.0,
                           
                         )
                         ),
                         )
                     )
                            ]
                            )
                            
)
                                                                                  ]
                            )
                          ],
                        ),
                              SizedBox(height: 10),
          
                            Row(     
                               mainAxisAlignment: MainAxisAlignment.center,
                            children: [   

                              
             Wrap(  
               children: [               
            Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFeb3941), Color(0xFFe2373f)],
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
              child: Row(
     mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                              Switch(
                  value: fever,
                        onChanged: (bool value) {
                          setState(() {
                            fever = value;
                            saveSwitchState("fever",value);
                            print('Saved state is $fever');
                          });
                          print(fever);
                        },
                   inactiveTrackColor: Colors.white60,
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                     Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  RichText(
                         textAlign: TextAlign.center,
                         text:
                       TextSpan(
                         text: "סובל ממחלת חום חריפה",
                         
                         style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                           fontSize: 16.0,
                           
                         )
                         ),
                         )
                     )
                            ]
                            )
                            
)
                                                                                  ]
                            )
                          ],
                        ),
                                      SizedBox(height: 10),
          
                            Row(     
                               mainAxisAlignment: MainAxisAlignment.center,
                            children: [   

                              
             Wrap(  
               children: [               
            Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFeb3941), Color(0xFFe2373f)],
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
              child: Row(
     mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                              Switch(
                  value: allergy,
                        onChanged: (bool value) {
                          setState(() {
                            allergy = value;
                            saveSwitchState("allergy",value);
                            print('Saved state is $allergy');
                          });
                          print(allergy);
                        },
                    inactiveTrackColor: Colors.white60,
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                     Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  RichText(
                         textAlign: TextAlign.center,
                         text:
                       TextSpan(
text: "אלרגי בכדי שימוש במזרק אפיפן",                         
                         style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                           fontSize: 16.0,
                           
                         )
                         ),
                         )
                     )
                            ]
                            )
                            
)
                                                                                  ]
                            )
                          ],
                        ),
                                     SizedBox(height: 10),
          
                            Row(     
                               mainAxisAlignment: MainAxisAlignment.center,
                            children: [   

                              
             Wrap(  
               children: [               
            Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFeb3941), Color(0xFFe2373f)],
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
              child: Row(
     mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                              Switch(
                  value: fluvaccine,
                        onChanged: (bool value) {
                          setState(() {
                            fluvaccine = value;
                            saveSwitchState("fluvaccine",value);
                            print('Saved state is $fluvaccine');
                          });
                          print(fluvaccine);
                        },
                     inactiveTrackColor: Colors.white60,
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                     Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  RichText(
                         textAlign: TextAlign.center,
                         text:
                       TextSpan(
                         text: "חוסנת לשפעת בשבועיים האחרונים",
                         style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                           fontSize: 16.0,
                           
                         )
                         ),
                         )
                     )
                            ]
                            )
                            
)
                                                                                  ]
                            )
                          ],
                        ),               
                  ]
                  ),
                  SizedBox(height: 20),
                    BuildCreator(),

         ]
          ),
        )
                  
                
            )
               );
            }
            
            }
          

 



  class BuildSubTitle extends StatelessWidget {
    
  @override
  Widget build(BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
                   height: screenHeight*0.06,
                  width: screenWidth*0.99,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
                ),
                 gradient: LinearGradient(
              begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
              Palette.color01_appbar,
              Palette.color02_appbar,
            ])  
        ),
        child :Align(
          alignment: Alignment.topCenter,
                child: Text('הגדרות ומידע נוסף',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                  
                textAlign: TextAlign.center,
                ),
        )
     );
  }
  }
        class BuildInformation extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
          return  Container(
                    margin: EdgeInsets.symmetric(
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0,0.0,16.0,16.0),
                    child: Text(
                        '\n,אפליקצייה זו אינה נועדה להחליף את האפליקצייה המקורית'+
                            ' ,אלא להקל עלינו בעת הדיווח בכל בוקר מחדש \n ' 
                        +'בכל יום מחדש אפליקצייה זו מדווחת פעם אחת בין השעות 5:00 ל10:00 בבוקר במידה והשליחה נכשלה, מדווח אוטומטי שוב כל 15 דקות עד הצלחה. אינני נוקט בפעולות על מנת לגנוב נתונים. במידה ויש תקלות יש לדווח לי על מנת שאתקן זאת במהרה',
                      style: TextStyle(fontSize: 13.0, color: Colors.black87, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,

                    ),
                      ),
                    ),
          );
                    
        }
        }
        class BuildCreator extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
          return  Container(
                    margin: EdgeInsets.symmetric(
                    ),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0,30.0,16.0,5),
                    child: Text(
                      "@ransananes \n @lidorelias3",
                      style: TextStyle(fontSize: 13.0, color: Colors.black87, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,

                    ),
                      ),
                    ),
          );
 
  }
      
        }
  

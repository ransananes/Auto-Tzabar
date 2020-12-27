import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_tzabar/main.dart';
import 'Palette.dart';
import 'constants.dart';


void main() async{

}
class settings extends StatefulWidget {
  @override
  _settingsState createState() => _settingsState();
}
    bool isSwitched = constants.isSick;

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {  
  print(isSwitched);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
     return new WillPopScope(
      onWillPop: ()  async {
        constants.setSickness(isSwitched);
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
        body: Column(
        children: [
          Expanded(
            flex: 0,
            child: Hero(
              tag: 'hero',
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: Container(
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
          alignment: Alignment.center,
                child: Text('הגדרות ומידע נוסף',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                  
                textAlign: TextAlign.center,
                ),
        )

                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.symmetric(
          
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
              child: Text(
                  '\n,אפליקצייה זו אינה נועדה להחליף את האפליקצייה המקורית'+
                      ' ,אלא להקל עלינו בעת הדיווח בכל בוקר מחדש \n ' 
                   +'בכל יום מחדש אפליקצייה זו מדווחת פעם אחת בין השעות 5:00 ל10:00 בבוקר במידה והשליחה נכשלה, מדווח אוטומטי שוב כל 15 דקות עד הצלחה. איננו נוקטים בפעולות על מנת לגנוב נתונים. במידה ויש תקלות יש לדווח לנו על מנת לתקן זאת במהרה',
                style: TextStyle(fontSize: 13.0, color: Colors.black87, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,

              ),
                )
              
          ))),
          Expanded(
            flex: 0,
            child: Container(
               height: screenHeight * 0.08,
               width: screenWidth*0.6,
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
              
          value: isSwitched,
          onChanged: (value){ 
            constants.setSickness(value); 
            setSickness(value);
            setState(() {     

              isSwitched=value;
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
                  RichText(
               textAlign: TextAlign.end,
               text:
             TextSpan(
               text: " יש סימפטומים ",
               
               style: TextStyle(
                 color: Colors.white,
                 fontWeight: FontWeight.bold,
                 fontSize: 16.0,
                 
               )
               ),
               )
                 
                ],
              ),
              
            ),
            
          ),
                 //   Image(image: AssetImage('assets/icons/cactus.png'), height: screenHeight*0.2, width: screenWidth*0.9,),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 12.0,
              ),
             child: Align(
          alignment: Alignment.bottomCenter,
              child: Text(
                '@ransananes',
                style: TextStyle(fontSize: 13.0, color: Colors.black87),
                textAlign: TextAlign.center,

              ),
            ),
          )),
        ],
          
      ),
 
),
        
        
      
    
     );
  }
  
  }
 


Future<void> setSickness(bool issick) async {
    SharedPreferences sp_log = await SharedPreferences.getInstance();
    sp_log.setBool("sick", issick);

     
  }
  

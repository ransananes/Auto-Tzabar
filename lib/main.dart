      import 'dart:async';
      import 'dart:convert';
      import 'package:flutter/material.dart';
      import 'package:flutter_inappwebview/flutter_inappwebview.dart';
      import 'package:flutter_local_notifications/flutter_local_notifications.dart';
      import 'package:intl/intl.dart';
      import 'package:permission_handler/permission_handler.dart';
      import 'package:shared_preferences/shared_preferences.dart';
      import 'package:auto_tzabar/Palette.dart';
      import 'package:auto_tzabar/constants.dart';
      import 'package:http/http.dart' as http;
      import 'package:auto_tzabar/settings.dart';
      import 'package:auto_tzabar/NotificationHelper.dart';
      import 'package:background_fetch/background_fetch.dart';
        
      String token = "";

      void backgroundFetchHeadlessTask(String taskId) async {
      sendAPIS();
        BackgroundFetch.finish(taskId);
      }

      Future<void> sendAPIS() async{
        //NotificationHelper().showNotificationActivated();
          SharedPreferences sp = await SharedPreferences.getInstance();
      now =int.parse( DateFormat.H().format(new DateTime.now()));
          
          if(now >= 0 && now < 5)
          {
            failed = true;
            sp.setBool("failed", true); 
          }
          else if((now >= 5) && (now < 10))
          {    
            
            if(!sp.containsKey("token"))
            print("error on earth!");
            if(!sp.containsKey("sick"))
            sp.setBool("sick", false);
            if(!sp.containsKey("failed"))
            sp.setBool("failed", true);
            token = sp.getString("token");
            sp.reload();
            failed = sp.getBool("failed");

      if(token != null && failed == true)
      {
        NotificationHelper().showNotificationActivated();
          var headers = {
          'authority': 'clearance.medical.idf.il',
          'authorization': 'Bearer $token',
          'request-id': '|af562cfa1147453c964cc238e9bad1b5.ec1e46fbd8ae434a',
          'content-type': 'application/json',
          'user-agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Mobile Safari/537.36 Edg/87.0.664.66',
          'request-context': 'appId=cid-v1:b9e90afe-0c1a-4308-945f-977d51c5dd8d',
          'accept': '*/*',
          'origin': 'https://clearance.medical.idf.il',
          'sec-fetch-site': 'same-origin',
          'sec-fetch-mode': 'cors',
          'sec-fetch-dest': 'empty',
          'referer': 'https://clearance.medical.idf.il/Questionnaire',
          'accept-language': 'en-US,en;q=0.9',
          'cookie': 'visid_incap_2430802=KaORQYPAQlmMH3eO42PexigKzF8AAAAAQUIPAAAAAAC7uhlme0TN8IILjlNCiQN5; ai_user=p1PDqy2fVzutvlF5fIrrJS|2020-12-10T18:39:29.603Z; nlbi_2430802=oNIRTD99eVazrMtZx19azwAAAAC6f/EJEygU1CwqVi0o8tWp; incap_ses_820_2430802=deC8TAr8Kl07LP+m7TlhC3Cy418AAAAAn2TcxDUn9Jb+EiV7NHk01Q==; ai_session=zgC4ZpYz8SfRs9fbreES7Q|1608757875082|1608757877706',
        };
        var payload;
        print(constants.isSick);
      if(constants.isSick)
      {
        payload = {"isSymptom":true,"isProximity":false,"potentialAnswers":{"isFever":false,"isAllergy":false,"isFluVaccine":false}};
      }
      else
      {
        payload = {"isSymptom":false,"isProximity":false,"potentialAnswers":{"isFever":false,"isAllergy":false,"isFluVaccine":false}};
      }
        var res = 
        await http.post('https://clearance.medical.idf.il/api/report/addReport/', headers: headers, body: jsonEncode(payload));
        if (res.statusCode != 200) { 
            failed = true;
            sp.setBool("failed", true);
        //  throw Exception('http.post error: statusCode= ${res.statusCode}');
          }
          else{
            sp.setBool("failed", false);
          failed = false;
            NotificationHelper().showNotificationBtweenInterval();
          }
        print(res.body);

      }
          }
      }

      @override
      void initState() {
        initState();  
      }

      @override
      void dispose() {
        dispose();
      }
      int now = 0;
      bool failed = true;
      /*void setnow () async
      {
          SharedPreferences sp = await SharedPreferences.getInstance();
      now =int.parse( DateFormat.H().format(new DateTime.now()));
          if((now >= 5) && (now < 10))
          {
            sendAPIS();
          }
          if(now >= 0 && now < 5)
          {
            failed = true;
          sp.setBool("failed", true); 
          }
      }*/
      void main() async {
        WidgetsFlutterBinding.ensureInitialized(); 
        SharedPreferences sp_log = await SharedPreferences.getInstance();
        // sendAPIS(); 
      NotificationHelper().initializedNotification();
        runApp(MaterialApp(
          home: homepage(),
        )); 
          BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
      }
      class homepage extends StatefulWidget {
        @override
        _homepageState createState() => new _homepageState();
      }

      class _homepageState extends State<homepage> {

        String url = "";
        double progress = 0;  
        void initState() {
          super.initState();
          initPlatformState();
        }
        Future<void> initPlatformState() async {
          // Configure BackgroundFetch.
          BackgroundFetch.configure(BackgroundFetchConfig(
              minimumFetchInterval: 10,
              stopOnTerminate: false,
              enableHeadless: true,
              requiresBatteryNotLow: false,
              requiresCharging: false,
              startOnBoot: true,
              forceAlarmManager: true,
              requiresStorageNotLow: false,
              requiresDeviceIdle: false,
              requiredNetworkType: NetworkType.NONE
          ), (String taskId) async {
            // This is the fetch-event callback.
            print("[BackgroundFetch] Event received $taskId");
              switch (taskId) {
          default:
                sendAPIS();

      }
            BackgroundFetch.finish(taskId);

          }).then((int status) {
            print('[BackgroundFetch] configure success: $status');
          
          }).catchError((e) {
            print('[BackgroundFetch] configure ERROR: $e');
        
          });
          if (!mounted) return;
        }
        @override
        Widget build(BuildContext context) {
      return Scaffold(
              appBar: AppBar(
                title: Text("הצהרת בריאות אוטומטית"),
              centerTitle: true,
                    flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                    Palette.color01_appbar,
                    Palette.color02_appbar,
                  ]),
                ),
                ),
                actions: <Widget>[
                IconButton(
                icon: Icon(
                Icons.settings,
                  color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);      
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => settings())
              );}
          )
        ],
              ),
              body: Container(
                child: Column(children: <Widget>[

                  Expanded(
                      child: InAppWebView(
                        initialUrl: "https://clearance.medical.idf.il",
              
                        
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                            javaScriptEnabled: true,
                            debuggingEnabled: true,
                            
                          )
                        ),
                        onWebViewCreated: (InAppWebViewController controller) {


                        },
                        onLoadStart: (InAppWebViewController controller, String url) {
                          setState(() {
                            this.url = url;
                          });
                        },
                        onLoadStop: (InAppWebViewController controller, String url) async {
                          setState(() {
                            this.url = url;  
                          });
                                      SharedPreferences sp = await SharedPreferences.getInstance();
                          controller.evaluateJavascript(source: "JSON.parse(localStorage.getItem(Object.keys(localStorage)[0]))['accessToken'];").then((result) {
                            if(result != null)  
                          sp.setString("token", result);
                            });
                        
                                

      
          var status = await Permission.ignoreBatteryOptimizations.status;
      if (status.isUndetermined || status.isDenied) {
          Map<Permission, PermissionStatus> statuses = await [
                  Permission.ignoreBatteryOptimizations
                ].request();
      }
      
            

                                            onProgressChanged: (InAppWebViewController controller, int progress) {
                                              setState(() {
                                                this.progress = progress / 100;
                                              });
                      
                                                                                                              };
                      
                          
                      
                          },)
                                      ),   
                                              Container(
                    padding: EdgeInsets.all(10.0),
                    child: progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container()),
                                    ]),
                                  ),
                                
                              );
                            }
                          }
   /*   Future<void> initializenotifications() async { 
            
          // initialise the plugin of flutterlocalnotifications. 
          FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin(); 
            
          // app_icon needs to be a added as a drawable 
          // resource to the Android head project. 
          var android = new AndroidInitializationSettings('@mipmap/ic_launcher'); 
          var IOS = new IOSInitializationSettings(); 
            
          // initialise settings for both Android and iOS device. 
          var settings = new InitializationSettings(android:android, iOS: IOS); 
              await flip.initialize(settings);

      }*/ 
        

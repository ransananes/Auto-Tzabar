      import 'dart:async';
      import 'dart:convert';
import 'dart:developer';
import 'dart:io';
      import 'package:flutter/material.dart';
      import 'package:flutter_inappwebview/flutter_inappwebview.dart';
      import 'package:flutter_local_notifications/flutter_local_notifications.dart';
      import 'package:intl/intl.dart';
      import 'package:permission_handler/permission_handler.dart';
      import 'package:shared_preferences/shared_preferences.dart';
      import 'package:auto_tzabar/Palette.dart';
      import 'package:http/http.dart' as http;
      import 'package:auto_tzabar/settings.dart';
      import 'package:auto_tzabar/NotificationHelper.dart';
      import 'package:background_fetch/background_fetch.dart';
        

      void backgroundFetchHeadlessTask(String taskId) async {
      sendAPIS();
        BackgroundFetch.finish(taskId);
      }   
      // <------- Parameters ------->
        String token = null;
        String cookie = "";
        int now = 0;
        bool failed = true;
        bool symptoms = false;
        bool proximity = false;
        bool fever = false;
        bool allergy = false;
        bool fluvaccine = false;

      Future<void> sendAPIS() async{
          SharedPreferences sp = await SharedPreferences.getInstance();
          now =int.parse( DateFormat.H().format(new DateTime.now()));
          if(now >= 0 && now < 5)
          {
            failed = true;
            sp.setBool("failed", true); 
          }
          else if((now >= 5) && (now < 10))
          {    
            // Update Booleans :)
            token = sp.getString("token");
            cookie = sp.getString("Cookie");
            symptoms = sp.getBool("symptoms");
            proximity = sp.getBool("proximity");
            fever = sp.getBool("fever");
            allergy = sp.getBool("allergy");
            fluvaccine = sp.getBool("fluvaccine");
            failed = sp.getBool("failed");

          

            var queryParameters = {
                'response_type': 'id_token',
          'scope':'https://graph.microsoft.com/user.readwrite openid profile',
          'client_id':'8a3536e7-b4d9-492e-b8c7-1f3922142007',
          'redirect_uri':'https://clearance.medical.idf.il/auth.html',
          'state':'eyJpZCI6Ijc0OTNhMDM4LTdkMzMtNDVkZS05NTI4LTE4MThiZWJiNWZkMCIsInRzIjoxNjEwMTMyOTA2LCJtZXRob2QiOiJyZWRpcmVjdEludGVyYWN0aW9uIn0=',
          'nonce':'5e1ca72d-7b43-483f-906a-f463601d2e39',
          'login_hint':'322871377@idf.il', //324010503
          'client-request-id':'4d9dcb28-8348-43ea-bcaa-73c540b67394',
          'response_mode':'fragment'
                };
              var headers3 = {
                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
                'Cookie': "ESTSAUTHPERSISTENT=0.ATUAUgiCePpVC0WQjUXA2RHna-c2NYrZtC5JuMcfOSIUIAc1AL8.AgABAAQAAABeStGSRwwnTq2vHplZ9KL4AQDs_wMA9P-wAs7GExAE0uyuai4YhKVLH0e2x6g_S_brK5b9ZsECHzTfExzpeQ1UtjUMTenbIPzBN0YqiYdY_O65gcrINPaX0bLFYpJDuXCq8BorImYMdQiNM0uagku_hxYRuDxQRsBUJQ1pDcKgnXZ4H2gONB_z4F_3lKBpg_vlpuCIECDbZs8BAWZiAOCscC6kn8x4J0v6CC1u4UzOVG_ozZF9RI-tEQ6bkphwEcL9PDDvgTPcuWnVTVNVUOlvOW5Yyumw3ZLC2rjz5RFmN3cVDjExF-HM0Q1r8vuhX18CP-YIL-9c6Se45D-m0yErL3fLVogbYvndimccOiVLJSjiX2pfyaZYpZMc0ePPk1okLTUHNzpIY7ENi_wMRXX1bdctYhPNmX9l1gVKHhTzslCVFF-mHgnKfOG6TQ3J-s_CKltoQEvH0P6vwOMSUDgxMI5hJOAVM6zd6S_hrvoI-QrKrrOC8xlX-qT9s5-6NWAhs70RY3moqjsHDjkG",
                'User-Agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Mobile Safari/537.36 Edg/87.0.664.66'
                ,'Accept-Language': 'en-US,en;q=0.9',
                'Accept-Encoding': 'gzip, deflate, br',
                'Referer': 'https://clearance.medical.idf.il/'
                };
          var response = await http.post('https://login.microsoftonline.com/78820852-55fa-450b-908d-45c0d911e76b/oauth2/v2.0/authorize', headers: headers3, body:queryParameters);
            token = response.body.substring(135,1453);
          print(token);
     /* if(token != null && failed == true)
      {
       // token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjVPZjlQNUY5Z0NDd0NtRjJCT0hIeEREUS1EayJ9.eyJhdWQiOiI4YTM1MzZlNy1iNGQ5LTQ5MmUtYjhjNy0xZjM5MjIxNDIwMDciLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vNzg4MjA4NTItNTVmYS00NTBiLTkwOGQtNDVjMGQ5MTFlNzZiL3YyLjAiLCJpYXQiOjE2MTAxMDI0NjksIm5iZiI6MTYxMDEwMjQ2OSwiZXhwIjoxNjEwMTA2MzY5LCJhaW8iOiJBVlFBcS84U0FBQUFkbHpFakZuNERhVFoxaGw2eFBJa01NUU51cXBUcU9xZ3BHdWZOc3hlUDBaanhMcCs0NkFiRk1kKzBoRkUyaWxoRENpblJlME9GRkRFY2twdFZzVTRsSkFpS2U2dllFVUY3Ry9EVWRBOGdDTT0iLCJuYW1lIjoi16jXnyDXodeg16DXoSIsIm5vbmNlIjoiMzBmMzcxYWMtNGZjMi00MmQ1LWE3NDgtZTkwZWY3MTljZGFmIiwib2lkIjoiMmE4YTU1NTItZTE1Yi00Y2NiLWIyNjctYTIxOWM1ZWYxOGFkIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiMzIyODcxMzc3QGlkZi5pbCIsInJoIjoiMC5BVFVBVWdpQ2VQcFZDMFdRalVYQTJSSG5hLWMyTllyWnRDNUp1TWNmT1NJVUlBYzFBTDguIiwic3ViIjoidnppd3JYb1lYazBlUWJjZmhaOTlFVzdPWmwzRnBPU1ZVTjZfNDExTXJvdyIsInRpZCI6Ijc4ODIwODUyLTU1ZmEtNDUwYi05MDhkLTQ1YzBkOTExZTc2YiIsInV0aSI6Ino0eTFGUFdSbzA2b2s1dkpJRmczQUEiLCJ2ZXIiOiIyLjAifQ.Tz67rnBFH_hzRVb4C3gqvaqY3FYATLxZTv9l8mEtCQOVRvjVU-7L0MXS6GC6Xs-OeGYu7BOHb6q09Yh4DJC-ixqBJhmUMb5prEFsJFb1NgLiaXup37W_84yyOTGWtmcJuhgni9AQqrgC7eXM3je4V6it26baEXmMJZJT1G4HinC3LIWluoc-W8pMmTzfIMm2PLPHBdUKhfjKU9o4F_QpOxd_uIkxb2sNos9rg7t7sbeVvwxOpvqMSHUg15T5qke8YKVIqTIgz5YDjvPcRlwr5Si4uq5db7A_chOwrqd8Uzz6B-1de6s0JUMXSskHSex_16Iu4OIxvclTrEzcpK_ocw";
          var headers = {
          'authority': 'clearance.medical.idf.il',
          'authorization': 'Bearer $token',
          'request-id': '|af562cfa1147453c964cc238e9bad1b5.ec1e46fbd8ae434a',
          'content-type': 'application/json',
          'user-agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Mobile Safari/537.36 Edg/87.0.664.66',
          'request-context': 'appId=cid-v1:b9e90afe-0c1a-4308-945f-977d51c5dd8d',
          'accept': '*//*',
          'origin': 'https://clearance.medical.idf.il',
          'sec-fetch-site': 'same-origin',
          'sec-fetch-mode': 'cors',
          'sec-fetch-dest': 'empty',
          'referer': 'https://clearance.medical.idf.il/Questionnaire',
          'accept-language': 'en-US,en;q=0.9',
          'cookie': 'visid_incap_2430802=KaORQYPAQlmMH3eO42PexigKzF8AAAAAQUIPAAAAAAC7uhlme0TN8IILjlNCiQN5; ai_user=p1PDqy2fVzutvlF5fIrrJS|2020-12-10T18:39:29.603Z; nlbi_2430802=oNIRTD99eVazrMtZx19azwAAAAC6f/EJEygU1CwqVi0o8tWp; incap_ses_820_2430802=deC8TAr8Kl07LP+m7TlhC3Cy418AAAAAn2TcxDUn9Jb+EiV7NHk01Q==; ai_session=zgC4ZpYz8SfRs9fbreES7Q|1608757875082|1608757877706',
        };
        
        var payload = {"isSymptom":symptoms,"isProximity":proximity,"potentialAnswers":{"isFever":fever,"isAllergy":allergy,"isFluVaccine":fluvaccine}};
         var res = 
        await http.post('https://clearance.medical.idf.il/api/report/addReport/', headers: headers, body: jsonEncode(payload));
        print("SSSSSSSSSS");
       print(res.headers);
        if (res.statusCode != 200) { 
            failed = true;
            sp.setBool("failed", true);
            NotificationHelper().showNotificationActivated(res.body,failed);
        //  throw Exception('http.post error: statusCode= ${res.statusCode}');
          }
          else{
            sp.setBool("failed", false);
          failed = false;
         NotificationHelper().showNotificationBtweenInterval();
          }
      }*/
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

      void main() async {
        WidgetsFlutterBinding.ensureInitialized(); 
        SharedPreferences sp_log = await SharedPreferences.getInstance();
            if(!sp_log.containsKey("failed"))
            sp_log.setBool("failed", true);
            if(!sp_log.containsKey("symptoms"))
            sp_log.setBool("symptoms", false);
            if(!sp_log.containsKey("proximity"))
            sp_log.setBool("proximity", false);
            if(!sp_log.containsKey("fever"))
            sp_log.setBool("fever", false);
            if(!sp_log.containsKey("allergy"))
            sp_log.setBool("allergy", false);
            if(!sp_log.containsKey("fluvaccine"))
            sp_log.setBool("fluvaccine", false);

      NotificationHelper().initializedNotification();
      sendAPIS();
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
              minimumFetchInterval: 3,
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
            // This is the app running in the background
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
                                      
                               /*       if(url.startsWith("https://login.microsoftonline.com/78820852-55fa-450b-908d-45c0d911e76b/oauth2/v2.0/authorize"))
                                      {
                                      controller.evaluateJavascript(source: "document.cookie;").then((value) {
                                        s = value;   
                                         tempurl= url;

                                        print(s);
                                        sp.setString("Cookie", s);
                                        sp.setString("Referer", url);
                                        print(url);
                                      });
                                      */
                                   /*      var headers34 = {
                                      'Cache-Control': 'max-age=0',
                                      'Upgrade-Insecure-Requests': '1',
                                      'Origin': 'https://login.microsoftonline.com',
                                      'Content-Type': 'application/x-www-form-urlencoded',
                                      'User-Agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Mobile Safari/537.36 Edg/87.0.664.66',
                                      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,**;q=0.8,application/signed-exchange;v=b3;q=0.9',
                                      'Sec-Fetch-Site': 'same-origin',
                                      'Sec-Fetch-Mode': 'navigate',
                                      'Sec-Fetch-User':'?1',
                                      'Sec-Fetch-Dest': 'document',
                                      'Referer': tempurl,
                                      'Accept-Encoding': 'gzip, deflate, br',
                                      'Accept-Language':' en-US,en;q=0.9',
                                      'Cookie':cookie,
                                                      };
                                        var response = await http.post("https://login.microsoftonline.com/78820852-55fa-450b-908d-45c0d911e76b/oauth2/v2.0/authorize?response_type=id_token&scope=https%3A%2F%2Fgraph.microsoft.com%2Fuser.readwrite%20openid%20profile&client_id=8a3536e7-b4d9-492e-b8c7-1f3922142007&redirect_uri=https%3A%2F%2Fclearance.medical.idf.il%2F&state=eyJpZCI6IjhiZGY5ZTAxLTA4YTQtNDUwNi04Y2Y1LTQ5YjI3OTU4NmJjZCIsInRzIjoxNjEwMTM4Njg1LCJtZXRob2QiOiJyZWRpcmVjdEludGVyYWN0aW9uIn0%3D&nonce=dbbac29e-1f6e-4296-b82b-c4fe74f3aab1&client_info=1&x-client-SKU=MSAL.JS&x-client-Ver=1.4.3&login_hint=322871377%40idf.il&client-request-id=4aec92d2-bf3f-47e1-ba22-1ae5ea58de16&response_mode=fragment",headers: headers34);
                                        log("RANSSSSSSSSSSS");
                                        log("aaa" + response.headers.toString() + "aaaa");
                                      
                                      } */
                                      /*
              if(url.startsWith("https://login.microsoftonline.com/78820852-55fa-450b-908d-45c0d911e76b/login"))
               {
                   var headers3 = {
                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*;q=0.8,application/signed-exchange;v=b3;q=0.9',
                'Cookie': s
                ,'User-Agent': 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Mobile Safari/537.36 Edg/87.0.664.66'
                ,'Accept-Language': 'en-US,en;q=0.9',
                'Accept-Encoding': 'gzip, deflate, br',
                'Referer': tempurl
                };
                                        var response = await http.post(url,headers: headers3);
                                        print("SSSSSSSSSSSSSSSSS");
                                        print(response.headers);
                                      }
                                      */
                                      //accessToken: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjVPZjlQNUY5Z0NDd0NtRjJCT0hIeEREUS1EayJ9.eyJhdWQiOiI4YTM1MzZlNy1iNGQ5LTQ5MmUtYjhjNy0xZjM5MjIxNDIwMDciLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vNzg4MjA4NTItNTVmYS00NTBiLTkwOGQtNDVjMGQ5MTFlNzZiL3YyLjAiLCJpYXQiOjE2MTAzNjczMzEsIm5iZiI6MTYxMDM2NzMzMSwiZXhwIjoxNjEwMzcxMjMxLCJhaW8iOiJFMklBQWwwZFQ2bmR2U2xjcjAwVXc5MG4zQTcyMVBFTGs3b1ZFcnBUUHVyeVNmRkpaUzk3SzhQOVdwVGxUb2pMT01UWVpnVS9lS0oxMG5sVDVaVkdtUmZMZFRRODhsU2ZtSC9ZbTNEMWdMYUlqbWVkNmhrQSIsIm5hbWUiOiLXqNefINeh16DXoNehIiwibm9uY2UiOiJiMjMwNmU2My1mYzBiLTQ4NjQtYmM5Ny1mMzFiY2JlODIxZGQiLCJvaWQiOiIyYThhNTU1Mi1lMTViLTRjY2ItYjI2Ny1hMjE5YzVlZjE4YWQiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIzMjI4NzEzNzdAaWRmLmlsIiwicmgiOiIwLkFUVUFVZ2lDZVBwVkMwV1FqVVhBMlJIbmEtYzJOWXJadEM1SnVNY2ZPU0lVSUFjMUFMOC4iLCJzdWIiOiJ2eml3clhvWVhrMGVRYmNmaFo5OUVXN09abDNGcE9TVlVONl80MTFNcm93IiwidGlkIjoiNzg4MjA4NTItNTVmYS00NTBiLTkwOGQtNDVjMGQ5MTFlNzZiIiwidXRpIjoiWDctSDlxWXNYME9YYTVFV2J1UEZBQSIsInZlciI6IjIuMCJ9.YZAxxMZgPK7xF9uJCHh4yxgTe_stZEk5BhL8bc18y326mUmqjCm1nrU4j-Ea-c_2uAsES7XaJp9mPEZOIHxzOiHorSjYJJSBXNz7ig5UQhTHvvjuzFCsM1-4oneRsoOKnaTYDgr3w6ANHbgBLMQU8MQ4OCuEHC3FELJ5NQmyLDOj4laJod1MHR2FIODOIoihTIgQ8mn1RHjn4KnzhBPIjyzKFavklr0Z9wfydvaS7YOYUNz4JJUOVT__Hrdoa5rMjgZrpLMInIoUmd5VrPE3Uvhj4lm0x4Ya9tr2BRKhoWdvS4FUx65-_nyYjm9WFK69DD4AJYGCLoR19qv2TWRn-w"
                                      //idToken: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjVPZjlQNUY5Z0NDd0NtRjJCT0hIeEREUS1EayJ9.eyJhdWQiOiI4YTM1MzZlNy1iNGQ5LTQ5MmUtYjhjNy0xZjM5MjIxNDIwMDciLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vNzg4MjA4NTItNTVmYS00NTBiLTkwOGQtNDVjMGQ5MTFlNzZiL3YyLjAiLCJpYXQiOjE2MTAzNjczMzEsIm5iZiI6MTYxMDM2NzMzMSwiZXhwIjoxNjEwMzcxMjMxLCJhaW8iOiJFMklBQWwwZFQ2bmR2U2xjcjAwVXc5MG4zQTcyMVBFTGs3b1ZFcnBUUHVyeVNmRkpaUzk3SzhQOVdwVGxUb2pMT01UWVpnVS9lS0oxMG5sVDVaVkdtUmZMZFRRODhsU2ZtSC9ZbTNEMWdMYUlqbWVkNmhrQSIsIm5hbWUiOiLXqNefINeh16DXoNehIiwibm9uY2UiOiJiMjMwNmU2My1mYzBiLTQ4NjQtYmM5Ny1mMzFiY2JlODIxZGQiLCJvaWQiOiIyYThhNTU1Mi1lMTViLTRjY2ItYjI2Ny1hMjE5YzVlZjE4YWQiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIzMjI4NzEzNzdAaWRmLmlsIiwicmgiOiIwLkFUVUFVZ2lDZVBwVkMwV1FqVVhBMlJIbmEtYzJOWXJadEM1SnVNY2ZPU0lVSUFjMUFMOC4iLCJzdWIiOiJ2eml3clhvWVhrMGVRYmNmaFo5OUVXN09abDNGcE9TVlVONl80MTFNcm93IiwidGlkIjoiNzg4MjA4NTItNTVmYS00NTBiLTkwOGQtNDVjMGQ5MTFlNzZiIiwidXRpIjoiWDctSDlxWXNYME9YYTVFV2J1UEZBQSIsInZlciI6IjIuMCJ9.YZAxxMZgPK7xF9uJCHh4yxgTe_stZEk5BhL8bc18y326mUmqjCm1nrU4j-Ea-c_2uAsES7XaJp9mPEZOIHxzOiHorSjYJJSBXNz7ig5UQhTHvvjuzFCsM1-4oneRsoOKnaTYDgr3w6ANHbgBLMQU8MQ4OCuEHC3FELJ5NQmyLDOj4laJod1MHR2FIODOIoihTIgQ8mn1RHjn4KnzhBPIjyzKFavklr0Z9wfydvaS7YOYUNz4JJUOVT__Hrdoa5rMjgZrpLMInIoUmd5VrPE3Uvhj4lm0x4Ya9tr2BRKhoWdvS4FUx65-_nyYjm9WFK69DD4AJYGCLoR19qv2TWRn-w"
                                      /*
                                      localStorage.setItem(Object.keys(localStorage)[0],JSON.stringify({"accessToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjVPZjlQNUY5Z0NDd0NtRjJCT0hIeEREUS1EayJ9.eyJhdWQiOiI4YTM1MzZlNy1iNGQ5LTQ5MmUtYjhjNy0xZjM5MjIxNDIwMDciLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vNzg4MjA4NTItNTVmYS00NTBiLTkwOGQtNDVjMGQ5MTFlNzZiL3YyLjAiLCJpYXQiOjE2MTAzNjczMzEsIm5iZiI6MTYxMDM2NzMzMSwiZXhwIjoxNjEwMzcxMjMxLCJhaW8iOiJFMklBQWwwZFQ2bmR2U2xjcjAwVXc5MG4zQTcyMVBFTGs3b1ZFcnBUUHVyeVNmRkpaUzk3SzhQOVdwVGxUb2pMT01UWVpnVS9lS0oxMG5sVDVaVkdtUmZMZFRRODhsU2ZtSC9ZbTNEMWdMYUlqbWVkNmhrQSIsIm5hbWUiOiLXqNefINeh16DXoNehIiwibm9uY2UiOiJiMjMwNmU2My1mYzBiLTQ4NjQtYmM5Ny1mMzFiY2JlODIxZGQiLCJvaWQiOiIyYThhNTU1Mi1lMTViLTRjY2ItYjI2Ny1hMjE5YzVlZjE4YWQiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIzMjI4NzEzNzdAaWRmLmlsIiwicmgiOiIwLkFUVUFVZ2lDZVBwVkMwV1FqVVhBMlJIbmEtYzJOWXJadEM1SnVNY2ZPU0lVSUFjMUFMOC4iLCJzdWIiOiJ2eml3clhvWVhrMGVRYmNmaFo5OUVXN09abDNGcE9TVlVONl80MTFNcm93IiwidGlkIjoiNzg4MjA4NTItNTVmYS00NTBiLTkwOGQtNDVjMGQ5MTFlNzZiIiwidXRpIjoiWDctSDlxWXNYME9YYTVFV2J1UEZBQSIsInZlciI6IjIuMCJ9.YZAxxMZgPK7xF9uJCHh4yxgTe_stZEk5BhL8bc18y326mUmqjCm1nrU4j-Ea-c_2uAsES7XaJp9mPEZOIHxzOiHorSjYJJSBXNz7ig5UQhTHvvjuzFCsM1-4oneRsoOKnaTYDgr3w6ANHbgBLMQU8MQ4OCuEHC3FELJ5NQmyLDOj4laJod1MHR2FIODOIoihTIgQ8mn1RHjn4KnzhBPIjyzKFavklr0Z9wfydvaS7YOYUNz4JJUOVT__Hrdoa5rMjgZrpLMInIoUmd5VrPE3Uvhj4lm0x4Ya9tr2BRKhoWdvS4FUx65-_nyYjm9WFK69DD4AJYGCLoR19qv2TWRn-w","idToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjVPZjlQNUY5Z0NDd0NtRjJCT0hIeEREUS1EayJ9.eyJhdWQiOiI4YTM1MzZlNy1iNGQ5LTQ5MmUtYjhjNy0xZjM5MjIxNDIwMDciLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vNzg4MjA4NTItNTVmYS00NTBiLTkwOGQtNDVjMGQ5MTFlNzZiL3YyLjAiLCJpYXQiOjE2MTAzNjczMzEsIm5iZiI6MTYxMDM2NzMzMSwiZXhwIjoxNjEwMzcxMjMxLCJhaW8iOiJFMklBQWwwZFQ2bmR2U2xjcjAwVXc5MG4zQTcyMVBFTGs3b1ZFcnBUUHVyeVNmRkpaUzk3SzhQOVdwVGxUb2pMT01UWVpnVS9lS0oxMG5sVDVaVkdtUmZMZFRRODhsU2ZtSC9ZbTNEMWdMYUlqbWVkNmhrQSIsIm5hbWUiOiLXqNefINeh16DXoNehIiwibm9uY2UiOiJiMjMwNmU2My1mYzBiLTQ4NjQtYmM5Ny1mMzFiY2JlODIxZGQiLCJvaWQiOiIyYThhNTU1Mi1lMTViLTRjY2ItYjI2Ny1hMjE5YzVlZjE4YWQiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIzMjI4NzEzNzdAaWRmLmlsIiwicmgiOiIwLkFUVUFVZ2lDZVBwVkMwV1FqVVhBMlJIbmEtYzJOWXJadEM1SnVNY2ZPU0lVSUFjMUFMOC4iLCJzdWIiOiJ2eml3clhvWVhrMGVRYmNmaFo5OUVXN09abDNGcE9TVlVONl80MTFNcm93IiwidGlkIjoiNzg4MjA4NTItNTVmYS00NTBiLTkwOGQtNDVjMGQ5MTFlNzZiIiwidXRpIjoiWDctSDlxWXNYME9YYTVFV2J1UEZBQSIsInZlciI6IjIuMCJ9.YZAxxMZgPK7xF9uJCHh4yxgTe_stZEk5BhL8bc18y326mUmqjCm1nrU4j-Ea-c_2uAsES7XaJp9mPEZOIHxzOiHorSjYJJSBXNz7ig5UQhTHvvjuzFCsM1-4oneRsoOKnaTYDgr3w6ANHbgBLMQU8MQ4OCuEHC3FELJ5NQmyLDOj4laJod1MHR2FIODOIoihTIgQ8mn1RHjn4KnzhBPIjyzKFavklr0Z9wfydvaS7YOYUNz4JJUOVT__Hrdoa5rMjgZrpLMInIoUmd5VrPE3Uvhj4lm0x4Ya9tr2BRKhoWdvS4FUx65-_nyYjm9WFK69DD4AJYGCLoR19qv2TWRn-w","expiresIn":"19999999999","homeAccountIdentifier":"eyJ1aWQiOiIyYThhNTU1Mi1lMTViLTRjY2ItYjI2Ny1hMjE5YzVlZjE4YWQiLCJ1dGlkIjoiNzg4MjA4NTItNTVmYS00NTBiLTkwOGQtNDVjMGQ5MTFlNzZiIn0="}));
                                      */


                                                                       /* controller.evaluateJavascript(source: "JSON.parse(localStorage.setItem((Object.keys(localStorage)[0]))['expiresIn'],'99999');");
                                                                        controller.evaluateJavascript(source: "JSON.parse(localStorage.getItem(Object.keys(localStorage)[0]))['expiresIn'];").then((result) {

                                                                   log(result);
                                                                        });*/
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
      Future<void> initializenotifications() async { 
            
          // initialise the plugin of flutterlocalnotifications. 
          FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin(); 
            
          // app_icon needs to be a added as a drawable 
          // resource to the Android head project. 
          var android = new AndroidInitializationSettings('@mipmap/ic_launcher'); 
          var IOS = new IOSInitializationSettings(); 
            
          // initialise settings for both Android and iOS device. 
          var settings = new InitializationSettings(android:android, iOS: IOS); 
              await flip.initialize(settings);

      } 
        

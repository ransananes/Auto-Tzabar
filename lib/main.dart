
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

Future<void> sendAPIS() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  now = int.parse(DateFormat.H().format(new DateTime.now()));
  if (now >= 0 && now < 5) {
    failed = true;
    sp.setBool("failed", true);
  } else if ((now >= 5) && (now < 10)) {
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
      'scope': 'https://graph.microsoft.com/user.readwrite openid profile',
      'client_id': '8a3536e7-b4d9-492e-b8c7-1c3922142007',
      'redirect_uri': 'https://clearance.medical.idf.il/auth.html',
      'state':
          'eyJpZCI6Ijc0OTNhMDM4LTdkMzMtNDVkZS05NTI4LTE4MThiZWJiNWZkMCIsInRzIjoxNjEwMTMyOTA2LCJtZXRob2QiOiJyZWRpcmVjdEludGVyYWN0aW9uIn0=',
      'nonce': '5e1ca72d-7b43-483f-906a-f463601d2e39',
      'login_hint': '12345678@idf.il', //id
      'client-request-id': '4d9dcb28-8348-43ea-bcaa-73c540b67394',
      'response_mode': 'fragment'
    };
    var headers3 = {
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'Cookie':
          "ESTSAUTHPERSISTENT=0.ATUAUgiCePpVC0WQjUXA2RHna-c2NYrZtC5JuMcfOSIUIAc1AL8.AgABAAQAAABeStGSRwwnTq2vHplZ9KL4AQDs_wMA9P-wAs7GExAE0uyuai4YhKVLH0e2x6g_S_brK5b9ZsECHzTfExzpeQ1UtjUMTenbIPzBN0YqiYdY_O65gcrINPaX0bLFYpJDuXCq8BorImYMdQiNM0uagku_hxYRuDxQRsBUJQ1pDcKgnXZ4H2gONB_z4F_3lKBpg_vlpuCIECDbZs8BAWZiAOCscC6kn8x4J0v6CC1u4UzOVG_ozZF9RI-tEQ6bkphwEcL9PDDvgTPcuWnVTVNVUOlvOW5Yyumw3ZLC2rjz5RFmN3cVDjExF-HM0Q1r8vuhX18CP-YIL-9c6Se45D-m0yErL3fLVogbYvndimccOiVLJSjiX2pfyaZYpZMc0ePPk1okLTUHNzpIY7ENi_wMRXX1bdctYhPNmX9l1gVKHhTzslCVFF-mHgnKfOG6TQ3J-s_CKltoQEvH0P6vwOMSUDgxMI5hJOAVM6zd6S_hrvoI-QrKrrOC8xlX-qT9s5-6NWAhs70RY3moqjsHDjkG",
      'User-Agent':
          'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Mobile Safari/537.36 Edg/87.0.664.66',
      'Accept-Language': 'en-US,en;q=0.9',
      'Accept-Encoding': 'gzip, deflate, br',
      'Referer': 'https://clearance.medical.idf.il/'
    };
    var response = await http.post(
        'https://login.microsoftonline.com/78820852-55fa-450b-908d-45c0d911e76b/oauth2/v2.0/authorize',
        headers: headers3,
        body: queryParameters);
    token = response.body.substring(135, 1453);
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
  if (!sp_log.containsKey("failed")) sp_log.setBool("failed", true);
  if (!sp_log.containsKey("symptoms")) sp_log.setBool("symptoms", false);
  if (!sp_log.containsKey("proximity")) sp_log.setBool("proximity", false);
  if (!sp_log.containsKey("fever")) sp_log.setBool("fever", false);
  if (!sp_log.containsKey("allergy")) sp_log.setBool("allergy", false);
  if (!sp_log.containsKey("fluvaccine")) sp_log.setBool("fluvaccine", false);

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
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 3,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            startOnBoot: true,
            forceAlarmManager: true,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // This is the app running in the background
      switch (taskId) {
        default:
          sendAPIS();
      }
      BackgroundFetch.finish(taskId);
    }).then((int status) {
    }).catchError((e) {
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => settings()));
              })
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
            )),
            onWebViewCreated: (InAppWebViewController controller) {},
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
              controller
                  .evaluateJavascript(
                      source:
                          "JSON.parse(localStorage.getItem(Object.keys(localStorage)[0]))['accessToken'];")
                  .then((result) {
                if (result != null) sp.setString("token", result);
              });

              var status = await Permission.ignoreBatteryOptimizations.status;
              if (status.isUndetermined || status.isDenied) {
                Map<Permission, PermissionStatus> statuses =
                    await [Permission.ignoreBatteryOptimizations].request();
              }

              onProgressChanged:
              (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              };
            },
          )),
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
  var settings = new InitializationSettings(android: android, iOS: IOS);
  await flip.initialize(settings);
}

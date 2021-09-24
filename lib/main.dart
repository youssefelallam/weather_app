import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String temp_c = '';
  late String icon, state, sunset;
  List my_data = <Map>[];
  get_data() async {
    String url =
        'https://api.weatherapi.com/v1/forecast.json?key={API KEY}={-latitude-longitude-}';
    http.Response response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body);
    setState(() {
      temp_c = jsondata['current']['temp_c'].toString();
      icon = jsondata['current']['condition']['icon'].toString();
      state =
          jsondata['current']['condition']['text'].toString();
      ///
      for (var item in jsondata['forecast']['forecastday']) {
        for (var one in item['hour']) {
          var time_s = one['time'].toString().split(' ');
          my_data.add({
            'time': time_s[1],
            'temp_c': one['temp_c'],
            'icon': one['condition']['icon']
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    get_data();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff6dd5ed), Color(0xff2193b0)])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: my_data.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Container(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'https:'+icon,
                                    scale: 0.3,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    state,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    ' $temp_c °',
                                    style: TextStyle(
                                      fontSize: 90,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 110,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: my_data.length,
                              itemBuilder: (Context, index) {
                                return Container(
                                  width: 80,
                                  margin: EdgeInsets.symmetric(horizontal: 9),
                                  decoration: BoxDecoration(
                                      color:
                                          Color(0xffC0FAE8).withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(my_data[index]['time']),
                                      Text(my_data[index]['temp_c'].toString()),
                                      Image.network('https:'+my_data[index]['icon'].toString()),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

import 'package:enterslice/Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'LocationModel.dart';
import 'databaseHelper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.openDb();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
getLocation() async {
  LocationPermission permission=await Geolocator.checkPermission();

  if(permission==LocationPermission.denied){
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  // position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);


  Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.high)).listen((event) async {

    await DatabaseHelper.openDb();
    var now=DateTime.now();

    LocationModel locationModel=LocationModel(latitude: "${event.latitude}",longitude: "${event.longitude}",time: "${now.hour},${now.minute},${now.second}");
    DatabaseHelper.db.insert("location", locationModel.toJson());
    broadcast.broadcast("loc",value: locationModel);
  });
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Controller controller=Get.put(Controller());
  MethodChannel methodChannel=MethodChannel("flutter");
  RxList<LocationModel> list= <LocationModel>[].obs;

  @override
  void initState() {
    super.initState();
    getData();
    getLocation();

    methodChannel.setMethodCallHandler((call) async{
      controller.data.value="${call.method}\n${call.arguments}";
      print(call.arguments);
    });

    broadcast.register("loc", listner);
  }

  getData() async {
    List<Map> maps=await DatabaseHelper.db.query("location");
    for(final x in maps){
      list.insert(0,LocationModel.fromJson(x));
    }
  }

  listner(value, callback) {
    LocationModel locationModel = value;
    list.insert(0, locationModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Obx(() => ListView.builder(itemCount: list.length,itemBuilder: (itemBuilder,index){
        return Text(list[index].time!);
      })),
      bottomNavigationBar: SizedBox(height:  150,child: InkWell(onTap: () async {


      },child: Container(decoration: BoxDecoration(color: Colors.red.withOpacity(.2)),child:

      Center(child: Column(mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Text(controller.data.value,textAlign: TextAlign.center,)),
          SizedBox(height: 16,),
          ElevatedButton(onPressed: () {
            methodChannel.invokeMethod("method","Hello this is Flutter sending Msg").then((value){
              Fluttertoast.showToast(msg: "Successful");
            });
          },
              child: Text("Send Method Data")),
        ],
      ),),

      // Center(child: Text("Start Background",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
      )),),




    );
  }
}

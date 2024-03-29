import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_apps/device_apps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
 class Homepage extends StatefulWidget {
   const Homepage({Key? key}) : super(key: key);
 
   @override
   State<Homepage> createState() => _HomepageState();
 }

 class _HomepageState extends State<Homepage> {

   final BouncingScrollPhysics _bouncingScrollPhysics = const BouncingScrollPhysics();

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: Container(
         color: Colors.white,
         margin: const EdgeInsets.all(7.0),
         child: Container(
           color: Colors.black,
           child: FutureBuilder(
             future: DeviceApps.getInstalledApplications(
               includeSystemApps: true,
               onlyAppsWithLaunchIntent: true,
             ),
               builder: (context, AsyncSnapshot<List<Application>>snapshot){
               if (snapshot.connectionState == ConnectionState.done){
                 List<Application> allApps = snapshot.data!;
                 appsSort(allApps);
                 appsFilter(allApps);
                 return Padding(
                   padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 0.0),
                   child: GridView.count(
                     crossAxisCount: 2,
                     childAspectRatio: 4/1,
                     physics: _bouncingScrollPhysics,
                     children: List.generate(allApps.length, (index) {
                       return GestureDetector(
                         onTap: () {
                           DeviceApps.openApp(allApps[index].packageName);
                         },
                         onLongPress: () {
                           DeviceApps.openAppSettings(allApps[index].packageName);
                         },
                         child: Column(
                            children: [
                              Text(
                                allApps[index].appName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                         ),
                       );
                     }),
                   ),
                 );
               }
                return const Center(
                  child: CircularProgressIndicator(),
                );
               },
           ),
         ),
       ),
     );
   }

  void appsFilter(List<Application> allApps){
     //remove undesired apps from launcher screen
    List<String> appsToRemove = [
      "com.android.angle",
      "com.android.traceur",
      "com.android.healthconnect.controller"
    ];

    for (int i = 0; i < allApps.length; i++) {
      if (appsToRemove.contains(allApps[i].packageName)) {
        allApps.removeAt(i);
      }
    }
  }

  void appsSort(List<Application> allApps) {
    //sort alphabetically
    for (int i = 0; i < allApps.length - 1; i++) {
      for (int j = 0; j < allApps.length - 1 - i; j++) {
        if (allApps[j].appName.compareTo(allApps[j+1].appName) == 1) {
          Application temp = allApps[j];
          allApps[j] = allApps[j+1];
          allApps[j+1] = temp;
        }
      }
    }
  }

 }
 
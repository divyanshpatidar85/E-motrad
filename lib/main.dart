// import 'dart:convert';

import 'package:att/api.dart';
import 'package:att/bloc/attendance-bloc.dart';
import 'package:att/bloc/clock-in-out-status.dart';
import 'package:att/bloc/employee-bloc.dart';
import 'package:att/bloc/user-cubit.dart';
import 'package:att/const/theme.dart';
import 'package:att/const/time-picker.dart';
import 'package:att/localStorage/sharedpref.dart';
import 'package:att/model/login_model.dart';
import 'package:att/model/user-model.dart';
import 'package:att/screen/admin-home-screen.dart';
import 'package:att/screen/animated-screen.dart';
import 'package:att/screen/clock-in-out-screen.dart';
import 'package:att/screen/employee-home-screen.dart';
import 'package:att/screen/employee-list-screen.dart';
import 'package:att/screen/login-screen.dart';
import 'package:att/screen/tab-controller-screen.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => clockInStatus()), 
        BlocProvider(create: (context) => AttendanceCubit()),
       BlocProvider(create: (context) => EmployeeCubit()),
        // Ensure UserCubit is available globally
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner:false,
      theme:Themes.light,
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home:MyHomePage(title:''),

//       home:InkWell(
//         onTap:()async{
//           final TimeOfDay? result = await showTimePicker(
// context: context,
// initialTime: TimeOfDay.now(),
// );
// if (result != null) {
// print("Selected Time: ${result.format(context)}");
//         }
//         },
//         child: Container(
//           height:500,
//           width:100,
//           child:Text("HI"),
//             ),
//       )
      );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  String? email,usertype;

  bool isloading=true;
  @override
  void initState() {
   
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (context.read<AttendanceCubit>().state.isEmpty) {
        getData();
      // }
    });

  }

  void getData()async{
    
  
   List<String?>val=await UserPreferences.getUserInfo(context);
   email=val.isEmpty?null:val[0];
   usertype=val.isEmpty?null:val[1];

   isloading=false;
  print("here is loading ${isloading}");
   setState(() {
     
   });
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit,UserModel?>(
  builder: (context, state) { 
     if (state == null && isloading) {
        return const Scaffold(
          body:EMotoradAnimatedScreen(),
        );
      }
    return Scaffold(
      body: (email != null && email!.isNotEmpty)
          ? (usertype == "Employee"
              ? EmployeeHomeScreen()
              : HomeScreen()) // admin home  screejj
          : TabControllerScreen(),
    );
  },
);
  }
    
  }



// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     data();
//   }
//   void data()async{
//   final plainText = '123456';
//   final key = encrypt.Key.fromUtf8('my 32 length key................');
//   final iv=encrypt.IV.fromBase64("78pCytyfvxepQDMRoTRUgg==");

//   final encrypter = encrypt.Encrypter(encrypt.AES(key));

//   final encrypted = encrypter.encrypt(plainText, iv:iv );
// // 78pCytyfvxepQDMRoTRUgg==

//   print("hello i am password ${encrypted.base64}  10a285ea60787a405b36a2fc76401262");
//   // final decrypted = encrypter.decrypt(encrypted, iv: iv);
//   // String encryptedPassword = encrypted.base64;
//   // String ivBase64 = iv.base64;
//   // print("here ivbase64 hahah ${ivBase64}");

//     // print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
//   // print("dipu is here ${encrypted.base64}");
    
//     // var res= await GoogleSheetsApi.registerUser(email:"email@gmail.com",password:encrypted.base64,key:iv.base64,name:"email",role:"Admin");
//     //  print("here ans is ${res.toString()}");
//   //  var res2= await GoogleSheetsApi.loginUser("email@gmail.com","123A");
//   //  print("here password is ${res2["data"]["key"]}  ${res2["data"]["password"]}");
//     // final keytodecypr = encrypt.IV.fromBase64(res2["data"]["key"]);

//   //  final encrypted1 = encrypter.encrypt(plainText, iv: keytodecypr);
//   //  print("login status is here $encrypted1\n ${res2["data"]["password"]}\n ${encrypted1.base64==res2["data"]["password"]}");
//   //  print("here is decrpited password ${encrypter.decrypt(res2["data"]["password"], iv: iv)}");
//   // var res1= await GoogleSheetsApi.clockIn("UID1740673366438179","xyz@dgmail.com");
//   //   print("here ans is ${res1.toString()}");
//   // var res= await GoogleSheetsApi.clockOut("UID1740673366438179","xyz@dgmail.com");
//   // print("here ans is ${res.toString()}");
//     // Get the encrypted password from API response
//   // String encryptedPasswordBase64 = res2["data"]["password"];
//   // print("Here is the encrypted password (Base64): $encryptedPasswordBase64");

//   // Convert the Base64 string back to an encrypted format
// //   final encryptedPasswordd = encrypt.Encrypted.fromBase64(encryptedPasswordBase64);
// // final keytodecypr = encrypt.IV.fromBase64("r1Rz6nVmRKrfxOc4v3frIA==");
// //   // Now decrypt the password
//   // final decryptedPassword = encrypter.decrypt(encryptedPasswordd, iv: keytodecypr);
//   // print("Here is the decrypted password: $decryptedPassword");
//   }
//   TextEditingController con=TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment:MainAxisAlignment.center,
//         children: [
//           // TimeInputField(controller:con, label: '', onTimeChanged: (String ) {  },),
//           Center(
//             child: InkWell(
//                 onTap:()async{
//                   final TimeOfDay? result = await showTimePicker(
//             context: context,
//             initialTime: TimeOfDay.now(),
//             );
//             if (result != null) {
//             print("Selected Time: ${result.format(context)}");
//                 }
//                 },
//                 child: Container(
//                   height:500,
//                   width:100,
//                   child:Text("HI"),
//                     ),
//               ),
//           ),
//         ],
//       ),
//     );
//     // return LoginScreen();
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       // TRY THIS: Try changing the color here to a specific color (to
//   //       // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//   //       // change color while the other colors stay the same.
//   //       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//   //       // Here we take the value from the MyHomePage object that was created by
//   //       // the App.build method, and use it to set our appbar title.
//   //       title: Text(widget.title),
//   //     ),
//   //     body: Center(
//   //       // Center is a layout widget. It takes a single child and positions it
//   //       // in the middle of the parent.
//   //       child: Column(
//   //         // Column is also a layout widget. It takes a list of children and
//   //         // arranges them vertically. By default, it sizes itself to fit its
//   //         // children horizontally, and tries to be as tall as its parent.
//   //         //
//   //         // Column has various properties to control how it sizes itself and
//   //         // how it positions its children. Here we use mainAxisAlignment to
//   //         // center the children vertically; the main axis here is the vertical
//   //         // axis because Columns are vertical (the cross axis would be
//   //         // horizontal).
//   //         //
//   //         // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//   //         // action in the IDE, or press "p" in the console), to see the
//   //         // wireframe for each widget.
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         children: <Widget>[
//   //           Text("heelo",style:labelStyle,),
//   //           const Text(
//   //             'You have pushed the button this many times:',
//   //           ),
//   //           Text(
//   //             '$_counter',
//   //             style: Theme.of(context).textTheme.headlineMedium,
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //     floatingActionButton: FloatingActionButton(
//   //       onPressed: _incrementCounter,
//   //       tooltip: 'Increment',
//   //       child: const Icon(Icons.add),
//   //     ), // This trailing comma makes auto-formatting nicer for build methods.
//   //   );
//   // }
//   }
// }


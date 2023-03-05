import 'package:flutter/material.dart';
import 'package:flutter_map_example/common/dimens/dimens.dart';
import 'package:flutter_map_example/ui/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            fixedSize: const MaterialStatePropertyAll(Size(double.infinity,58)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.medium))),
            elevation: const MaterialStatePropertyAll(0),
            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if(states.contains(MaterialState.pressed)){
                return const Color.fromARGB(255, 20, 236, 24);
              }
              return const Color.fromARGB(255, 2, 207, 6);
            })
          )
        ),
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}




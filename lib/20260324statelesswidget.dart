import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello Flutter!!",
      home: const MyHomePage(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 224, 104, 6),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rise Realize!!",
          style: TextStyle(backgroundColor: Color.fromARGB(255, 230, 159, 8), fontSize: 30),
        ),
      ),
      body: Center(
        child:
        Image.asset("assets/images/riize10.jpg"),     
            // Image.network(
            //   "https://www.ticketbuynow.com/wp-content/uploads/2025/05/riize9.png",
            // ), 
      ),   
    );
  }
  const MyHomePage({super.key});
}

@override
Widget build(BuildContext context) {
  var image;
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        "Rise Realize!!",
        style: TextStyle(backgroundColor: Color.fromARGB(255, 226, 139, 7), fontSize: 30),
      ),
    ),
    //
    body: Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          image.aset("assets/images/riize10.jpg"),
          const Text(
            "Riize",
            style: TextStyle(
              fontSize: 60,
              color: Color.fromARGB(255, 235, 102, 13),
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      )
      
         
            // Image.network(
            //   "https://www.ticketbuynow.com/wp-content/uploads/2025/05/riize9.png",
            // ),
      // child: Image.network(
      //   src: "https://www.ticketbuynow.com/wp-content/uploads/2025/05/riize9.png"),
      ), 
  );
}    
      // child: Text(
      //   "Riize",
      //   style: TextStyle(
      //     backgroundColor: Color.fromARGB(255, 212, 235, 8),
      //     fontSize: 60,
        
      
    
  


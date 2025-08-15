import 'package:flutter/material.dart';
import 'quiz.dart';
import 'weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  if (!kIsWeb) {
    await dotenv.load(fileName: "assets/.env"); 
  }

  runApp(DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.quiz), text: "Quiz"),
              Tab(icon: Icon(Icons.cloud), text: "Weather")
            ]),
            title: Text('II-BDCC'),
          ),
          body: TabBarView(
            children: [Quiz(), Weather()],
          ),
        ),
      ),
    );
  }
}

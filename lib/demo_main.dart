// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         // This is the theme of your application.
// //         //
// //         // TRY THIS: Try running your application with "flutter run". You'll see
// //         // the application has a purple toolbar. Then, without quitting the app,
// //         // try changing the seedColor in the colorScheme below to Colors.green
// //         // and then invoke "hot reload" (save your changes or press the "hot
// //         // reload" button in a Flutter-supported IDE, or press "r" if you used
// //         // the command line to start the app).
// //         //
// //         // Notice that the counter didn't reset back to zero; the application
// //         // state is not lost during the reload. To reset the state, use hot
// //         // restart instead.
// //         //
// //         // This works for code too, not just values: Most code changes can be
// //         // tested with just a hot reload.
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //         useMaterial3: true,
// //       ),
// //       home: const MyHomePage(title: 'Flutter Demo Home Page'),
// //     );
// //   }
// // }

// // class MyHomePage extends StatefulWidget {
// //   const MyHomePage({super.key, required this.title});

// //   // This widget is the home page of your application. It is stateful, meaning
// //   // that it has a State object (defined below) that contains fields that affect
// //   // how it looks.

// //   // This class is the configuration for the state. It holds the values (in this
// //   // case the title) provided by the parent (in this case the App widget) and
// //   // used by the build method of the State. Fields in a Widget subclass are
// //   // always marked "final".

// //   final String title;

// //   @override
// //   State<MyHomePage> createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   int _counter = 0;

// //   void _incrementCounter() {
// //     setState(() {
// //       // This call to setState tells the Flutter framework that something has
// //       // changed in this State, which causes it to rerun the build method below
// //       // so that the display can reflect the updated values. If we changed
// //       // _counter without calling setState(), then the build method would not be
// //       // called again, and so nothing would appear to happen.
// //       _counter++;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // This method is rerun every time setState is called, for instance as done
// //     // by the _incrementCounter method above.
// //     //
// //     // The Flutter framework has been optimized to make rerunning build methods
// //     // fast, so that you can just rebuild anything that needs updating rather
// //     // than having to individually change instances of widgets.
// //     return Scaffold(
// //       appBar: AppBar(
// //         // TRY THIS: Try changing the color here to a specific color (to
// //         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
// //         // change color while the other colors stay the same.
// //         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
// //         // Here we take the value from the MyHomePage object that was created by
// //         // the App.build method, and use it to set our appbar title.
// //         title: Text(widget.title),
// //       ),
// //       body: Center(
// //         // Center is a layout widget. It takes a single child and positions it
// //         // in the middle of the parent.
// //         child: Column(
// //           // Column is also a layout widget. It takes a list of children and
// //           // arranges them vertically. By default, it sizes itself to fit its
// //           // children horizontally, and tries to be as tall as its parent.
// //           //
// //           // Column has various properties to control how it sizes itself and
// //           // how it positions its children. Here we use mainAxisAlignment to
// //           // center the children vertically; the main axis here is the vertical
// //           // axis because Columns are vertical (the cross axis would be
// //           // horizontal).
// //           //
// //           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
// //           // action in the IDE, or press "p" in the console), to see the
// //           // wireframe for each widget.
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             const Text(
// //               'You have pushed the button this many times:',
// //             ),
// //             Text(
// //               '$_counter',
// //               style: Theme.of(context).textTheme.headlineMedium,
// //             ),
// //           ],
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: _incrementCounter,
// //         tooltip: 'Increment',
// //         child: const Icon(Icons.add),
// //       ), // This trailing comma makes auto-formatting nicer for build methods.
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Table Example'),
//         ),
//         body: Center(
//           child: DataTableWidget(),
//         ),
//       ),
//     );
//   }
// }

// class DataTableWidget extends StatelessWidget {
//   final Map<String, dynamic> data = {
//     "FusesNSupply": {
//       "Name": {
//         "Label": "Fuses and Supply",
//         "Alert": "",
//         "Hint": "",
//         "SectionView": "TableView",
//         "Expandable": true,
//         "tableIndex": ['a', 'b', 'c']
//       },
//       "Fuse property supply number": {
//         "Label": "Fuse Property Number",
//         "Type": "Text",
//         "DbTableName": null,
//         "DbColumnName": null,
//         "Unit": null,
//         "Required": true
//       },
//       "Fuse size": {
//         "Label": "Fuse Size",
//         "Type": "Dropdown",
//         "Options": ["32A", "40A", "63A", "80A", "100A", "160A"],
//         "DbTableName": null,
//         "DbColumnName": null,
//         "Unit": null,
//         "Required": true
//       },
//       "Fuse phase": {
//         "Label": "Fuse Phase",
//         "Type": "Dropdown",
//         "Options": ["Red", "White", "Blue"],
//         "DbTableName": null,
//         "DbColumnName": null,
//         "Unit": null,
//         "Required": true
//       }
//     }
//   };

//   @override
//   Widget build(BuildContext context) {
//     final nameData = data['FusesNSupply']['Name'];
//     final tableIndex = nameData['tableIndex'] as List<String>;
//     final tableData = [
//       {"Label": "Fuse Property Number", "a": "信息A1", "b": "信息A2", "c": "信息A3"},
//       {"Label": "Fuse Size", "a": "信息B1", "b": "信息B2", "c": "信息B3"},
//       {"Label": "Fuse Phase", "a": "信息C1", "b": "信息C2", "c": "信息C3"},
//     ];

//     final columns = ["Label"] + tableIndex;

//     return Table(
//       border: TableBorder.all(),
//       children: [
//         TableRow(
//           children: columns.map((header) {
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(header),
//             );
//           }).toList(),
//         ),
//         ...tableData.map((row) {
//           return TableRow(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(row['Label'] ?? ""),
//               ),
//               ...tableIndex.map((key) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(row[key] ?? ""),
//                 );
//               }).toList(),
//             ],
//           );
//         }).toList(),
//       ],
//     );
//   }
// }

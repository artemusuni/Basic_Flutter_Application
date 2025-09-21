import 'package:flutter/material.dart'; //I am importing the material library

void main() => runApp(const MyApp());  //The entry point to my Dart program

class MyApp extends StatelessWidget {

  const MyApp({super.key});    //Constructor passes 'super.key' as optional key
                              //to the base class for identity.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 1',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: const HomeScaffold(),

    );

  }

}

class HomeScaffold extends StatefulWidget {   //Am using a stateful widget because it will chage the based on idex
  const HomeScaffold({super.key});

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState(); //create mutable State object for the widget

}

class _HomeScaffoldState extends State<HomeScaffold> {

  int _index = 0;    //tab: 0 = Home, 1 = Settings

  final List<Widget> _pages = const [
    HomePage(),     //Index 0
    SettingsPage(),  //Index 1

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab 1"),
      ),
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int i) {  //call when user taps a destination
          setState(() => _index = i);     //update _index and rebuild/show new page
        },
        destinations: const [           //The two tabs showwn in the bar
          NavigationDestination(       //Destination 0
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",       //Text label under the icon
          ),
          NavigationDestination(      //Destination 1
            icon: Icon(),
            selectedIcon: Icon(Icons.settings),
            label: "Settings",
          ),

        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {  //for now it will be stateless, maybe later I will change that
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Home Page",
        style: TextStyle(fontSize: 22),       //slightly larget font
      ),
    );
  }
} //HomePage

class SettingsPage extends StatelessWidget {    //another stateless page
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Settings Page",
        style: TextStyle(fontSize: 22),
      ),
    );

  }
}
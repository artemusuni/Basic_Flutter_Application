import 'package:flutter/material.dart'; //I am importing the material library
import "package:shared_preferences/shared_preferences.dart";   //key-value storagefor small settings



void main() => runApp(const MyApp());  //The entry point to my Dart program

class MyApp extends StatefulWidget {   //I make it statefull because it will be changing themes

  const MyApp({super.key});    //Constructor passes 'super.key' as optional key
  
  @override                            //to the base class for identity
  State<MyApp> createState() => _MyAppState();

} //MyApp

class _MyAppState extends State<MyApp> {  //Holds the App-level state
  ThemeMode _themeMode = ThemeMode.system;           //Default to system theme

  @override
  void initState() {    //Runs once when the state is first created
    super.initState();
    _loadThemeFromPrefs(); //Load previously saved theme mode
  }

  Future<void> _loadThemeFromPrefs() async {  //Async function: read the saved theme from storage
    final prefs = await SharedPreferences.getInstance();  //obtain the shared preferences
    final saved = prefs.getString("themeMode") ?? "system"; //try reading the key for theme, fallback to "system" if missing
    setState(() {
      _themeMode = switch (saved) {  //map the stored string bck to a ThemeMode value
        "light" => ThemeMode.light,
        "dark" => ThemeMode.dark,
        _ => ThemeMode.system,
      };  
    });
  }

  Future<void> _savedThemeToPrefs(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();  //get the prefernce handle
    final asString = switch (mode) {   //conver enum to string for storage
      ThemeMode.light => "light",
      ThemeMode.dark => "dark",
      ThemeMode.system => "system",
    };
    await prefs.setString("themeMode", asString);   //Write to disk asynchronously.
  }

  void _setTheme(ThemeMode mode) {
    setState(() => _themeMode = mode);
    _savedThemeToPrefs(mode);

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lab 1 -Nav + Toggle + Theme",
      themeMode: _themeMode,
      theme: ThemeData(    //Light theme definition 
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      darkTheme: ThemeData(     //Dark theme definition
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: HomeScaffold(
        themeMode: _themeMode,
        onThemeChanged: _setTheme,
      ),
    );

  }
}

class HomeScaffold extends StatefulWidget {   //Am using a stateful widget because it will chage the based on idex
  const HomeScaffold({super.key, required this.themeMode, required this.onThemeChanged});
  final ThemeMode themeMode;          //The currretc theme mode
  final void Function(ThemeMode) onThemeChanged;    //Callback to update theme in the parrent(MyApp)

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState(); //create mutable State object for the widget

}

class _HomeScaffoldState extends State<HomeScaffold> {

  int _index = 0;    //tab: 0 = Home, 1 = Settings


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab 1"),
      ),
      body: IndexedStack(
        index: _index,
        children: [
          const HomePage(),
          SettingsPage(
            themeMode: widget.themeMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ],
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
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "Settings",
          ),

        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {  //stateful because it will be changing
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

} //HomePage

class _HomePageState extends State<HomePage> {   //Holds the toggle state
  bool _isOn = false;                    //false = red, true = green

  @override
  Widget build(BuildContext context) {
    final Color color = _isOn ? Colors.green : Colors.red;   // Computes the state of the _isOn and changes color 
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(      //this should be similar to a container, but more smooth
            duration: const Duration(milliseconds: 250),
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20), //a bit round corners
            ),
          ),
          const SizedBox(height: 20),  //adding vertical space between square and button
          FilledButton.tonal(
            onPressed: () {
              setState(() { _isOn = ! _isOn;});
            },
            child: Text(_isOn     //Button label depends on current state of _isOn
              ? "Turn OFF (Red)"
              : "Turn ON (Green)"),
            ),
        ],
      ),
    );
  }
}


//This pag is currently only a placeholder!!
class SettingsPage extends StatelessWidget {    //another stateless page
  const SettingsPage({super.key, required this.themeMode, required this.onThemeChanged});
  final ThemeMode themeMode;
  final void Function(ThemeMode) onThemeChanged;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,       //Left-align title
        children: [
          const ListTile(
            title: Text("Theme"),
            subtitle: Text("Choose Light, Dark, or follow System. Saved to SharedPreferences."),
          ),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: const [         //Define the 3 segments
              ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode), label: Text("Light")),
              ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode), label: Text("Dark")),
              ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.settings_suggest), label: Text("System")),
            ],
            selected: {themeMode},    //Which segment is currently selected
            onSelectionChanged: (set) =>
              onThemeChanged(set.first),
          ),
        ],
      ),
    );
  }
}
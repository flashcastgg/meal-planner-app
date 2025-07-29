// Main imports
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MealPlannerApp());
}

/// Root widget for the Meal Planner App
class MealPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weekly Meal Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFB0BEC5), // soft pastel grey
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFB0BEC5),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFB0BEC5),
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: MealPlannerScreen(),
    );
  }
}

/// Main screen for planning weekly meals
class MealPlannerScreen extends StatefulWidget {
  @override
  _MealPlannerScreenState createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  int selectedDay = 0;

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
late List<Map<String, String>> meals = List.generate(7, (_) => {'breakfast': '', 'lunch': '', 'dinner': ''});

  final List<Color> pastelColors = [
    Color(0xFFf3d4f3), // Peach
    Color(0xFFB3E5FC), // Sky Blue
    Color(0xFFB2DFDB), // Mint Green
  ];

  @override
  void initState() {
    super.initState();
    selectedDay = (DateTime.now().weekday - 1) % 7;
    loadMeals();
  }

Future<void> loadMeals() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('GeneratedMeals');
  if (saved != null) {
    final decoded = jsonDecode(saved);
    meals = List<Map<String, String>>.from(
      decoded.map((e) => Map<String, String>.from(e)));
  } else {
    meals = List.generate(7, (_) => {'breakfast': '', 'lunch': '', 'dinner': ''});
  }
  setState(() {});
}


  List<String> getRandomUnique(List<String> source, int count) {
  final List<String> shuffled = List<String>.from(source)..shuffle();
  return shuffled.take(count).toList();
}


Future<void> generateRandomMeals() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> breakfasts = List<String>.from(jsonDecode(prefs.getString('Breakfast') ?? '[]'))
      .whereType<String>()
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  final List<String> lunches = List<String>.from(jsonDecode(prefs.getString('Lunch') ?? '[]'))
      .whereType<String>()
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  final List<String> dinners = List<String>.from(jsonDecode(prefs.getString('Dinner') ?? '[]'))
      .whereType<String>()
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  List<String> uniqueBreakfasts = List.from(breakfasts)..shuffle();
  List<String> uniqueLunches = List.from(lunches)..shuffle();
  List<String> uniqueDinners = List.from(dinners)..shuffle();

  final List<Map<String, String>> newMeals = List.generate(7, (i) => {
    'breakfast': i < uniqueBreakfasts.length ? uniqueBreakfasts[i] : '',
    'lunch': i < uniqueLunches.length ? uniqueLunches[i] : '',
    'dinner': i < uniqueDinners.length ? uniqueDinners[i] : '',
  });

  await prefs.setString('GeneratedMeals', jsonEncode(newMeals));

  // Update local state if needed
  meals = newMeals;
  setState(() {});
}


  Widget buildMealCard(String title, String meal, Color backgroundColor) {
    IconData icon;
    switch (title.toLowerCase()) {
      case 'breakfast':
        icon = Icons.free_breakfast;
        break;
      case 'lunch':
        icon = Icons.lunch_dining;
        break;
      default:
        icon = Icons.dinner_dining;
    }

    return Expanded(
      child: StatefulBuilder(
        builder: (context, setLocalState) {
          bool isGlowing = false;
          double scale = 1.0;

          return GestureDetector(
            onTapDown: (_) => setLocalState(() { isGlowing = true; scale = 0.97; }),
            onTapUp: (_) {
              Future.delayed(Duration(milliseconds: 150), () {
                setLocalState(() { isGlowing = false; scale = 1.0; });
              });
            },
            onTapCancel: () => setLocalState(() { isGlowing = false; scale = 1.0; }),
            child: AnimatedScale(
              scale: scale,
              duration: Duration(milliseconds: 150),
              curve: Curves.easeOut,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isGlowing
                      // ignore: dead_code
                      ? [BoxShadow(color: Colors.amberAccent.withOpacity(0.5), blurRadius: 15, spreadRadius: 2, offset: Offset(0, 6))]
                      : [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
                ),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: Colors.black54),
                        SizedBox(width: 8),
                        Text(
                          title,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(meal, style: TextStyle(fontSize: 39, color: Colors.black)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) return SizedBox();
    final currentMeal = meals[selectedDay];

    return Scaffold(

// ✅ Replace your current AppBar code in MealPlannerScreen with this:

appBar: AppBar(
  leading: IconButton(
    icon: Icon(Icons.settings, color: Colors.white),
    onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SettingsScreen()),
    ),
  ),
  title: Text(
    'Weekly Meal Planner',
    style: TextStyle(color: Colors.white),
  ),
  centerTitle: true,
  backgroundColor: const Color.fromARGB(255, 61, 61, 63),
  elevation: 2,
  actions: [
    IconButton(
      icon: Icon(Icons.close, color: Colors.white),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit App'),
              content: Text('Are you sure you want to close the app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Uncomment the one you want:
                    SystemNavigator.pop();
                    // exit(0); // Requires import 'dart:io';
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    ),
  ],
),


      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(days.length, (index) {
                final isSelected = index == selectedDay;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: ElevatedButton(
                      onPressed: () => setState(() => selectedDay = index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.black : Colors.grey[300],
                        foregroundColor: isSelected ? Colors.white : Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: Text(days[index], style: TextStyle(fontSize: 12)),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                buildMealCard('Breakfast', currentMeal['breakfast'] ?? 'N/A', pastelColors[0]),
                buildMealCard('Lunch', currentMeal['lunch'] ?? 'N/A', pastelColors[1]),
                buildMealCard('Dinner', currentMeal['dinner'] ?? 'N/A', pastelColors[2]),
              ],
            ),
          ),
          Padding(
  padding: EdgeInsets.only(
    left: 16,
    right: 16,
    bottom: MediaQuery.of(context).padding.bottom + 16,
    top: 16,
  ),
  child: SizedBox(

              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await generateRandomMeals();

                          // ✅ Show Toast after generating meals
        Fluttertoast.showToast(
          msg: "New meals generated!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Generate', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// NOTE: SettingsScreen class unchanged, assumed present below


/// Updated Settings screen with TabBar
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = ['Breakfast', 'Lunch', 'Dinner'];
  static const int maxItems = 15;

  final Map<String, List<TextEditingController>> mealControllers = {
    'Breakfast': List.generate(maxItems, (_) => TextEditingController()),
    'Lunch': List.generate(maxItems, (_) => TextEditingController()),
    'Dinner': List.generate(maxItems, (_) => TextEditingController()),
  };

  final Map<String, List<String>> savedMeals = {
    'Breakfast': List.filled(maxItems, ''),
    'Lunch': List.filled(maxItems, ''),
    'Dinner': List.filled(maxItems, ''),
  };

  final List<Color> vibrantPastels = [
    Color(0xFFf3d4f3),
    Color(0xFFB3E5FC),
    Color(0xFFB2DFDB),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    loadSavedMeals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    mealControllers.values.forEach((list) => list.forEach((c) => c.dispose()));
    super.dispose();
  }

  Future<void> loadSavedMeals() async {
    final prefs = await SharedPreferences.getInstance();
    for (final category in categories) {
      final data = prefs.getString(category);
      if (data != null) {
        final List<String> meals = List<String>.from(jsonDecode(data));
        for (var i = 0; i < meals.length && i < mealControllers[category]!.length; i++) {
          mealControllers[category]![i].text = meals[i];
        }
        savedMeals[category] = meals;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        
        // Inside the AppBar widget in SettingsScreen
// Inside the AppBar widget in SettingsScreen
appBar: AppBar(
  title: Text('Settings', style: TextStyle(color: Colors.white)),
  centerTitle: true,
  backgroundColor: const Color.fromARGB(255, 61, 61, 63),
  
  
  bottom: PreferredSize(
  preferredSize: Size.fromHeight(72),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
    child: SizedBox(
      width: double.infinity,
      height: 56,
      child: CupertinoSegmentedControl<int>(
        children: {
          for (int i = 0; i < categories.length; i++)
            i: Container(
              alignment: Alignment.center,
              height: 50,
              child: Text(
                categories[i],
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
        },
        groupValue: _tabController.index,
        onValueChanged: (int newIndex) {
          setState(() {
            _tabController.index = newIndex;
          });
        },
        borderColor: Colors.black,
        selectedColor: vibrantPastels[_tabController.index],
        unselectedColor: Colors.white,
        pressedColor: Colors.grey.shade200,
      ),
    ),
  ),
),



),



        body: TabBarView(
          controller: _tabController,
          children: List.generate(categories.length, (index) {
            final currentCategory = categories[index];
            final currentControllers = mealControllers[currentCategory]!;
            return Container(
              color: vibrantPastels[index],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter your ${currentCategory.toLowerCase()} meals below:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: maxItems,
                      itemBuilder: (context, itemIndex) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            children: [
                              Icon(
                                currentCategory == 'Breakfast'
                                    ? Icons.free_breakfast
                                    : currentCategory == 'Lunch'
                                        ? Icons.lunch_dining
                                        : Icons.dinner_dining,
                                size: 20,
                                color: Colors.black54,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: currentControllers[itemIndex],
                                  decoration: InputDecoration(
                                    hintText: 'Menu',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  
                  
                  // Full-width Save button

Padding(
  padding: EdgeInsets.only(
    left: 16,
    right: 16,
    bottom: MediaQuery.of(context).padding.bottom + 16,
    top: 16,
  ),

  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        final updatedMeals = currentControllers.map((c) => c.text.trim()).toList();
        setState(() => savedMeals[currentCategory] = updatedMeals);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(currentCategory, jsonEncode(updatedMeals));

        // ✅ Show toast instead of snackbar
        Fluttertoast.showToast(
          msg: "Saved $currentCategory meals!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text('Save', style: TextStyle(fontSize: 16)),
    ),
  ),
)



                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

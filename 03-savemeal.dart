// Main imports
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
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

  final List<Map<String, String>> meals = [
    {
      'breakfast': 'Oatmeal & banana',
      'lunch': 'Grilled chicken salad',
      'dinner': 'Salmon with quinoa',
    },
    {
      'breakfast': 'Scrambled eggs & toast',
      'lunch': 'Beef stir-fry with rice',
      'dinner': 'Pasta with veggie sauce',
    },
    {
      'breakfast': 'Smoothie bowl',
      'lunch': 'Tuna sandwich & chips',
      'dinner': 'Chicken curry with rice',
    },
    {
      'breakfast': 'Pancakes & berries',
      'lunch': 'Baked salmon & veggies',
      'dinner': 'Veggie stir-fry noodles',
    },
    {
      'breakfast': 'Yogurt & granola',
      'lunch': 'Chicken wrap',
      'dinner': 'Grilled steak & potatoes',
    },
    {
      'breakfast': 'Avocado toast',
      'lunch': 'Shrimp fried rice',
      'dinner': 'Ramen with boiled egg',
    },
    {
      'breakfast': 'French toast',
      'lunch': 'BBQ chicken',
      'dinner': 'Baked lasagna',
    },
  ];

  final List<Color> pastelColors = [
    Color(0xFFFFE0B2), // Peach
    Color(0xFFB3E5FC), // Sky Blue
    Color(0xFFB2DFDB), // Mint Green
  ];

  /// Builds a tappable animated meal card
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
            onTapDown: (_) {
              setLocalState(() {
                isGlowing = true;
                scale = 0.97;
              });
            },
            onTapUp: (_) {
              Future.delayed(Duration(milliseconds: 150), () {
                setLocalState(() {
                  isGlowing = false;
                  scale = 1.0;
                });
              });
            },
            onTapCancel: () {
              setLocalState(() {
                isGlowing = false;
                scale = 1.0;
              });
            },
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
                      ? [
                          BoxShadow(
                            color: Colors.amberAccent.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: Offset(0, 6),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5,
                          ),
                        ],
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      meal,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
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
    final currentMeal = meals[selectedDay];

    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Meal Planner', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo[700],
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top day selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(days.length, (index) {
                bool isSelected = index == selectedDay;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedDay = index;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? Colors.indigo : Colors.grey[300],
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(days[index], style: TextStyle(fontSize: 12)),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Meal cards
          Expanded(
            child: Column(
              children: [
                buildMealCard('Breakfast', currentMeal['breakfast'] ?? 'N/A', pastelColors[0]),
                buildMealCard('Lunch', currentMeal['lunch'] ?? 'N/A', pastelColors[1]),
                buildMealCard('Dinner', currentMeal['dinner'] ?? 'N/A', pastelColors[2]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Settings screen to edit meal plans
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int selectedCategory = 0;
  final List<String> categories = ['Breakfast', 'Lunch', 'Dinner'];

  // Controllers for meal input fields
  Map<String, List<TextEditingController>> mealControllers = {
    'Breakfast': List.generate(15, (_) => TextEditingController()),
    'Lunch': List.generate(15, (_) => TextEditingController()),
    'Dinner': List.generate(15, (_) => TextEditingController()),
  };

  // Store saved meals
  Map<String, List<String>> savedMeals = {
    'Breakfast': List.filled(15, ''),
    'Lunch': List.filled(15, ''),
    'Dinner': List.filled(15, ''),
  };

  final List<Color> vibrantPastels = [
    Color(0xFFFFE0B2),
    Color(0xFFB3E5FC),
    Color(0xFFB2DFDB),
  ];

  @override
  void initState() {
    super.initState();
    loadSavedMeals();
  }

  @override
  void dispose() {
    mealControllers.forEach((_, list) => list.forEach((c) => c.dispose()));
    super.dispose();
  }

  // Load previously saved meals
  void loadSavedMeals() async {
    final prefs = await SharedPreferences.getInstance();

    for (String category in categories) {
      String? data = prefs.getString(category);
      if (data != null) {
        List<String> meals = List<String>.from(jsonDecode(data));
        for (int i = 0; i < meals.length; i++) {
          if (i < mealControllers[category]!.length) {
            mealControllers[category]![i].text = meals[i];
          }
        }
        savedMeals[category] = meals;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String currentCategory = categories[selectedCategory];
    List<TextEditingController> currentControllers = mealControllers[currentCategory]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo[700],
      ),
      body: Column(
        children: [
          // Category selection buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: List.generate(categories.length, (index) {
                bool isSelected = index == selectedCategory;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => selectedCategory = index);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.indigo : Colors.grey[300],
                        foregroundColor: isSelected ? Colors.white : Colors.black,
                      ),
                      child: Text(categories[index]),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Meal input list
          Expanded(
            child: Container(
              color: vibrantPastels[selectedCategory],
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your ${currentCategory.toLowerCase()} meals below:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentControllers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            children: [
                              Icon(
                                selectedCategory == 0
                                    ? Icons.free_breakfast
                                    : selectedCategory == 1
                                        ? Icons.lunch_dining
                                        : Icons.dinner_dining,
                                size: 20,
                                color: Colors.black54,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: currentControllers[index],
                                  decoration: InputDecoration(
                                    hintText: 'Menu',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
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

                  // Save button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        List<String> updatedMeals = currentControllers
                            .map((controller) => controller.text.trim())
                            .toList();

                        setState(() {
                          savedMeals[currentCategory] = updatedMeals;
                        });

                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString(currentCategory, jsonEncode(updatedMeals));

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Saved $currentCategory meals!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text('Save', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

  final List<Map<String, String>> meals = [
    { 'breakfast': 'Oatmeal & banana', 'lunch': 'Grilled chicken salad', 'dinner': 'Salmon with quinoa' },
    { 'breakfast': 'Scrambled eggs & toast', 'lunch': 'Beef stir-fry with rice', 'dinner': 'Pasta with veggie sauce' },
    { 'breakfast': 'Smoothie bowl', 'lunch': 'Tuna sandwich & chips', 'dinner': 'Chicken curry with rice' },
    { 'breakfast': 'Pancakes & berries', 'lunch': 'Baked salmon & veggies', 'dinner': 'Veggie stir-fry noodles' },
    { 'breakfast': 'Yogurt & granola', 'lunch': 'Chicken wrap', 'dinner': 'Grilled steak & potatoes' },
    { 'breakfast': 'Avocado toast', 'lunch': 'Shrimp fried rice', 'dinner': 'Ramen with boiled egg' },
    { 'breakfast': 'French toast', 'lunch': 'BBQ chicken', 'dinner': 'Baked lasagna' },
  ];

  final List<Color> pastelColors = [
    Color(0xFFFEADB9), // Peach
    Color(0xFFB3E5FC), // Sky Blue
    Color(0xFFB2DFDB), // Mint Green
  ];

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
                    Text(meal, style: TextStyle(fontSize: 15, color: Colors.black)),
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
        backgroundColor: const Color.fromARGB(255, 61, 61, 63),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
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
          
          // Full-width Generate button
Padding(
  padding: EdgeInsets.all(16.0),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        // TODO: implement generate meal plan
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
    Color(0xFFFEADB9),
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
    preferredSize: Size.fromHeight(48),
    child: AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          color: const Color.fromARGB(255, 255, 255, 255), // Whole tab bar background remains white
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black26),
                bottom: BorderSide(color: Colors.black26),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2,
              tabs: List.generate(categories.length, (index) {
                final isSelected = _tabController.index == index;
                return Container(
                  decoration: BoxDecoration(
                    color: isSelected ? vibrantPastels[index] : Colors.white,
                    border: Border(
                      right: index != categories.length - 1
                          ? BorderSide(color: Colors.black26)
                          : BorderSide.none,
                      bottom: isSelected
                          ? BorderSide(color: vibrantPastels[index])
                          : BorderSide(color: Colors.black26),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
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
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        final updatedMeals = currentControllers.map((c) => c.text.trim()).toList();
        setState(() => savedMeals[currentCategory] = updatedMeals);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(currentCategory, jsonEncode(updatedMeals));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved $currentCategory meals!')),
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

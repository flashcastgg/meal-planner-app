import 'package:flutter/material.dart';

void main() {
  runApp(MealPlannerApp());
}

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
    Color(0xFFFFF4E6), // Breakfast: light peach
    Color(0xFFE6F7FF), // Lunch: light blue
    Color(0xFFE6FFE6), // Dinner: light green
  ];

  Widget buildMealCard(String title, String meal, Color backgroundColor) {
    IconData icon;
    if (title.toLowerCase() == 'breakfast') {
      icon = Icons.free_breakfast;
    } else if (title.toLowerCase() == 'lunch') {
      icon = Icons.lunch_dining;
    } else {
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
                          )
                        ]
                      : [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5,
                          )
                        ],
                ),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
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
          Expanded(
            child: Column(
              children: [
                buildMealCard('Breakfast', currentMeal['breakfast'] ?? 'N/A',
                    pastelColors[0]),
                buildMealCard('Lunch', currentMeal['lunch'] ?? 'N/A',
                    pastelColors[1]),
                buildMealCard('Dinner', currentMeal['dinner'] ?? 'N/A',
                    pastelColors[2]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

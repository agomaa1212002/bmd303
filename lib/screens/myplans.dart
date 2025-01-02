import 'package:flutter/material.dart';

class MyAppplan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(


        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PlanCard(
                dietCode: "DIET1600",
                meals: [
                  "Scrambled eggs with spinach and whole grain toast (350 calories)",
                  "Greek yogurt with mixed berries and a sprinkle of granola (200 calories)",
                  "Grilled chicken salad with mixed greens, cherry tomatoes, cucumbers, and balsamic vinaigrette (450 calories)",
                  "Apple slices with almond butter (150 calories)",
                  "Baked salmon with quinoa and steamed asparagus (450 calories)"
                ],
                totalCalories: 1600,
                color: Colors.teal,
              ),
              PlanCard(
                dietCode: "DIET1800",
                meals: [
                  "Oatmeal with sliced banana and a drizzle of honey (300 calories)",
                  "Handful of almonds and a piece of fruit (250 calories)",
                  "Turkey and avocado wrap with whole wheat tortilla (500 calories)",
                  "Carrot sticks with hummus (100 calories)",
                  "Stir-fried tofu with mixed vegetables and brown rice (650 calories)"
                ],
                totalCalories: 1800,
                color: Colors.teal,
              ),
              PlanCard(
                dietCode: "DIET2000",
                meals: [
                  "Greek yogurt with mixed berries and a sprinkle of chia seeds (300 calories)",
                  "Protein shake with almond milk and banana (250 calories)",
                  "Quinoa salad with chickpeas, cherry tomatoes, feta cheese, and lemon vinaigrette (500 calories)",
                  "Rice cakes with peanut butter (200 calories)",
                  "Grilled steak with sweet potato wedges and roasted Brussels sprouts (750 calories)"],
                totalCalories: 2000,
                color: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanCard extends StatefulWidget {
  final String dietCode;
  final List<String> meals;
  final int totalCalories;
  final Color color;

  PlanCard({
    required this.dietCode,
    required this.meals,
    required this.totalCalories,
    required this.color,
  });

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  bool isExpanded = false;
  List<TextEditingController> mealControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each meal
    for (int i = 0; i < widget.meals.length; i++) {
      mealControllers.add(TextEditingController(text: widget.meals[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              'Diet Plan: ${widget.dietCode}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded) ...[
            ListTile(
              title: Text(
                'Total Calories: ${widget.totalCalories}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Divider(color: Colors.white),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meals:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(widget.meals.length, (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Meal ${index + 1}:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            controller: mealControllers[index],
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            onChanged: (newValue) {
                              widget.meals[index] = newValue;
                            },
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save button functionality here
                  // You can implement the logic to save changes to a database or local storage
                  // For demonstration purposes, we print the updated meals list
                  for (int i = 0; i < widget.meals.length; i++) {
                    print('Meal ${i + 1}: ${widget.meals[i]}');
                  }
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    textStyle: TextStyle(
                        fontSize: 15,
                        )
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
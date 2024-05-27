

import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/add_task_bar.dart';
import '../widgets/botton.dart';
import 'theme.dart';

class FoodCalorieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: FoodCalorieScreen(),
    );
  }
}



class FoodCalorieScreen extends StatefulWidget {
  @override
  _FoodCalorieScreenState createState() => _FoodCalorieScreenState();
}


class _MealData {
  TextEditingController controller = TextEditingController();
  List<String> caloriesList = []; // Store calories as a list of strings
  bool isExpanded = false;
  int additionalFieldsCount = 0; // Track the number of additional fields
  List<String> foodNames = []; // Store food names for main meal and additional items
  List<TextEditingController> additionalControllers = []; // Store controllers for additional fields
}

class _FoodCalorieScreenState extends State<FoodCalorieScreen> {
  Map<String, _MealData?> mealDataMap = {
    'Breakfast': _MealData(),
    'Lunch': _MealData(),
    'Dinner': _MealData(),
    'Snacks': _MealData(),
  };



  void fetchData(String apiKey, String foodQuery, String mealCategory) async {
    String apiUrl =
        'https://api.nal.usda.gov/fdc/v1/foods/search?api_key=$apiKey&query=$foodQuery&pageSize=1';

    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['foods'] != null && data['foods'].length > 0) {
        var foodItem = data['foods'][0];
        var energy = foodItem['foodNutrients']
            .firstWhere((nutrient) => nutrient['nutrientName'] == 'Energy')['value'];
        setState(() {
          mealDataMap[mealCategory]?.foodNames.add(foodItem['description']);
          mealDataMap[mealCategory]?.caloriesList.add('Energy: $energy kcal'); // Append to caloriesList
        });
      } else {
        setState(() {
          mealDataMap[mealCategory]?.caloriesList.add('Food not found'); // Append error message
        });
      }
    } else {
      setState(() {
        mealDataMap[mealCategory]?.caloriesList.add('Error fetching data'); // Append error message
      });
    }
  }

  _MealData? getMealData(String mealCategory) {
    return mealDataMap[mealCategory];
  }

  Widget buildMealContainer(String mealCategory) {
    _MealData? mealData = getMealData(mealCategory);
    if (mealData == null) return SizedBox(); // Return an empty widget if mealData is null

    List<Widget> fields = [];

    // Add text field and button for the main field
    fields.add(
      Column(
        children: [
          TextField(
            controller: mealData.controller,
            decoration: InputDecoration(labelText: 'Enter food item'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
              child: Text('Get Calories'),
            onPressed: () {
              String foodQuery = mealData.controller.text.trim();
              fetchData('DEMO_KEY', foodQuery, mealCategory);
            },
            style: ElevatedButton.styleFrom(

              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold// Set the background color here
            )),

          ),
          // Mybutton( label:"Get Calories" , onTap:(){
          //   String foodQuery = mealData.controller.text.trim();
          //        fetchData('DEMO_KEY', foodQuery, mealCategory);
          //
          // }),
          SizedBox(height: 16.0),
          for (int i = 0; i < mealData.foodNames.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Food Name ${i + 1}: ${mealData.foodNames[i]}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  mealData.caloriesList[i],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
              ],
            ),
          SizedBox(height: 16.0),
        ],
      ),
    );

    // Add additional fields and buttons for each additional field
    for (int i = 0; i < mealData.additionalFieldsCount; i++) {
      TextEditingController additionalController;
      if (i < mealData.additionalControllers.length) {
        additionalController = mealData.additionalControllers[i];
      } else {
        additionalController = TextEditingController();
        mealData.additionalControllers.add(additionalController);
      }
      fields.addAll([
        TextField(
          controller: additionalController,
          decoration: InputDecoration(labelText: 'Enter additional food item ${i + 1}'),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          child: Text('Get Calories for Additional Item ${i + 1}'),
          onPressed: () {
            String additionalFoodQuery = additionalController.text.trim();
            fetchData('DEMO_KEY', additionalFoodQuery, mealCategory);
          },
          style: ElevatedButton.styleFrom(

              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold// Set the background color here
              )),
        ),
        // Mybutton( label:'Get Calories for Additional Item ', onTap:(){
        //   String additionalFoodQuery = additionalController.text.trim();
        //        fetchData('DEMO_KEY', additionalFoodQuery, mealCategory);
        // }
        // ),
        SizedBox(height: 16.0),
        for (int j = 0; j < mealData.foodNames.length; j++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Additional Food Name ${j + 1}: ${mealData.foodNames[j]}',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                mealData.caloriesList[j],
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
            ],
          ),
        SizedBox(height: 16.0),
      ]);
    }

    fields.add(
      ElevatedButton(
        child: Text('Add More Fields'),
        onPressed: () {
          setState(() {
            mealData.additionalFieldsCount++; // Increment the count
          });
        },
        style: ElevatedButton.styleFrom(

            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold// Set the background color here
            )),
      ),
      // Mybutton( label:'Add More Fields', onTap:(){
      //   setState(() {
      //          mealData.additionalFieldsCount++; // Increment the count
      //        });
      // }
      // ),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: fields,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var mealCategory in mealDataMap.keys)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                mealCategory,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_drop_down),
                                onPressed: () {
                                  setState(() {
                                    mealDataMap[mealCategory]?.isExpanded =
                                    !(mealDataMap[mealCategory]?.isExpanded ?? false);
                                  });
                                },
                              ),
                            ],
                          ),
                          if (mealDataMap[mealCategory]?.isExpanded ?? false)
                            buildMealContainer(mealCategory),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Generate UI for each meal category
                for (var mealCategory in mealDataMap.keys) {
                  setState(() {
                    mealDataMap[mealCategory]?.isExpanded = true;
                  });
                  fetchData('DEMO_KEY', '', mealCategory); // Using the demo key
                }
              },
              child: Text('Generate All Calories'),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    textStyle: TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold)
            ),
            )],
        ),
      ),
    );
  }
}

















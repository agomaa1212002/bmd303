import 'package:flutter/material.dart';



class CustomRectangularContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle icon tap action here (e.g., open photo picker)
        print('Icon tapped!');
      },
      child: Column(
        children: [

          Container(

            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
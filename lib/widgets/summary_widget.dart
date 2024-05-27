
import 'package:flutter/material.dart';
import 'package:neutrition_sqlite/widgets/pie_chart_widget.dart';
import 'package:neutrition_sqlite/widgets/scheduled_widget.dart';
import 'package:neutrition_sqlite/widgets/summary_details.dart';

import '../const/constant.dart';
import 'insert_photo_widget.dart';

class SummaryWidget extends StatelessWidget {
   SummaryWidget({super.key});
  final insertAmege = CustomRectangularContainer ();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: cardBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomRectangularContainer(),
            Text(
              'Insert',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),

            ),
            SizedBox(height: 16),


            SizedBox(height: 40),
            Scheduled(),
          ],
        ),
      ),
    );
  }
}

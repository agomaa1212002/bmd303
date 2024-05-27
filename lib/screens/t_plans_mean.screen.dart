
import 'package:flutter/material.dart';

import '../util/responsive.dart';
import '../widgets/dashboard_widget.dart';
import '../widgets/side_menu_widget.dart';
import '../widgets/summary_widget.dart';
import 'Treatment_Plan_Page.dart';
import 'myplans.dart';

class TreatmentPlan extends StatelessWidget {
  const TreatmentPlan({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(


      endDrawer: Responsive.isMobile(context)
          ? SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        // child: const SummaryWidget(),
      )
          : null,
      body: SafeArea(
        child: Row(
          children: [

              Expanded(
                flex: 2,
                child: SizedBox(
                  child: SideMenuWidget(),
                ),
              ),
            Expanded(
              flex: 7,
              child: FoodCalorieApp(),
            ),

              Expanded(
                flex: 3,
                child: MyAppplan (),
              ),
          ],
        ),
      ),
    );
  }
}

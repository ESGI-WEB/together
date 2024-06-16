import 'package:flutter/material.dart';
import 'package:front/admin/dashboard/partials/event_types_count/event_types_count_chart.dart';
import 'package:front/admin/dashboard/partials/last_groups_list/last_groups_list.dart';
import 'package:front/admin/dashboard/partials/monthly_last_year_registration/monthly_last_year_registration_chart.dart';
import 'package:front/admin/dashboard/partials/monthly_messages_count/monthly_messages_chart.dart';
import 'package:front/admin/dashboard/partials/next_events_list/next_events_list.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const String routeName = 'admin';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double parentWidth = constraints.maxWidth;
            return Column(
              children: [
                Wrap(
                  children: [
                    Container(
                      // mandatory because charts are infinite in width
                      width: parentWidth / 3 * 2,
                      constraints: const BoxConstraints(
                        minWidth: 500,
                      ),
                      child: const Card(
                          child: Padding(
                        padding: EdgeInsets.all(16),
                        child: MonthlyLastYearRegistrationChart(),
                      )),
                    ),
                    Container(
                      // mandatory because charts are infinite in width
                      width: parentWidth / 3,
                      constraints: const BoxConstraints(
                        minWidth: 500,
                      ),
                      child: const Card(
                          child: Padding(
                        padding: EdgeInsets.all(16),
                        child: EventTypesCountChart(),
                      )),
                    ),
                    Container(
                      // mandatory because charts are infinite in width
                      width: parentWidth / 4,
                      constraints: const BoxConstraints(
                        minWidth: 300,
                      ),
                      child: const Card(
                          child: Padding(
                        padding: EdgeInsets.all(16),
                        child: NextEventsList(),
                      )),
                    ),
                    Container(
                      // mandatory because charts are infinite in width
                      width: parentWidth / 4 * 2,
                      constraints: const BoxConstraints(
                        minWidth: 400,
                      ),
                      child: const Card(
                          child: Padding(
                        padding: EdgeInsets.all(16),
                        child: MonthlyMessagesChart(),
                      )),
                    ),
                    Container(
                      // mandatory because charts are infinite in width
                      width: parentWidth / 4,
                      constraints: const BoxConstraints(
                        minWidth: 300,
                      ),
                      child: const Card(
                          child: Padding(
                        padding: EdgeInsets.all(16),
                        child: LastGroupsList(),
                      )),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

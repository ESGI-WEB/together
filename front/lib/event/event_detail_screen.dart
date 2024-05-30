import 'package:flutter/material.dart';
import 'package:front/core/partials/app_layout.dart';

import '../go_router/go_router.dart';

class EventDetailScreen extends StatelessWidget {
  static const String routeName = '/event';

  static void navigateTo(BuildContext context, {required int id}) {
    goRouter.goNamed('$routeName/$id');
  }

  final int id;

  const EventDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      title: 'Évènement',
      body: Text("évènement"),
    );
  }
}

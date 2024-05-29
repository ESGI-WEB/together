import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/partials/group_layout.dart';

import 'blocs/chat_bloc.dart';
import 'chat_list.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/group/chat';

  static Future<void> navigateTo(
    BuildContext context, {
    required int groupId,
    bool removeHistory = false,
  }) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => !removeHistory,
      arguments: groupId,
    );
  }

  final int groupId;

  const ChatScreen({super.key, required this.groupId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: GroupLayout(
        title: 'Chat du groupe ${widget.groupId}',
        body: ChatList(groupId: widget.groupId.toString()),
      ),
    );
  }
}

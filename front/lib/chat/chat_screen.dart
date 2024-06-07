import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'blocs/chat_bloc.dart';
import 'chat_list.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = 'messaging';
  final int groupId;

  const ChatScreen({super.key, required this.groupId});

  static void navigateTo(BuildContext context, {required int id}) {
    context.goNamed(routeName, pathParameters: {'id': id.toString()});
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ChatBloc(),
        child: ChatList(groupId: widget.groupId));
  }
}

part of 'monthly_messages_bloc.dart';

@immutable
sealed class MonthlyMessagesEvent {}

class MonthlyMessagesLoaded extends MonthlyMessagesEvent {}
part of 'publications_bloc.dart';

@immutable
sealed class PublicationsEvent {}

class PublicationsLoaded extends PublicationsEvent {
  final int groupId;

  PublicationsLoaded(this.groupId);
}

class PublicationsLoadMore extends PublicationsEvent {
  final int groupId;

  PublicationsLoadMore(this.groupId);
}

class PublicationAdded extends PublicationsEvent {
  final Message publication;

  PublicationAdded(this.publication);
}
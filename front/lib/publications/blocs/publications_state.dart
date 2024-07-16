part of 'publications_bloc.dart';

enum PublicationsStatus {
  initial,
  loading,
  loadingMore,
  success,
  error,
}

class PublicationsState {
  final PublicationsStatus status;
  final List<Message>? publications;
  final String? errorMessage;
  final int page;
  final int limit;
  final int? total;
  final int? pages;
  final bool hasReachedMax;

  PublicationsState({
    this.status = PublicationsStatus.initial,
    this.publications,
    this.errorMessage,
    this.page = 1,
    this.limit = 5,
    this.total,
    this.pages,
    this.hasReachedMax = false,
  });

  PublicationsState copyWith({
    PublicationsStatus? status,
    List<Message>? publications,
    String? errorMessage,
    int? page,
    int? limit,
    int? total,
    int? pages,
    bool? hasReachedMax,
  }) {
    return PublicationsState(
      status: status ?? this.status,
      publications: publications ?? this.publications,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      pages: pages ?? this.pages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
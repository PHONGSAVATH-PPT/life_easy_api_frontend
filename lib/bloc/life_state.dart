import '../domain/models.dart';

class LifeState {
  LifeState({
    LifeSnapshot? data,
    this.loading = false,
    this.saving = false,
    this.error,
    this.language = 'lo',
    this.currency = 'LAK',
  }) : data = data ?? LifeSnapshot(entries: [], members: []);

  final LifeSnapshot data;
  final bool loading;
  final bool saving;
  final String? error;
  final String language;
  final String currency;

  LifeState copyWith({
    LifeSnapshot? data,
    bool? loading,
    bool? saving,
    String? error,
    String? language,
    String? currency,
  }) {
    return LifeState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      error: error,
      language: language ?? this.language,
      currency: currency ?? this.currency,
    );
  }
}

import '../domain/models.dart';

sealed class LifeEvent {}

class LifeLoaded extends LifeEvent {}

class EntrySaved extends LifeEvent {
  EntrySaved(this.entry);

  final LifeEntry entry;
}

class EntryRemoved extends LifeEvent {
  EntryRemoved(this.id);

  final String id;
}

class TaskToggled extends LifeEvent {
  TaskToggled(this.id);

  final String id;
}

class BillPaid extends LifeEvent {
  BillPaid(this.id);

  final String id;
}

class LanguageChanged extends LifeEvent {
  LanguageChanged(this.language);

  final String language;
}

class CurrencyChanged extends LifeEvent {
  CurrencyChanged(this.currency);

  final String currency;
}

enum EntryKind { task, appointment, income, expense, bill, document }

class LifeEntry {
  const LifeEntry({
    required this.id,
    required this.kind,
    required this.title,
    required this.due,
    this.amount = 0,
    this.currency = 'LAK',
    this.done = false,
    this.shared = false,
    this.note = '',
    this.assignee,
    this.recurrence = 'none',
    this.reminder = false,
    this.sourceBillId,
  });

  final String id;
  final EntryKind kind;
  final String title;
  final DateTime due;

  // ເກັບເງີນຈຳນວນເຕັມເປັນສະຫຼາດເງີນ ຕາມເງີນ LAK ແລະ THB:
  // LAK: 250000 = 250,000 กีบ
  // THB: 9950 = 99.50 บาท

  final int amount;
  final String currency;
  final bool done;
  final bool shared;
  final String note;
  final String? assignee;
  final String recurrence;
  final bool reminder;
  final String? sourceBillId;

  // ກຳນົດວ່າເປັນ task ຫຼືບໍ່
  bool get isMoney =>
      kind == EntryKind.income ||
      kind == EntryKind.expense ||
      kind == EntryKind.bill;

  // ກຳນົດວ່າເປັນ task ຫຼືບໍ່
  bool get isTask => kind == EntryKind.task || kind == EntryKind.appointment;

  LifeEntry copyWith({bool? done, bool? shared}) {
    return LifeEntry(
      id: id,
      kind: kind,
      title: title,
      due: due,
      amount: amount,
      currency: currency,
      done: done ?? this.done,
      shared: shared ?? this.shared,
      note: note,
      assignee: assignee,
      recurrence: recurrence,
      reminder: reminder,
      sourceBillId: sourceBillId,
    );
  }

  // Method to convert a LifeEntry to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kind': kind.name,
      'title': title,
      'due': due.toUtc().toIso8601String(),
      'amount': amount,
      'currency': currency,
      'done': done,
      'shared': shared,
      'note': note,
      'assignee': assignee,
      'recurrence': recurrence,
      'reminder': reminder,
      'source_bill_id': sourceBillId,
    };
  }

  // Factory method to create a LifeEntry from JSON
  factory LifeEntry.fromJson(Map<String, dynamic> json) {
    return LifeEntry(
      id: json['id'] as String,
      kind: EntryKind.values.byName(json['kind'] as String),
      title: json['title'] as String,
      due: DateTime.parse(json['due_at'] as String).toLocal(),
      amount: (json['amount_minor'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'LAK',
      done: json['done'] as bool? ?? false,
      shared: json['shared'] as bool? ?? false,
      note: json['note'] as String? ?? '',
      assignee: json['assignee_id'] as String?,
      recurrence: json['recurrence'] as String? ?? 'none',
      reminder: json['reminder_enabled'] as bool? ?? false,
      sourceBillId: json['source_bill_id'] as String?,
    );
  }
}

// Class to represent a member
class Member {
  const Member(this.id, this.name, this.role, {this.email = ''});

  final String id;
  final String name;
  final String role;
  final String email;

  // Factory method to create a Member from JSON
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      json['id'] as String,
      json['name'] as String,
      json['role'] as String? ?? 'member',
      email: json['email'] as String? ?? '',
    );
  }
}

// Class to represent a snapshot of life entries and members
class LifeSnapshot {
  LifeSnapshot({
    required List<LifeEntry> entries,
    required List<Member> members,
  }) : entries = List.unmodifiable(entries),
       members = List.unmodifiable(members);

  final List<LifeEntry> entries;
  final List<Member> members;
}

// Function to check if two DateTime objects are on the same day
bool sameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String money(int minor, String currency) {
  final raw = currency == 'THB'
      ? (minor / 100).toStringAsFixed(2)
      : minor.toString();

  final parts = raw.split('.');

  final grouped = parts.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );

  final decimal = parts.length > 1 ? '.${parts[1]}' : '';
  final symbol = currency == 'LAK' ? '₭' : '฿';

  return '$grouped$decimal $symbol';
}

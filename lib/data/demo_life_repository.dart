import '../domain/life_repository.dart';
import '../domain/models.dart';

class DemoLifeRepository implements LifeRepository {
  DemoLifeRepository({
    bool seedData = false,
    this.delay = const Duration(milliseconds: 250),
  }) {
    if (!seedData) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _members = const [
      Member('m1', 'คุณ', 'owner'),
      Member('m2', 'น้อย', 'member'),
      Member('m3', 'แม่', 'member'),
    ];

    _entries = [
      LifeEntry(
        id: 'task-1',
        kind: EntryKind.task,
        title: 'ซื้อของเข้าบ้าน',
        due: today.add(const Duration(hours: 18)),
        shared: true,
        assignee: 'm2',
        reminder: true,
        note: 'นม ไข่ และผักสด',
      ),
      LifeEntry(
        id: 'task-2',
        kind: EntryKind.appointment,
        title: 'นัดคุยงานกับทีม',
        due: today.add(const Duration(hours: 14)),
        reminder: true,
      ),
      LifeEntry(
        id: 'task-3',
        kind: EntryKind.task,
        title: 'อ่านหนังสือ 20 นาที',
        due: today.add(const Duration(hours: 8)),
        done: true,
      ),
      LifeEntry(
        id: 'bill-1',
        kind: EntryKind.bill,
        title: 'ค่าอินเทอร์เน็ตบ้าน',
        due: today.add(const Duration(days: 1)),
        amount: 250000,
        recurrence: 'monthly',
        reminder: true,
      ),
      LifeEntry(
        id: 'bill-2',
        kind: EntryKind.bill,
        title: 'ค่าไฟฟ้า',
        due: today.add(const Duration(days: 4)),
        amount: 180000,
        shared: true,
      ),
      LifeEntry(
        id: 'income-1',
        kind: EntryKind.income,
        title: 'เงินเดือน',
        due: today,
        amount: 6500000,
      ),
      LifeEntry(
        id: 'expense-1',
        kind: EntryKind.expense,
        title: 'อาหารและเครื่องดื่ม',
        due: today,
        amount: 65000,
      ),
      LifeEntry(
        id: 'expense-2',
        kind: EntryKind.expense,
        title: 'ค่าสมาชิก',
        due: today,
        amount: 9900,
        currency: 'THB',
      ),
      LifeEntry(
        id: 'document-1',
        kind: EntryKind.document,
        title: 'ใบขับขี่',
        due: today.add(const Duration(days: 18)),
        reminder: true,
        note: 'ข้อมูลตัวอย่าง ยังไม่มีไฟล์แนบ',
      ),
      LifeEntry(
        id: 'document-2',
        kind: EntryKind.document,
        title: 'ประกันรถยนต์',
        due: today.add(const Duration(days: 75)),
      ),
    ];
  }

  final Duration delay;

  List<LifeEntry> _entries = [];

  List<Member> _members = const [Member('m1', 'คุณ', 'owner')];

  Future<LifeSnapshot> _snapshot() async {
    await Future<void>.delayed(delay);

    return LifeSnapshot(entries: _entries, members: _members);
  }

  @override
  Future<LifeSnapshot> load() => _snapshot();

  @override
  Future<LifeSnapshot> save(LifeEntry entry) {
    _entries = [..._entries.where((item) => item.id != entry.id), entry];

    return _snapshot();
  }

  @override
  Future<LifeSnapshot> remove(String id) {
    final entry = _entries.firstWhere((item) => item.id == id);

    if (entry.sourceBillId != null ||
        (entry.kind == EntryKind.bill && entry.done)) {
      throw StateError('Paid entries are read-only in Part 1.');
    }

    _entries = _entries.where((item) => item.id != id).toList();

    return _snapshot();
  }

  @override
  Future<LifeSnapshot> toggleTask(String id) {
    final entry = _entries.firstWhere((item) => item.id == id);

    if (!entry.isTask) {
      throw StateError('Only tasks can be toggled.');
    }

    return save(entry.copyWith(done: !entry.done));
  }

  @override
  Future<LifeSnapshot> payBill(String id) {
    final bill = _entries.firstWhere((item) => item.id == id);

    if (bill.kind != EntryKind.bill) {
      throw StateError('Entry is not a bill.');
    }

    // ป้องกันสร้างรายจ่ายซ้ำจากบิลเดิม
    if (bill.done) return _snapshot();

    _entries = [
      for (final entry in _entries)
        if (entry.id == id) entry.copyWith(done: true) else entry,
      LifeEntry(
        id: 'payment-$id',
        kind: EntryKind.expense,
        title: bill.title,
        due: DateTime.now(),
        amount: bill.amount,
        currency: bill.currency,
        shared: bill.shared,
        sourceBillId: bill.id,
        note: 'บันทึกชำระจากบิล',
      ),
    ];

    return _snapshot();
  }
}

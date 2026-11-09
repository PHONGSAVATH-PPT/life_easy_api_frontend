import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/life_bloc.dart';
import '../../core/design.dart';
import '../../domain/models.dart';

void openEntryForm(
  BuildContext context, {
  EntryKind kind = EntryKind.task,
  LifeEntry? entry,
  bool isNew = false,
}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => EntryForm(kind: kind, entry: entry, isNew: isNew),
    ),
  );
}

class EntryForm extends StatefulWidget {
  const EntryForm({
    super.key,
    this.kind = EntryKind.task,
    this.entry,
    this.isNew = false,
  });

  final EntryKind kind;
  final LifeEntry? entry;
  final bool isNew;

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final form = GlobalKey<FormState>();

  late final TextEditingController title;
  late final TextEditingController amount;
  late final TextEditingController note;

  late EntryKind kind;
  late DateTime due;
  late String currency;
  late String recurrence;
  late bool shared;
  late bool reminder;

  String? assignee;
  bool submitted = false;
  bool initializedCurrency = false;

  bool get isTask => kind == EntryKind.task || kind == EntryKind.appointment;

  bool get isMoney =>
      kind == EntryKind.income ||
      kind == EntryKind.expense ||
      kind == EntryKind.bill;

  @override
  void initState() {
    super.initState();

    final entry = widget.entry;

    title = TextEditingController(text: entry?.title ?? '');
    note = TextEditingController(text: entry?.note ?? '');

    amount = TextEditingController(
      text: entry == null || entry.amount == 0
          ? ''
          : entry.currency == 'THB'
          ? (entry.amount / 100).toStringAsFixed(2)
          : entry.amount.toString(),
    );

    kind = entry?.kind ?? widget.kind;
    due = entry?.due ?? DateTime.now();
    currency = entry?.currency ?? 'LAK';
    recurrence = entry?.recurrence ?? 'none';
    shared = entry?.shared ?? false;
    reminder = entry?.reminder ?? false;
    assignee = entry?.assignee;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (initializedCurrency) return;

    if (widget.entry == null) {
      currency = context.read<LifeBloc>().state.currency;
    }

    initializedCurrency = true;
  }

  @override
  void dispose() {
    title.dispose();
    amount.dispose();
    note.dispose();
    super.dispose();
  }

  int? parseAmount() {
    final text = amount.text.trim();

    final pattern = currency == 'THB'
        ? RegExp(r'^\d+(\.\d{1,2})?$')
        : RegExp(r'^\d+$');

    if (!pattern.hasMatch(text)) return null;

    final parts = text.split('.');
    final whole = int.tryParse(parts.first);

    if (whole == null || whole > 900000000000) return null;

    if (currency == 'LAK') return whole;

    final fraction = parts.length > 1
        ? int.parse(parts[1].padRight(2, '0'))
        : 0;

    return whole * 100 + fraction;
  }

  Future<void> pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: due,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );

    if (selected == null || !mounted) return;

    setState(() {
      due = DateTime(
        selected.year,
        selected.month,
        selected.day,
        due.hour,
        due.minute,
      );
    });
  }

  Future<void> pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(due),
    );

    if (selected == null || !mounted) return;

    setState(() {
      due = DateTime(
        due.year,
        due.month,
        due.day,
        selected.hour,
        selected.minute,
      );
    });
  }

  void save() {
    if (!form.currentState!.validate()) return;

    setState(() => submitted = true);

    context.read<LifeBloc>().add(
      EntrySaved(
        LifeEntry(
          id:
              widget.entry?.id ??
              DateTime.now().microsecondsSinceEpoch.toString(),
          kind: kind,
          title: title.text.trim(),
          due: due,
          amount: isMoney ? parseAmount()! : 0,
          currency: currency,
          shared: shared,
          done: widget.entry?.done ?? false,
          note: note.text.trim(),
          reminder:
              (isTask ||
                  kind == EntryKind.bill ||
                  kind == EntryKind.document) &&
              reminder,
          recurrence: isTask || kind == EntryKind.bill ? recurrence : 'none',
          assignee: isTask && shared ? assignee : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LifeBloc, LifeState>(
      listenWhen: (previous, current) =>
          submitted && previous.saving && !current.saving,
      listener: (context, state) {
        if (state.error == null) {
          Navigator.pop(context);
        } else {
          setState(() => submitted = false);
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: !submitted,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                tr(
                  context,
                  widget.entry != null && !widget.isNew ? 'edit' : 'add',
                ),
              ),
            ),
            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Form(
                    key: form,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      children: [
                        Surface(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr(context, 'details'),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField<EntryKind>(
                                value: kind,
                                decoration: InputDecoration(
                                  labelText: tr(context, 'type'),
                                ),
                                items: EntryKind.values
                                    .map(
                                      (value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(tr(context, value.name)),
                                      ),
                                    )
                                    .toList(),
                                onChanged: submitted
                                    ? null
                                    : (value) {
                                        if (value != null) {
                                          setState(() => kind = value);
                                        }
                                      },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: title,
                                enabled: !submitted,
                                decoration: InputDecoration(
                                  labelText: tr(context, 'title'),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return tr(context, 'required');
                                  }
                                  return null;
                                },
                              ),
                              if (isMoney) ...[
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: amount,
                                  enabled: !submitted,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  decoration: InputDecoration(
                                    labelText: tr(context, 'amount'),
                                  ),
                                  validator: (_) {
                                    final value = parseAmount();

                                    return value == null || value <= 0
                                        ? tr(context, 'validAmount')
                                        : null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: currency,
                                  decoration: InputDecoration(
                                    labelText: tr(context, 'currency'),
                                  ),
                                  items: ['LAK', 'THB']
                                      .map(
                                        (value) => DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: submitted
                                      ? null
                                      : (value) {
                                          if (value != null) {
                                            setState(() => currency = value);
                                          }
                                        },
                                ),
                              ],
                              const SizedBox(height: 16),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(
                                  Icons.calendar_today_outlined,
                                ),
                                title: Text(
                                  tr(context, 'date'),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: muted,
                                  ),
                                ),
                                subtitle: Text(dateText(due)),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: submitted ? null : pickDate,
                              ),
                              if (isTask)
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(Icons.schedule),
                                  title: Text(
                                    tr(context, 'time'),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: muted,
                                    ),
                                  ),
                                  subtitle: Text(timeText(due)),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: submitted ? null : pickTime,
                                ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: note,
                                enabled: !submitted,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: tr(context, 'note'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Surface(
                          child: Column(
                            children: [
                              SwitchListTile.adaptive(
                                contentPadding: EdgeInsets.zero,
                                title: Text(tr(context, 'share')),
                                subtitle: Text(
                                  tr(context, 'shareSub'),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                value: shared,
                                onChanged: submitted
                                    ? null
                                    : (value) {
                                        setState(() {
                                          shared = value;
                                          if (!value) assignee = null;
                                        });
                                      },
                              ),
                              if (shared && isTask) ...[
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  value: assignee ?? '',
                                  decoration: InputDecoration(
                                    labelText: tr(context, 'assignee'),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: '',
                                      child: Text(tr(context, 'unassigned')),
                                    ),
                                    ...state.data.members.map(
                                      (member) => DropdownMenuItem(
                                        value: member.id,
                                        child: Text(member.name),
                                      ),
                                    ),
                                  ],
                                  onChanged: submitted
                                      ? null
                                      : (value) {
                                          setState(() {
                                            assignee = value == ''
                                                ? null
                                                : value;
                                          });
                                        },
                                ),
                              ],
                              if (isTask ||
                                  kind == EntryKind.bill ||
                                  kind == EntryKind.document)
                                SwitchListTile.adaptive(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(tr(context, 'reminder')),
                                  subtitle: Text(
                                    tr(context, 'reminderSub'),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  value: reminder,
                                  onChanged: submitted
                                      ? null
                                      : (value) {
                                          setState(() => reminder = value);
                                        },
                                ),
                              if (isTask || kind == EntryKind.bill) ...[
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  value: recurrence,
                                  decoration: InputDecoration(
                                    labelText: tr(context, 'repeat'),
                                  ),
                                  items: ['none', 'monthly']
                                      .map(
                                        (value) => DropdownMenuItem(
                                          value: value,
                                          child: Text(tr(context, value)),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: submitted
                                      ? null
                                      : (value) {
                                          if (value != null) {
                                            setState(() => recurrence = value);
                                          }
                                        },
                                ),
                                InfoNote(tr(context, 'recurrenceInfo')),
                              ],
                            ],
                          ),
                        ),
                        if (kind == EntryKind.document)
                          InfoNote(tr(context, 'attachInfo')),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: submitted || state.saving ? null : save,
                          icon: submitted
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.check_rounded),
                          label: Text(tr(context, 'save')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

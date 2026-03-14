class ReminderModel {
  final String id;
  final int notifBaseId; // base notification ID; daily uses notifBaseId, weekday-specific uses notifBaseId+weekday
  final String title;
  final String? note;
  final int hour;
  final int minute;
  // empty = every day; [1..7] = specific weekdays (1=Mon, 7=Sun)
  final List<int> repeatDays;
  final bool isEnabled;

  const ReminderModel({
    required this.id,
    required this.notifBaseId,
    required this.title,
    this.note,
    required this.hour,
    required this.minute,
    this.repeatDays = const [],
    this.isEnabled = true,
  });

  bool get isDaily => repeatDays.isEmpty;

  String get timeLabel {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get repeatLabel {
    if (isDaily) return 'Hàng ngày';
    const names = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final sorted = [...repeatDays]..sort();
    if (sorted.length == 5 && !sorted.contains(6) && !sorted.contains(7)) {
      return 'Ngày trong tuần';
    }
    if (sorted.length == 2 && sorted.contains(6) && sorted.contains(7)) {
      return 'Cuối tuần';
    }
    return sorted.map((d) => names[d - 1]).join(', ');
  }

  ReminderModel copyWith({
    String? title,
    String? note,
    int? hour,
    int? minute,
    List<int>? repeatDays,
    bool? isEnabled,
  }) =>
      ReminderModel(
        id: id,
        notifBaseId: notifBaseId,
        title: title ?? this.title,
        note: note ?? this.note,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        repeatDays: repeatDays ?? this.repeatDays,
        isEnabled: isEnabled ?? this.isEnabled,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'notifBaseId': notifBaseId,
        'title': title,
        if (note != null) 'note': note,
        'hour': hour,
        'minute': minute,
        'repeatDays': repeatDays,
        'isEnabled': isEnabled,
      };

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
        id: json['id'] as String,
        notifBaseId: json['notifBaseId'] as int,
        title: json['title'] as String,
        note: json['note'] as String?,
        hour: json['hour'] as int,
        minute: json['minute'] as int,
        repeatDays: List<int>.from(json['repeatDays'] as List),
        isEnabled: json['isEnabled'] as bool,
      );
}

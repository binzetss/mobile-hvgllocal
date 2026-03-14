import 'package:flutter/material.dart';

/// Global navigator key — used by widgets above the Navigator (e.g. floating
/// overlay) to push named routes without needing a BuildContext that descends
/// from the Navigator.
final appNavigatorKey = GlobalKey<NavigatorState>();

/// Set to true while ReminderPage is open so the floating button hides itself.
final reminderPageOpen = ValueNotifier<bool>(false);

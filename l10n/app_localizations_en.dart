// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Planner+';

  @override
  String get tasks => 'Tasks';

  @override
  String get addTask => 'Add Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get deleteTask => 'Delete Task';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get dueDate => 'Due Date';

  @override
  String get priority => 'Priority';

  @override
  String get tags => 'Tags';

  @override
  String get high => 'High';

  @override
  String get medium => 'Medium';

  @override
  String get low => 'Low';

  @override
  String get completed => 'Completed';

  @override
  String get pending => 'Pending';

  @override
  String get search => 'Search tasks...';

  @override
  String get filter => 'Filter';

  @override
  String get sortBy => 'Sort By';

  @override
  String get all => 'All';

  @override
  String get active => 'Active';

  @override
  String get noTasks => 'No tasks found';

  @override
  String get createFirstTask => 'Create your first task';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Are you sure you want to delete this task?';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemMode => 'System';

  @override
  String get language => 'Language';

  @override
  String get offline => 'Offline';

  @override
  String get online => 'Online';

  @override
  String get syncing => 'Syncing...';

  @override
  String lastSync(String time) {
    return 'Last sync: $time';
  }

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get taskDetails => 'Task Details';
}

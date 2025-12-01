import 'app_localizations.dart';

class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu() : super('ru');

  @override
  String get appTitle => 'Planner+';

  @override
  String get tasks => 'Задачи';

  @override
  String get addTask => 'Добавить задачу';

  @override
  String get editTask => 'Редактировать задачу';

  @override
  String get deleteTask => 'Удалить задачу';

  @override
  String get title => 'Название';

  @override
  String get description => 'Описание';

  @override
  String get dueDate => 'Срок выполнения';

  @override
  String get priority => 'Приоритет';

  @override
  String get tags => 'Теги';

  @override
  String get high => 'Высокий';

  @override
  String get medium => 'Средний';

  @override
  String get low => 'Низкий';

  @override
  String get completed => 'Завершено';

  @override
  String get pending => 'В процессе';

  @override
  String get search => 'Поиск задач...';

  @override
  String get filter => 'Фильтр';

  @override
  String get sortBy => 'Сортировать по';

  @override
  String get all => 'Все';

  @override
  String get active => 'Активные';

  @override
  String get noTasks => 'Задачи не найдены';

  @override
  String get createFirstTask => 'Создайте первую задачу';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get confirmDelete => 'Вы уверены, что хотите удалить эту задачу?';

  @override
  String get settings => 'Настройки';

  @override
  String get theme => 'Тема';

  @override
  String get lightMode => 'Светлая';

  @override
  String get darkMode => 'Тёмная';

  @override
  String get systemMode => 'Системная';

  @override
  String get language => 'Язык';

  @override
  String get offline => 'Оффлайн';

  @override
  String get online => 'Онлайн';

  @override
  String get syncing => 'Синхронизация...';

  @override
  String lastSync(String time) => 'Последняя синхронизация: $time';

  @override
  String get error => 'Ошибка';

  @override
  String get retry => 'Повторить';

  @override
  String get networkError => 'Ошибка сети. Проверьте подключение.';

  @override
  String get titleRequired => 'Название обязательно';

  @override
  String get taskDetails => 'Детали задачи';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'GsrApp - Управление залами заседаний';

  @override
  String get roomsList => 'Список залов';

  @override
  String get categories => 'Категории';

  @override
  String get reservations => 'Бронирования';

  @override
  String get statistics => 'Статистика';

  @override
  String get settings => 'Настройки';

  @override
  String get available => 'Доступен';

  @override
  String get reserved => 'Забронирован';

  @override
  String get refection => 'На ремонте';

  @override
  String get degraded => 'В плохом состоянии';

  @override
  String get construction => 'На строительстве';

  @override
  String get free => 'Бесплатно';

  @override
  String get rental => 'Аренда';

  @override
  String get amount => 'Сумма';

  @override
  String get computers => 'Компьютеры';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Изменить';

  @override
  String get close => 'Закрыть';

  @override
  String get create => 'Создать';

  @override
  String get all => 'Все';

  @override
  String get fieldRequired => 'Обязательное поле.';

  @override
  String get saveFailed => 'Не удалось сохранить.';

  @override
  String get searchHint => 'Поиск...';

  @override
  String get clear => 'Очистить';

  @override
  String get noResults => 'Ничего не найдено.';

  @override
  String get noOptions => 'Нет доступных вариантов.';

  @override
  String get noData => 'Нет данных.';

  @override
  String get notProvided => 'Не указано';

  @override
  String confirmDeleteNamed(String name) {
    return 'Удалить «$name»?';
  }

  @override
  String get errServerUnreachable =>
      'Не удалось связаться с сервером. Проверьте подключение.';

  @override
  String get errUnexpected => 'Произошла непредвиденная ошибка.';

  @override
  String errServerStatus(String code) {
    return 'Ошибка сервера ($code)';
  }

  @override
  String get roomStatusAvailable => 'Доступен';

  @override
  String get roomStatusReserved => 'Забронирован';

  @override
  String get roomStatusRefection => 'На ремонте';

  @override
  String get roomStatusDegraded => 'В плохом состоянии';

  @override
  String get roomStatusConstruction => 'На строительстве';

  @override
  String get tabAvailable => 'Доступные';

  @override
  String get tabReserved => 'Забронированные';

  @override
  String get tabRefection => 'Ремонт';

  @override
  String get tabDegraded => 'В плохом состоянии';

  @override
  String get tabConstruction => 'Строительство';

  @override
  String get resPending => 'В ожидании';

  @override
  String get resValidated => 'Подтверждённые';

  @override
  String get resRejected => 'Отклонённые';

  @override
  String get roleAdmin => 'Администратор';

  @override
  String get roleAgent => 'Сотрудник';

  @override
  String get home => 'Главная';

  @override
  String get userAccounts => 'Учётные записи';

  @override
  String get regionalDirections => 'Региональные дирекции';

  @override
  String get structures => 'Структуры';

  @override
  String get notifications => 'Уведомления';

  @override
  String get messaging => 'Сообщения';

  @override
  String get logout => 'Выйти';

  @override
  String get logoutConfirm => 'Вы действительно хотите выйти?';

  @override
  String get loginForgotInfo =>
      'Обратитесь к администратору для сброса пароля.';

  @override
  String get loginIdentifier => 'Эл. почта или логин';

  @override
  String get loginIdentifierRequired => 'Укажите логин.';

  @override
  String get password => 'Пароль';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String get hidePassword => 'Скрыть пароль';

  @override
  String get passwordRequired => 'Укажите пароль.';

  @override
  String get errorMessageLabel => 'Сообщение об ошибке';

  @override
  String get loginButtonLabel => 'Кнопка входа';

  @override
  String get signIn => 'Войти';

  @override
  String get registerQuestion => 'Зарегистрироваться?';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get noAccountCreate => 'Нет аккаунта? Создать';

  @override
  String get dgiName => 'Главное налоговое управление Буркина-Фасо';

  @override
  String get roomsManagementTitle => 'Управление залами заседаний';

  @override
  String get roomsAndReservationsTitle =>
      'Управление залами заседаний и бронированиями';

  @override
  String get loginWelcome => 'Войдите в свой аккаунт';

  @override
  String get loginTagline => 'Бронируйте залы легко';

  @override
  String get createAccountButtonLabel => 'Кнопка создания аккаунта';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String footerInstitution(int year) {
    return '© $year - Ваша организация';
  }

  @override
  String fieldRequiredNamed(String label) {
    return '$label: обязательное поле.';
  }

  @override
  String fieldSemantics(String label) {
    return 'Поле «$label»';
  }

  @override
  String get registrationSent => 'Заявка отправлена';

  @override
  String get accountCreatedSuccess => 'Аккаунт успешно создан.';

  @override
  String get lastName => 'Фамилия';

  @override
  String get firstName => 'Имя';

  @override
  String get matricule => 'Табельный номер';

  @override
  String get phoneWhatsapp => 'Телефон (WhatsApp)';

  @override
  String get fleetNumber => 'Корпоративный номер';

  @override
  String get emailAddress => 'Адрес эл. почты';

  @override
  String get emailRequired => 'Укажите адрес эл. почты.';

  @override
  String get emailInvalid => 'Неверный адрес эл. почты.';

  @override
  String get passwordMin6 => 'Пароль должен содержать не менее 8 символов.';

  @override
  String get structureFieldLabel => 'Поле «Структура»';

  @override
  String get createAccountSubmitLabel => 'Кнопка создания аккаунта';

  @override
  String get createTheAccount => 'Создать аккаунт';

  @override
  String get categorySaved => 'Категория сохранена.';

  @override
  String get deleteCategory => 'Удалить категорию';

  @override
  String get categoriesManagementTitle =>
      'Управление категориями залов заседаний';

  @override
  String get tabFree => 'Бесплатные';

  @override
  String get tabRental => 'Аренда';

  @override
  String get noCategories => 'Категории залов заседаний не добавлены.';

  @override
  String categoryIcon(String name) {
    return 'Значок категории $name';
  }

  @override
  String get categoryFree => 'Бесплатная';

  @override
  String categoryRentalAmount(String amount) {
    return 'Аренда - $amount FCFA';
  }

  @override
  String get inactiveSuffix => ' (неактивна)';

  @override
  String get editCategory => 'Изменить категорию';

  @override
  String get newCategory => 'Новая категория';

  @override
  String get label => 'Название';

  @override
  String get labelRequired => 'Укажите название.';

  @override
  String get type => 'Тип';

  @override
  String get rentalAmountFcfa => 'Стоимость аренды (FCFA)';

  @override
  String get invalidAmount => 'Неверная сумма.';

  @override
  String get active => 'Активна';

  @override
  String get newMessageChooseAgent => 'Новое сообщение: выберите сотрудника';

  @override
  String get newMessage => 'Новое сообщение';

  @override
  String get noAgentMessages =>
      'Сообщений от сотрудников пока нет.\nНажмите «Новое сообщение», чтобы написать сотруднику.';

  @override
  String get messagingWithAdmin => 'Переписка с администрацией';

  @override
  String get noMessages => 'Сообщений пока нет.';

  @override
  String get writeMessage => 'Напишите сообщение...';

  @override
  String get dashRooms => 'Залы';

  @override
  String get dashAvailableRooms => 'Доступные залы';

  @override
  String get dashValidationRate => 'Доля подтверждённых';

  @override
  String get dashRoomsByStatus => 'Залы по статусу';

  @override
  String get dashReservationsByStatus => 'Бронирования по статусу';

  @override
  String get mostRequestedRooms => 'Самые востребованные залы';

  @override
  String get dashReservationsByDirection =>
      'Бронирования по региональным дирекциям';

  @override
  String get welcome => 'Добро пожаловать';

  @override
  String helloName(String name) {
    return 'Здравствуйте, $name';
  }

  @override
  String get dashSubtitle => 'Вот активность ваших залов заседаний.';

  @override
  String get noRegionalDirections => 'Региональные дирекции не найдены.';

  @override
  String get noNotifications => 'Уведомлений нет.';

  @override
  String get structuresLoadError =>
      'Не удалось загрузить структуры. Нажмите, чтобы повторить.';

  @override
  String get editStructure => 'Изменить структуру';

  @override
  String get newStructure => 'Новая структура';

  @override
  String get codeCdi => 'Код CDI';

  @override
  String get codeRequired => 'Укажите код.';

  @override
  String get noStructures => 'Структуры не добавлены.';

  @override
  String get structureRequired => 'Укажите структуру.';

  @override
  String get loadingStructures => 'Загрузка структур…';

  @override
  String get structure => 'Структура';

  @override
  String get chooseStructure => 'Выберите структуру';

  @override
  String get searchStructure => 'Поиск структуры…';

  @override
  String get noStructureFound => 'Структуры не найдены.';

  @override
  String get rejectRequest => 'Отклонить заявку';

  @override
  String get rejectReasonOptional => 'Причина (необязательно)';

  @override
  String get reject => 'Отклонить';

  @override
  String get validate => 'Подтвердить';

  @override
  String get reservationRequests => 'Заявки на бронирование';

  @override
  String get iconPending => 'Значок «в ожидании»';

  @override
  String get iconValidated => 'Значок «подтверждено»';

  @override
  String get iconRejected => 'Значок «отклонено»';

  @override
  String get request => 'Запросить';

  @override
  String get noReservations => 'Бронирования не найдены.';

  @override
  String reservationStatusLabel(String status) {
    return 'Статус бронирования: $status';
  }

  @override
  String roomNumberFallback(String id) {
    return 'Зал №$id';
  }

  @override
  String reservationStructureLine(String value) {
    return 'Структура: $value';
  }

  @override
  String reservationDateLine(String date, String start, String end) {
    return 'Дата: $date ($start - $end)';
  }

  @override
  String reservationReasonLine(String reason) {
    return 'Причина: $reason';
  }

  @override
  String get selectDateSlot => 'Выберите дату и время.';

  @override
  String get endAfterStart =>
      'Время окончания должно быть позже времени начала.';

  @override
  String get noRoomAvailable => 'На это время нет свободных залов.';

  @override
  String get chooseAvailableRoom => 'Выберите свободный зал.';

  @override
  String get requestSent => 'Заявка на бронирование отправлена.';

  @override
  String get requestFailed => 'Не удалось отправить заявку.';

  @override
  String get newReservationRequest => 'Новая заявка на бронирование';

  @override
  String get date => 'Дата';

  @override
  String get startTime => 'Начало';

  @override
  String get endTime => 'Конец';

  @override
  String get viewAvailableRooms => 'Показать свободные залы';

  @override
  String get meetingSubject => 'Тема встречи';

  @override
  String get subjectRequired => 'Укажите тему.';

  @override
  String get organizingStructure => 'Организующая структура';

  @override
  String get sendRequest => 'Отправить заявку';

  @override
  String get roomSaved => 'Зал сохранён.';

  @override
  String get deleteRoom => 'Удалить зал';

  @override
  String get noRooms => 'Залы не добавлены.';

  @override
  String roomIcon(String name) {
    return 'Значок зала $name';
  }

  @override
  String get noCategory => 'Без категории';

  @override
  String roomSubtitle(String city, String status, String category) {
    return '$city - $status ($category)';
  }

  @override
  String amountFcfa(String amount) {
    return '$amount FCFA';
  }

  @override
  String get editRoom => 'Изменить зал';

  @override
  String get newRoom => 'Новый зал';

  @override
  String get roomName => 'Название зала';

  @override
  String get region => 'Регион';

  @override
  String get province => 'Провинция';

  @override
  String get city => 'Город';

  @override
  String get location => 'Расположение (блок, этаж...)';

  @override
  String get category => 'Категория';

  @override
  String get regionalDirection => 'Региональная дирекция';

  @override
  String get status => 'Статус';

  @override
  String get rentalAmountFree => 'Стоимость аренды (FCFA, 0 если бесплатно)';

  @override
  String get computerCount => 'Количество компьютеров';

  @override
  String get equippedComputers => 'Оборудован компьютерами';

  @override
  String get statsTitle => 'Статистика и аналитика GsrApp';

  @override
  String get reservationRequestsTitle => 'Заявки на бронирование';

  @override
  String get successRate => 'Доля успеха';

  @override
  String get frequencyByDirection => 'Загруженность по региональным дирекциям';

  @override
  String get noReservationsYet => 'Бронирований пока нет.';

  @override
  String requestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count заявки',
      many: '$count заявок',
      few: '$count заявки',
      one: '$count заявка',
    );
    return '$_temp0';
  }

  @override
  String get accountCreationFailed => 'Не удалось создать аккаунт.';

  @override
  String get userAccountsManagement => 'Управление учётными записями';

  @override
  String get noPendingAccounts => 'Нет аккаунтов, ожидающих подтверждения.';

  @override
  String get noStructureShort => 'Без структуры';

  @override
  String get approveAccount => 'Подтвердить аккаунт';

  @override
  String get rejectAccount => 'Отклонить аккаунт';

  @override
  String get temporaryPassword => 'Временный пароль';

  @override
  String get atLeast6Chars => 'Не менее 8 символов.';

  @override
  String get role => 'Роль';

  @override
  String get email => 'Эл. почта';

  @override
  String get connectedAccount => 'Текущий аккаунт';

  @override
  String get appLanguage => 'Язык приложения';

  @override
  String get appTheme => 'Тема приложения';

  @override
  String get darkMode => 'Тёмная тема';

  @override
  String get darkModeOn => 'Тёмная тема включена';

  @override
  String get lightModeOn => 'Светлая тема включена';

  @override
  String get logoutButtonLabel => 'Кнопка выхода';

  @override
  String get identifier => 'Логин';

  @override
  String get phone => 'Телефон';

  @override
  String get fleetNumberFull => 'Корпоративный номер';

  @override
  String get language => 'Язык';

  @override
  String get connChecking => 'Проверка…';

  @override
  String get connUnreachable => 'Сервер недоступен';

  @override
  String get connDbDown => 'API доступен, база данных недоступна';

  @override
  String connOk(int ms) {
    return 'Подключено к API и MySQL ($ms мс)';
  }

  @override
  String get connSemantics => 'Состояние подключения к API';

  @override
  String get connTitle => 'Состояние подключения к MySQL (dbgsr)';

  @override
  String get retest => 'Проверить снова';

  @override
  String get appVersion => 'Версия приложения';

  @override
  String get aboutDescription =>
      'Управление залами заседаний и бронированиями.';

  @override
  String get errTimeout => 'Сервер слишком долго не отвечает.';

  @override
  String get errSessionExpired => 'Сеанс истёк, войдите снова.';

  @override
  String get retry => 'Повторить';

  @override
  String get activateAgentHint =>
      'Логин должен соответствовать существующему сотруднику DGI.';

  @override
  String get loadMore => 'Загрузить ещё';

  @override
  String get changePhoto => 'Изменить фото';

  @override
  String get removePhoto => 'Удалить фото';

  @override
  String get photoUpdateSuccess => 'Фото профиля обновлено.';

  @override
  String get photoUpdateFailed => 'Не удалось загрузить фото.';

  @override
  String get photoRemoveSuccess => 'Фото профиля удалено.';

  @override
  String get photoInvalidType => 'Допустимые форматы: JPEG, PNG, WEBP.';

  @override
  String get photoTooLarge => 'Слишком большое фото (максимум 5 МБ).';
}

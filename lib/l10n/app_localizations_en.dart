// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GsrApp - Room Management';

  @override
  String get roomsList => 'Rooms List';

  @override
  String get categories => 'Categories';

  @override
  String get reservations => 'Reservations';

  @override
  String get statistics => 'Statistics';

  @override
  String get settings => 'Settings';

  @override
  String get available => 'Available';

  @override
  String get reserved => 'Reserved';

  @override
  String get refection => 'Under Repair';

  @override
  String get degraded => 'Degraded';

  @override
  String get construction => 'Under Construction';

  @override
  String get free => 'Free';

  @override
  String get rental => 'Rental';

  @override
  String get amount => 'Amount';

  @override
  String get computers => 'Computers';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get create => 'Create';

  @override
  String get all => 'All';

  @override
  String get fieldRequired => 'Required field.';

  @override
  String get saveFailed => 'Saving failed.';

  @override
  String get searchHint => 'Search...';

  @override
  String get clear => 'Clear';

  @override
  String get noResults => 'No results.';

  @override
  String get noOptions => 'No options available.';

  @override
  String get noData => 'No data available.';

  @override
  String get notProvided => 'Not provided';

  @override
  String confirmDeleteNamed(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get errServerUnreachable =>
      'Unable to reach the server. Check your connection.';

  @override
  String get errUnexpected => 'An unexpected error occurred.';

  @override
  String errServerStatus(String code) {
    return 'Server error ($code)';
  }

  @override
  String get roomStatusAvailable => 'Available';

  @override
  String get roomStatusReserved => 'Reserved';

  @override
  String get roomStatusRefection => 'Under repair';

  @override
  String get roomStatusDegraded => 'Degraded';

  @override
  String get roomStatusConstruction => 'Under construction';

  @override
  String get tabAvailable => 'Available';

  @override
  String get tabReserved => 'Reserved';

  @override
  String get tabRefection => 'Repair';

  @override
  String get tabDegraded => 'Degraded';

  @override
  String get tabConstruction => 'Construction';

  @override
  String get resPending => 'Pending';

  @override
  String get resValidated => 'Approved';

  @override
  String get resRejected => 'Rejected';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleAgent => 'Agent';

  @override
  String get home => 'Home';

  @override
  String get userAccounts => 'User accounts';

  @override
  String get regionalDirections => 'Regional directions';

  @override
  String get structures => 'Structures';

  @override
  String get notifications => 'Notifications';

  @override
  String get messaging => 'Messaging';

  @override
  String get logout => 'Log out';

  @override
  String get logoutConfirm => 'Do you really want to log out?';

  @override
  String get loginForgotInfo =>
      'Contact an administrator to reset your password.';

  @override
  String get loginIdentifier => 'Email or username';

  @override
  String get loginIdentifierRequired => 'The username is required.';

  @override
  String get password => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get passwordRequired => 'The password is required.';

  @override
  String get errorMessageLabel => 'Error message';

  @override
  String get loginButtonLabel => 'Log in button';

  @override
  String get signIn => 'Log in';

  @override
  String get registerQuestion => 'Sign up?';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccountCreate => 'No account yet? Create one';

  @override
  String get dgiName => 'General Directorate of Taxes of Burkina Faso';

  @override
  String get roomsManagementTitle => 'Meeting Room Management';

  @override
  String get roomsAndReservationsTitle =>
      'Meeting Room and Reservation Management';

  @override
  String get loginWelcome => 'Log in to your account';

  @override
  String get loginTagline => 'Book your rooms with ease';

  @override
  String get createAccountButtonLabel => 'Create account button';

  @override
  String get createAccount => 'Create an account';

  @override
  String footerInstitution(int year) {
    return '© $year - Your institution';
  }

  @override
  String fieldRequiredNamed(String label) {
    return '$label is required.';
  }

  @override
  String fieldSemantics(String label) {
    return '$label field';
  }

  @override
  String get registrationSent => 'Registration sent';

  @override
  String get accountCreatedSuccess => 'Account created successfully.';

  @override
  String get lastName => 'Last name';

  @override
  String get firstName => 'First name';

  @override
  String get matricule => 'Employee ID';

  @override
  String get phoneWhatsapp => 'Phone (WhatsApp)';

  @override
  String get fleetNumber => 'Fleet number';

  @override
  String get emailAddress => 'Email address';

  @override
  String get emailRequired => 'The email address is required.';

  @override
  String get emailInvalid => 'Invalid email address.';

  @override
  String get passwordMin6 => 'The password must contain at least 8 characters.';

  @override
  String get structureFieldLabel => 'Structure field';

  @override
  String get createAccountSubmitLabel => 'Create the account button';

  @override
  String get createTheAccount => 'Create the account';

  @override
  String get categorySaved => 'Category saved.';

  @override
  String get deleteCategory => 'Delete category';

  @override
  String get categoriesManagementTitle => 'Meeting room category management';

  @override
  String get tabFree => 'Free';

  @override
  String get tabRental => 'Rental';

  @override
  String get noCategories => 'No meeting room category registered.';

  @override
  String categoryIcon(String name) {
    return 'Category icon $name';
  }

  @override
  String get categoryFree => 'Free';

  @override
  String categoryRentalAmount(String amount) {
    return 'Rental - $amount FCFA';
  }

  @override
  String get inactiveSuffix => ' (inactive)';

  @override
  String get editCategory => 'Edit category';

  @override
  String get newCategory => 'New category';

  @override
  String get label => 'Label';

  @override
  String get labelRequired => 'The label is required.';

  @override
  String get type => 'Type';

  @override
  String get rentalAmountFcfa => 'Rental amount (FCFA)';

  @override
  String get invalidAmount => 'Invalid amount.';

  @override
  String get active => 'Active';

  @override
  String get newMessageChooseAgent => 'New message: choose an agent';

  @override
  String get newMessage => 'New message';

  @override
  String get noAgentMessages =>
      'No agent messages yet.\nUse \"New message\" to write to an agent.';

  @override
  String get messagingWithAdmin => 'Messaging with the administration';

  @override
  String get noMessages => 'No messages yet.';

  @override
  String get writeMessage => 'Write a message...';

  @override
  String get dashRooms => 'Rooms';

  @override
  String get dashAvailableRooms => 'Available rooms';

  @override
  String get dashValidationRate => 'Approval rate';

  @override
  String get dashRoomsByStatus => 'Rooms by status';

  @override
  String get dashReservationsByStatus => 'Reservations by status';

  @override
  String get mostRequestedRooms => 'Most requested rooms';

  @override
  String get dashReservationsByDirection =>
      'Reservations by regional direction';

  @override
  String get welcome => 'Welcome';

  @override
  String helloName(String name) {
    return 'Hello, $name';
  }

  @override
  String get dashSubtitle => 'Here is the activity of your meeting rooms.';

  @override
  String get noRegionalDirections => 'No regional direction found.';

  @override
  String get noNotifications => 'No notifications.';

  @override
  String get structuresLoadError => 'Unable to load structures. Tap to retry.';

  @override
  String get editStructure => 'Edit structure';

  @override
  String get newStructure => 'New structure';

  @override
  String get codeCdi => 'CDI code';

  @override
  String get codeRequired => 'The code is required.';

  @override
  String get noStructures => 'No structure registered.';

  @override
  String get structureRequired => 'The structure is required.';

  @override
  String get loadingStructures => 'Loading structures…';

  @override
  String get structure => 'Structure';

  @override
  String get chooseStructure => 'Choose a structure';

  @override
  String get searchStructure => 'Search for a structure…';

  @override
  String get noStructureFound => 'No structure found.';

  @override
  String get rejectRequest => 'Reject the request';

  @override
  String get rejectReasonOptional => 'Reason (optional)';

  @override
  String get reject => 'Reject';

  @override
  String get validate => 'Approve';

  @override
  String get reservationRequests => 'Reservation Requests';

  @override
  String get iconPending => 'Pending icon';

  @override
  String get iconValidated => 'Approved icon';

  @override
  String get iconRejected => 'Rejected icon';

  @override
  String get request => 'Request';

  @override
  String get noReservations => 'No reservation found.';

  @override
  String reservationStatusLabel(String status) {
    return 'Reservation status: $status';
  }

  @override
  String roomNumberFallback(String id) {
    return 'Room #$id';
  }

  @override
  String reservationStructureLine(String value) {
    return 'Structure: $value';
  }

  @override
  String reservationDateLine(String date, String start, String end) {
    return 'Date: $date ($start - $end)';
  }

  @override
  String reservationReasonLine(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get selectDateSlot => 'Select a date and a time slot.';

  @override
  String get endAfterStart => 'The end time must be after the start time.';

  @override
  String get noRoomAvailable => 'No room available for this time slot.';

  @override
  String get chooseAvailableRoom => 'Choose an available room.';

  @override
  String get requestSent => 'Reservation request sent.';

  @override
  String get requestFailed => 'The request failed.';

  @override
  String get newReservationRequest => 'New reservation request';

  @override
  String get date => 'Date';

  @override
  String get startTime => 'Start';

  @override
  String get endTime => 'End';

  @override
  String get viewAvailableRooms => 'View available rooms';

  @override
  String get meetingSubject => 'Meeting subject';

  @override
  String get subjectRequired => 'The subject is required.';

  @override
  String get organizingStructure => 'Organizing structure';

  @override
  String get sendRequest => 'Send the request';

  @override
  String get roomSaved => 'Room saved.';

  @override
  String get deleteRoom => 'Delete room';

  @override
  String get noRooms => 'No room registered.';

  @override
  String roomIcon(String name) {
    return 'Room icon $name';
  }

  @override
  String get noCategory => 'No category';

  @override
  String roomSubtitle(String city, String status, String category) {
    return '$city - $status ($category)';
  }

  @override
  String amountFcfa(String amount) {
    return '$amount FCFA';
  }

  @override
  String get editRoom => 'Edit room';

  @override
  String get newRoom => 'New room';

  @override
  String get roomName => 'Room name';

  @override
  String get region => 'Region';

  @override
  String get province => 'Province';

  @override
  String get city => 'City';

  @override
  String get location => 'Location (block, floor...)';

  @override
  String get category => 'Category';

  @override
  String get regionalDirection => 'Regional direction';

  @override
  String get status => 'Status';

  @override
  String get rentalAmountFree => 'Rental amount (FCFA, 0 if free)';

  @override
  String get computerCount => 'Number of computers';

  @override
  String get equippedComputers => 'Equipped with computers';

  @override
  String get statsTitle => 'GsrApp Statistics & Analytics';

  @override
  String get reservationRequestsTitle => 'Reservation requests';

  @override
  String get successRate => 'Success rate';

  @override
  String get frequencyByDirection => 'Usage by regional direction';

  @override
  String get noReservationsYet => 'No reservation registered yet.';

  @override
  String requestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count requests',
      one: '$count request',
    );
    return '$_temp0';
  }

  @override
  String get accountCreationFailed => 'Account creation failed.';

  @override
  String get userAccountsManagement => 'User account management';

  @override
  String get noPendingAccounts => 'No account awaiting approval.';

  @override
  String get noStructureShort => 'No structure';

  @override
  String get approveAccount => 'Approve account';

  @override
  String get rejectAccount => 'Reject account';

  @override
  String get temporaryPassword => 'Temporary password';

  @override
  String get atLeast6Chars => 'At least 8 characters.';

  @override
  String get role => 'Role';

  @override
  String get email => 'Email';

  @override
  String get connectedAccount => 'Signed-in account';

  @override
  String get appLanguage => 'App language';

  @override
  String get appTheme => 'App theme';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get darkModeOn => 'Dark theme enabled';

  @override
  String get lightModeOn => 'Light theme enabled';

  @override
  String get logoutButtonLabel => 'Log out button';

  @override
  String get identifier => 'Username';

  @override
  String get phone => 'Phone';

  @override
  String get fleetNumberFull => 'Fleet number';

  @override
  String get language => 'Language';

  @override
  String get connChecking => 'Checking…';

  @override
  String get connUnreachable => 'Server unreachable';

  @override
  String get connDbDown => 'API reachable, database unavailable';

  @override
  String connOk(int ms) {
    return 'Connected to the API and MySQL ($ms ms)';
  }

  @override
  String get connSemantics => 'API connection status';

  @override
  String get connTitle => 'MySQL connection status (dbgsr)';

  @override
  String get retest => 'Test again';

  @override
  String get appVersion => 'App version';

  @override
  String get aboutDescription => 'Meeting room and reservation management.';

  @override
  String get errTimeout => 'The server is taking too long to respond.';

  @override
  String get errSessionExpired => 'Session expired, please log in again.';

  @override
  String get retry => 'Retry';

  @override
  String get activateAgentHint =>
      'The username must match an existing DGI agent.';

  @override
  String get loadMore => 'Load more';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get photoUpdateSuccess => 'Profile photo updated.';

  @override
  String get photoUpdateFailed => 'Failed to upload photo.';

  @override
  String get photoRemoveSuccess => 'Profile photo removed.';

  @override
  String get photoInvalidType => 'Accepted formats: JPEG, PNG, WEBP.';

  @override
  String get photoTooLarge => 'Photo too large (5 MB maximum).';
}

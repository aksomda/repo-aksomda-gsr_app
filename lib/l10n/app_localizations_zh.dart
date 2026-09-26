// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'GsrApp - 会议室管理';

  @override
  String get roomsList => '会议室列表';

  @override
  String get categories => '类别';

  @override
  String get reservations => '预订';

  @override
  String get statistics => '统计';

  @override
  String get settings => '设置';

  @override
  String get available => '可用';

  @override
  String get reserved => '已预订';

  @override
  String get refection => '维修中';

  @override
  String get degraded => '状态不佳';

  @override
  String get construction => '建设中';

  @override
  String get free => '免费';

  @override
  String get rental => '租赁';

  @override
  String get amount => '金额';

  @override
  String get computers => '电脑';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get close => '关闭';

  @override
  String get create => '创建';

  @override
  String get all => '全部';

  @override
  String get fieldRequired => '此项为必填项。';

  @override
  String get saveFailed => '保存失败。';

  @override
  String get searchHint => '搜索...';

  @override
  String get clear => '清除';

  @override
  String get noResults => '没有结果。';

  @override
  String get noOptions => '没有可用选项。';

  @override
  String get noData => '暂无数据。';

  @override
  String get notProvided => '未填写';

  @override
  String confirmDeleteNamed(String name) {
    return '确定删除“$name”吗?';
  }

  @override
  String get errServerUnreachable => '无法连接到服务器,请检查您的网络。';

  @override
  String get errUnexpected => '发生了意外错误。';

  @override
  String errServerStatus(String code) {
    return '服务器错误($code)';
  }

  @override
  String get roomStatusAvailable => '可用';

  @override
  String get roomStatusReserved => '已预订';

  @override
  String get roomStatusRefection => '维修中';

  @override
  String get roomStatusDegraded => '状态不佳';

  @override
  String get roomStatusConstruction => '建设中';

  @override
  String get tabAvailable => '可用';

  @override
  String get tabReserved => '已预订';

  @override
  String get tabRefection => '维修';

  @override
  String get tabDegraded => '状态不佳';

  @override
  String get tabConstruction => '建设';

  @override
  String get resPending => '待处理';

  @override
  String get resValidated => '已批准';

  @override
  String get resRejected => '已驳回';

  @override
  String get roleAdmin => '管理员';

  @override
  String get roleAgent => '员工';

  @override
  String get home => '首页';

  @override
  String get userAccounts => '用户账户';

  @override
  String get regionalDirections => '区域局';

  @override
  String get structures => '机构';

  @override
  String get notifications => '通知';

  @override
  String get messaging => '消息';

  @override
  String get logout => '退出登录';

  @override
  String get logoutConfirm => '确定要退出登录吗?';

  @override
  String get loginForgotInfo => '请联系管理员重置您的密码。';

  @override
  String get loginIdentifier => '邮箱或用户名';

  @override
  String get loginIdentifierRequired => '请输入用户名。';

  @override
  String get password => '密码';

  @override
  String get showPassword => '显示密码';

  @override
  String get hidePassword => '隐藏密码';

  @override
  String get passwordRequired => '请输入密码。';

  @override
  String get errorMessageLabel => '错误信息';

  @override
  String get loginButtonLabel => '登录按钮';

  @override
  String get signIn => '登录';

  @override
  String get registerQuestion => '注册?';

  @override
  String get forgotPassword => '忘记密码?';

  @override
  String get noAccountCreate => '还没有账户?立即创建';

  @override
  String get dgiName => '布基纳法索税务总局';

  @override
  String get roomsManagementTitle => '会议室管理';

  @override
  String get roomsAndReservationsTitle => '会议室与预订管理';

  @override
  String get loginWelcome => '登录您的账户';

  @override
  String get loginTagline => '轻松预订您的会议室';

  @override
  String get createAccountButtonLabel => '创建账户按钮';

  @override
  String get createAccount => '创建账户';

  @override
  String footerInstitution(int year) {
    return '© $year - 您的机构';
  }

  @override
  String fieldRequiredNamed(String label) {
    return '请填写$label。';
  }

  @override
  String fieldSemantics(String label) {
    return '$label字段';
  }

  @override
  String get registrationSent => '注册已提交';

  @override
  String get accountCreatedSuccess => '账户创建成功。';

  @override
  String get lastName => '姓';

  @override
  String get firstName => '名';

  @override
  String get matricule => '工号';

  @override
  String get phoneWhatsapp => '电话(WhatsApp)';

  @override
  String get fleetNumber => '集团号码';

  @override
  String get emailAddress => '电子邮箱';

  @override
  String get emailRequired => '请输入电子邮箱。';

  @override
  String get emailInvalid => '电子邮箱格式不正确。';

  @override
  String get passwordMin6 => '密码至少需要 8 个字符。';

  @override
  String get structureFieldLabel => '机构字段';

  @override
  String get createAccountSubmitLabel => '创建账户按钮';

  @override
  String get createTheAccount => '创建账户';

  @override
  String get categorySaved => '类别已保存。';

  @override
  String get deleteCategory => '删除类别';

  @override
  String get categoriesManagementTitle => '会议室类别管理';

  @override
  String get tabFree => '免费';

  @override
  String get tabRental => '租赁';

  @override
  String get noCategories => '尚未登记任何会议室类别。';

  @override
  String categoryIcon(String name) {
    return '类别图标 $name';
  }

  @override
  String get categoryFree => '免费';

  @override
  String categoryRentalAmount(String amount) {
    return '租赁 - $amount FCFA';
  }

  @override
  String get inactiveSuffix => '(已停用)';

  @override
  String get editCategory => '编辑类别';

  @override
  String get newCategory => '新建类别';

  @override
  String get label => '名称';

  @override
  String get labelRequired => '请输入名称。';

  @override
  String get type => '类型';

  @override
  String get rentalAmountFcfa => '租金(FCFA)';

  @override
  String get invalidAmount => '金额无效。';

  @override
  String get active => '启用';

  @override
  String get newMessageChooseAgent => '新消息:选择员工';

  @override
  String get newMessage => '新消息';

  @override
  String get noAgentMessages => '暂无员工消息。\n请使用“新消息”给员工发送消息。';

  @override
  String get messagingWithAdmin => '与管理员的消息';

  @override
  String get noMessages => '暂无消息。';

  @override
  String get writeMessage => '输入消息...';

  @override
  String get dashRooms => '会议室';

  @override
  String get dashAvailableRooms => '可用会议室';

  @override
  String get dashValidationRate => '批准率';

  @override
  String get dashRoomsByStatus => '按状态统计会议室';

  @override
  String get dashReservationsByStatus => '按状态统计预订';

  @override
  String get mostRequestedRooms => '最受欢迎的会议室';

  @override
  String get dashReservationsByDirection => '按区域局统计预订';

  @override
  String get welcome => '欢迎';

  @override
  String helloName(String name) {
    return '您好,$name';
  }

  @override
  String get dashSubtitle => '以下是您的会议室动态。';

  @override
  String get noRegionalDirections => '未找到区域局。';

  @override
  String get noNotifications => '暂无通知。';

  @override
  String get structuresLoadError => '无法加载机构。点击重试。';

  @override
  String get editStructure => '编辑机构';

  @override
  String get newStructure => '新建机构';

  @override
  String get codeCdi => 'CDI 代码';

  @override
  String get codeRequired => '请输入代码。';

  @override
  String get noStructures => '尚未登记任何机构。';

  @override
  String get structureRequired => '请选择机构。';

  @override
  String get loadingStructures => '正在加载机构…';

  @override
  String get structure => '机构';

  @override
  String get chooseStructure => '选择机构';

  @override
  String get searchStructure => '搜索机构…';

  @override
  String get noStructureFound => '未找到机构。';

  @override
  String get rejectRequest => '驳回申请';

  @override
  String get rejectReasonOptional => '原因(可选)';

  @override
  String get reject => '驳回';

  @override
  String get validate => '批准';

  @override
  String get reservationRequests => '预订申请';

  @override
  String get iconPending => '待处理图标';

  @override
  String get iconValidated => '已批准图标';

  @override
  String get iconRejected => '已驳回图标';

  @override
  String get request => '申请';

  @override
  String get noReservations => '未找到预订。';

  @override
  String reservationStatusLabel(String status) {
    return '预订状态:$status';
  }

  @override
  String roomNumberFallback(String id) {
    return '会议室 #$id';
  }

  @override
  String reservationStructureLine(String value) {
    return '机构:$value';
  }

  @override
  String reservationDateLine(String date, String start, String end) {
    return '日期:$date($start - $end)';
  }

  @override
  String reservationReasonLine(String reason) {
    return '原因:$reason';
  }

  @override
  String get selectDateSlot => '请选择日期和时间段。';

  @override
  String get endAfterStart => '结束时间必须晚于开始时间。';

  @override
  String get noRoomAvailable => '该时间段没有可用会议室。';

  @override
  String get chooseAvailableRoom => '请选择一个可用会议室。';

  @override
  String get requestSent => '预订申请已发送。';

  @override
  String get requestFailed => '申请失败。';

  @override
  String get newReservationRequest => '新建预订申请';

  @override
  String get date => '日期';

  @override
  String get startTime => '开始';

  @override
  String get endTime => '结束';

  @override
  String get viewAvailableRooms => '查看可用会议室';

  @override
  String get meetingSubject => '会议主题';

  @override
  String get subjectRequired => '请输入主题。';

  @override
  String get organizingStructure => '主办机构';

  @override
  String get sendRequest => '提交申请';

  @override
  String get roomSaved => '会议室已保存。';

  @override
  String get deleteRoom => '删除会议室';

  @override
  String get noRooms => '尚未登记任何会议室。';

  @override
  String roomIcon(String name) {
    return '会议室图标 $name';
  }

  @override
  String get noCategory => '无类别';

  @override
  String roomSubtitle(String city, String status, String category) {
    return '$city - $status($category)';
  }

  @override
  String amountFcfa(String amount) {
    return '$amount FCFA';
  }

  @override
  String get editRoom => '编辑会议室';

  @override
  String get newRoom => '新建会议室';

  @override
  String get roomName => '会议室名称';

  @override
  String get region => '大区';

  @override
  String get province => '省';

  @override
  String get city => '城市';

  @override
  String get location => '位置(楼栋、楼层...)';

  @override
  String get category => '类别';

  @override
  String get regionalDirection => '区域局';

  @override
  String get status => '状态';

  @override
  String get rentalAmountFree => '租金(FCFA,免费填 0)';

  @override
  String get computerCount => '电脑数量';

  @override
  String get equippedComputers => '配备电脑';

  @override
  String get statsTitle => 'GsrApp 统计与分析';

  @override
  String get reservationRequestsTitle => '预订申请';

  @override
  String get successRate => '成功率';

  @override
  String get frequencyByDirection => '各区域局使用情况';

  @override
  String get noReservationsYet => '暂无预订记录。';

  @override
  String requestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个申请',
    );
    return '$_temp0';
  }

  @override
  String get accountCreationFailed => '创建账户失败。';

  @override
  String get userAccountsManagement => '用户账户管理';

  @override
  String get noPendingAccounts => '没有待审批的账户。';

  @override
  String get noStructureShort => '无机构';

  @override
  String get approveAccount => '批准账户';

  @override
  String get rejectAccount => '驳回账户';

  @override
  String get temporaryPassword => '临时密码';

  @override
  String get atLeast6Chars => '至少 8 个字符。';

  @override
  String get role => '角色';

  @override
  String get email => '邮箱';

  @override
  String get connectedAccount => '当前账户';

  @override
  String get appLanguage => '应用语言';

  @override
  String get appTheme => '应用主题';

  @override
  String get darkMode => '深色模式';

  @override
  String get darkModeOn => '已启用深色主题';

  @override
  String get lightModeOn => '已启用浅色主题';

  @override
  String get logoutButtonLabel => '退出登录按钮';

  @override
  String get identifier => '用户名';

  @override
  String get phone => '电话';

  @override
  String get fleetNumberFull => '集团号码';

  @override
  String get language => '语言';

  @override
  String get connChecking => '正在检查…';

  @override
  String get connUnreachable => '无法连接服务器';

  @override
  String get connDbDown => 'API 可访问,数据库不可用';

  @override
  String connOk(int ms) {
    return '已连接到 API 和 MySQL($ms 毫秒)';
  }

  @override
  String get connSemantics => 'API 连接状态';

  @override
  String get connTitle => 'MySQL 连接状态 (dbgsr)';

  @override
  String get retest => '重新测试';

  @override
  String get appVersion => '应用版本';

  @override
  String get aboutDescription => '会议室与预订管理。';

  @override
  String get errTimeout => '服务器响应超时。';

  @override
  String get errSessionExpired => '会话已过期,请重新登录。';

  @override
  String get retry => '重试';

  @override
  String get activateAgentHint => '用户名必须对应已有的 DGI 员工。';

  @override
  String get loadMore => '加载更多';

  @override
  String get changePhoto => '更换照片';

  @override
  String get removePhoto => '删除照片';

  @override
  String get photoUpdateSuccess => '头像已更新。';

  @override
  String get photoUpdateFailed => '照片上传失败。';

  @override
  String get photoRemoveSuccess => '头像已删除。';

  @override
  String get photoInvalidType => '支持的格式:JPEG、PNG、WEBP。';

  @override
  String get photoTooLarge => '照片过大(最大 5 MB)。';
}

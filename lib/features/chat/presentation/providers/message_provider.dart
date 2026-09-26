import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/message_recipient.dart';
import '../../domain/entities/message_thread.dart';
import '../../domain/usecases/get_conversation.dart';
import '../../domain/usecases/get_recipients.dart';
import '../../domain/usecases/get_threads.dart';
import '../../domain/usecases/send_message.dart';
import '../../../../core/network/api_client.dart';

class MessageProvider with ChangeNotifier {
  final GetConversation getConversationUseCase;
  final SendMessage sendMessageUseCase;
  final GetThreads getThreadsUseCase;
  final GetRecipients getRecipientsUseCase;

  MessageProvider({
    required this.getConversationUseCase,
    required this.sendMessageUseCase,
    required this.getThreadsUseCase,
    required this.getRecipientsUseCase,
  });

  List<Message> _messages = [];
  List<MessageThread> _threads = [];
  List<MessageRecipient> _recipients = [];
  bool _isLoading = false;
  String? _error;

  /// Message de la dernière erreur de chargement, null si tout va bien.
  String? get error => _error;
  String? _currentPeerLogin;
  Timer? _pollingTimer;

  List<Message> get messages => _messages;
  List<MessageThread> get threads => _threads;
  List<MessageRecipient> get recipients => _recipients;
  bool get isLoading => _isLoading;

  Future<void> fetchConversation({String? withLogin}) async {
    _currentPeerLogin = withLogin;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _messages = await getConversationUseCase(withLogin: withLogin);
    } catch (e) {
      _error = errorMessageOf(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchThreads() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _threads = await getThreadsUseCase();
    } catch (e) {
      _error = errorMessageOf(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchRecipients() async {
    try {
      _recipients = await getRecipientsUseCase();
    } catch (e) {
      _error = errorMessageOf(e);
    }
    notifyListeners();
  }

  Future<bool> send(String content, {String? recipientLogin}) async {
    final success = await sendMessageUseCase(
      content: content,
      recipientLogin: recipientLogin,
    );
    if (success) {
      await fetchConversation(withLogin: recipientLogin ?? _currentPeerLogin);
    }
    return success;
  }

  void startPolling({Duration interval = const Duration(seconds: 10)}) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      interval,
      (_) => fetchConversation(withLogin: _currentPeerLogin),
    );
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}

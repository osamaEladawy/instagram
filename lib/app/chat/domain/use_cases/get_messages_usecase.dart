

import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessagesUseCase {

  final ChatRepository repository;

  GetMessagesUseCase({required this.repository});

  Stream<List<MessageEntity>> call(MessageEntity message)  {
    return repository.getMessages(message);
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/tutors/models/tutor_model.dart';
import '../../../core/services/chat/models/chat_message_model.dart';
import '../../../core/services/chat/models/conversation_model.dart';
import '../../../core/services/auth/repositories/auth_repository.dart';
import '../../providers/chat_providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final tutorsAsync = ref.watch(tutorsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {
            // TODO: Implementar menú
          },
        ),
        title: const Text(
          'Chat',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          CircleAvatar(
            radius: 18,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=user'),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          
          // Icono de chat grande
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Título
          const Text(
            'Chat',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Subtítulo
          Text(
            'Elige con quien quieres hablar',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Lista de contactos
          Expanded(
            child: tutorsAsync.when(
              data: (tutors) => _buildContactsList(tutors),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar los contactos',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(tutorsProvider);
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList(List<TutorModel> tutors) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tutors.length + 1, // +1 para el contacto de IA
      itemBuilder: (context, index) {
        if (index == 0) {
          // Contacto fijo de IA
          return _buildAiContact();
        } else {
          // Contactos de tutores
          final tutor = tutors[index - 1];
          return _buildTutorItem(tutor);
        }
      },
    );
  }

  Widget _buildAiContact() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF008080), // Color teal para IA
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF008080).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.smart_toy,
            size: 30,
            color: Color(0xFF008080),
          ),
        ),
        title: const Text(
          'Asistente IA',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        subtitle: const Text(
          'Chat inteligente disponible 24/7',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AiChatScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTutorItem(TutorModel tutor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: tutor.fotoPerfil != null && tutor.fotoPerfil!.isNotEmpty
              ? NetworkImage(tutor.fotoPerfil!)
              : null,
          backgroundColor: Colors.grey[300],
          child: tutor.fotoPerfil == null || tutor.fotoPerfil!.isEmpty
              ? Text(
                  tutor.nombre.isNotEmpty ? tutor.nombre[0].toUpperCase() : 'T',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
        title: Text(
          tutor.nombre.isNotEmpty ? tutor.nombre : 'Tutor',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: tutor.especialidad != null && tutor.especialidad!.isNotEmpty
            ? Text(
                tutor.especialidad!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black87,
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TutorChatScreen(tutor: tutor),
            ),
          );
        },
      ),
    );
  }
}

// Pantalla de chat con IA
class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Obtener el userID del usuario actual
      final currentUser = await ref.read(authRepositoryProvider).getCurrentUser();
      
      if (currentUser == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Usuario no autenticado';
        });
        return;
      }

      final userId = currentUser.userId;
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No se pudo obtener el ID del usuario. UID: ${currentUser.uid}';
        });
        return;
      }

      // Cargar historial de chat con IA usando el userID del usuario actual
      final chatHistory = await ref.read(chatHistoryProvider(userId).future);
      
      setState(() {
        _messages.clear();
        _messages.addAll(chatHistory);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar el historial: $e';
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    // Obtener el userID del usuario actual
    final currentUser = await ref.read(authRepositoryProvider).getCurrentUser();
    
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario no autenticado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userId = currentUser.userId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo obtener el ID del usuario. UID: ${currentUser.uid}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Agregar mensaje localmente inmediatamente
    final localMessage = ChatMessageModel(
      id: DateTime.now().toString(),
      mensaje: messageText,
      estado: 'enviado',
      fecha: DateTime.now(),
      usuarioId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isAiResponse: false,
    );

    setState(() {
      _messages.add(localMessage);
    });

    try {
      // Enviar mensaje a IA usando el endpoint de chat
      final response = await ref.read(chatServiceProvider).sendChatMessage(
        mensaje: messageText,
        usuarioId: userId,
      );

      // Actualizar el mensaje con la respuesta del servidor
      if (response['data'] != null && response['data']['message'] != null) {
        final serverMessage = ChatMessageModel.fromJson(response['data']['message']);
        
        setState(() {
          // Reemplazar el mensaje local con el del servidor
          final index = _messages.indexWhere((m) => m.id == localMessage.id);
          if (index != -1) {
            _messages[index] = serverMessage;
          }
        });

        // Si hay respuesta de IA, agregarla
        if (response['data']['ai_response'] != null) {
          final aiResponse = ChatMessageModel.fromJson(response['data']['ai_response']);
          setState(() {
            _messages.add(aiResponse);
          });
        }
      }
    } catch (e) {
      // Marcar mensaje como fallido
      setState(() {
        final index = _messages.indexWhere((m) => m.id == localMessage.id);
        if (index != -1) {
          _messages[index] = localMessage.copyWith(estado: 'fallido');
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar mensaje: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF008080),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Chat con IA',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              size: 20,
              color: Color(0xFF008080),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Área de mensajes
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? _buildErrorWidget()
                      : _buildMessagesList(),
            ),
          ),
          
          // Área de input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar mensajes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadChatHistory,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    if (_messages.isEmpty) {
      return const Center(
        child: Text(
          '¡Hola! Soy tu asistente IA.\n¿En qué puedo ayudarte hoy?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessageModel message) {
    final isFromUser = !message.isAiResponse;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isFromUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          if (!isFromUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF008080),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isFromUser 
                    ? const Color(0xFF008080) // Teal para mensajes del usuario
                    : Colors.white, // Blanco para mensajes de IA
                borderRadius: BorderRadius.circular(20),
                border: !isFromUser ? Border.all(color: const Color(0xFF008080)) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.mensaje,
                    style: TextStyle(
                      color: isFromUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.fecha),
                        style: TextStyle(
                          color: isFromUser ? Colors.white70 : Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                      if (isFromUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          _getStatusIcon(message.estado),
                          size: 12,
                          color: Colors.white70,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isFromUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'enviado':
        return Icons.check;
      case 'entregado':
        return Icons.done_all;
      case 'leido':
        return Icons.done_all;
      case 'fallido':
        return Icons.error;
      default:
        return Icons.schedule;
    }
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Escribe tu mensaje...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF008080),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

// Pantalla de chat con tutor (usando conversaciones 1:1)
class TutorChatScreen extends ConsumerStatefulWidget {
  final TutorModel tutor;

  const TutorChatScreen({super.key, required this.tutor});

  @override
  ConsumerState<TutorChatScreen> createState() => _TutorChatScreenState();
}

class _TutorChatScreenState extends ConsumerState<TutorChatScreen> {
  bool _showContactInfo = false;
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _conversationId;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  Future<void> _loadConversation() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Obtener el userID del usuario actual
      final currentUser = await ref.read(authRepositoryProvider).getCurrentUser();
      
      if (currentUser == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Usuario no autenticado';
        });
        return;
      }

      final userId = currentUser.userId;
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No se pudo obtener el ID del usuario. UID: ${currentUser.uid}';
        });
        return;
      }

      // Obtener conversaciones del usuario
      final conversations = await ref.read(userConversationsProvider(userId).future);
      
      // Buscar conversación existente con este tutor
      final existingConversation = conversations.firstWhere(
        (conv) => conv.participant1Id == userId && conv.participant2Id == widget.tutor.id ||
                   conv.participant1Id == widget.tutor.id && conv.participant2Id == userId,
        orElse: () => ConversationModel(
          id: '',
          participant1Id: userId,
          participant2Id: widget.tutor.id,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: true,
        ),
      );

      if (existingConversation.id.isNotEmpty) {
        _conversationId = existingConversation.id;
        
        // Cargar mensajes de la conversación
        final conversationData = await ref.read(conversationMessagesProvider({
          'conversationId': existingConversation.id,
          'usuarioId': userId,
        }).future);
        
        if (conversationData['data'] != null && conversationData['data']['messages'] != null) {
          final messages = conversationData['data']['messages'] as List;
          setState(() {
            _messages.clear();
            _messages.addAll(messages.map((json) => ChatMessageModel.fromJson(json)));
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _messages.clear();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar la conversación: $e';
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    // Obtener el userID del usuario actual
    final currentUser = await ref.read(authRepositoryProvider).getCurrentUser();
    
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario no autenticado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userId = currentUser.userId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo obtener el ID del usuario. UID: ${currentUser.uid}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Agregar mensaje localmente inmediatamente
    final localMessage = ChatMessageModel(
      id: DateTime.now().toString(),
      mensaje: messageText,
      estado: 'enviado',
      fecha: DateTime.now(),
      usuarioId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isAiResponse: false,
      recipientId: widget.tutor.id,
      conversationId: _conversationId,
    );

    setState(() {
      _messages.add(localMessage);
    });

    try {
      // Enviar mensaje usando el endpoint de conversaciones 1:1
      final serverMessage = await ref.read(chatServiceProvider).sendPrivateMessage(
        mensaje: messageText,
        usuarioId: userId,
        recipientId: widget.tutor.id,
        conversationId: _conversationId,
      );

      // Si no teníamos conversationId, obtenerlo del mensaje del servidor
      if (_conversationId == null && serverMessage.conversationId != null) {
        _conversationId = serverMessage.conversationId;
      }

      setState(() {
        // Reemplazar el mensaje local con el del servidor
        final index = _messages.indexWhere((m) => m.id == localMessage.id);
        if (index != -1) {
          _messages[index] = serverMessage;
        }
      });
    } catch (e) {
      // Marcar mensaje como fallido
      setState(() {
        final index = _messages.indexWhere((m) => m.id == localMessage.id);
        if (index != -1) {
          _messages[index] = localMessage.copyWith(estado: 'fallido');
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar mensaje: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            const Icon(Icons.home, size: 16, color: Colors.grey),
            const Text(' > ', style: TextStyle(color: Colors.grey)),
            const Text('Chat', style: TextStyle(color: Colors.grey)),
            const Text(' > ', style: TextStyle(color: Colors.grey)),
            const Icon(Icons.person, size: 16, color: Colors.blue),
            const Text(' Chat con ', style: TextStyle(color: Colors.grey)),
            Text(
              widget.tutor.nombre.isNotEmpty ? widget.tutor.nombre : 'Tutor',
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=user'),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Header del chat con información del contacto
          _buildChatHeader(),
          
          // Información del contacto (expandible)
          if (_showContactInfo) _buildContactInfo(),
          
          // Área de mensajes
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? _buildErrorWidget()
                      : _buildMessagesList(),
            ),
          ),
          
          // Área de input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar mensajes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadConversation,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    if (_messages.isEmpty) {
      return const Center(
        child: Text(
          'No hay mensajes aún.\n¡Inicia la conversación!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: widget.tutor.fotoPerfil != null && widget.tutor.fotoPerfil!.isNotEmpty
                ? NetworkImage(widget.tutor.fotoPerfil!)
                : null,
            backgroundColor: Colors.grey[300],
            child: widget.tutor.fotoPerfil == null || widget.tutor.fotoPerfil!.isEmpty
                ? Text(
                    widget.tutor.nombre.isNotEmpty ? widget.tutor.nombre[0].toUpperCase() : 'T',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.tutor.nombre.isNotEmpty ? widget.tutor.nombre : 'Tutor',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _showContactInfo ? Icons.keyboard_arrow_up : Icons.info_outline,
              color: Colors.black87,
            ),
            onPressed: () {
              setState(() {
                _showContactInfo = !_showContactInfo;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF008080), // Color teal
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información del tutor',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: widget.tutor.fotoPerfil != null && widget.tutor.fotoPerfil!.isNotEmpty
                    ? NetworkImage(widget.tutor.fotoPerfil!)
                    : null,
                backgroundColor: Colors.white,
                child: widget.tutor.fotoPerfil == null || widget.tutor.fotoPerfil!.isEmpty
                    ? Text(
                        widget.tutor.nombre.isNotEmpty ? widget.tutor.nombre[0].toUpperCase() : 'T',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tutor.nombre.isNotEmpty ? widget.tutor.nombre : 'Tutor',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (widget.tutor.telefono != null && widget.tutor.telefono!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.tutor.telefono!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                    if (widget.tutor.correo != null && widget.tutor.correo!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.tutor.correo!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'WhatsApp',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16, color: Colors.black87),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Correo',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16, color: Colors.black87),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel message) {
    final isFromUser = message.usuarioId != widget.tutor.id;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isFromUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          if (!isFromUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: widget.tutor.fotoPerfil != null && widget.tutor.fotoPerfil!.isNotEmpty
                  ? NetworkImage(widget.tutor.fotoPerfil!)
                  : null,
              backgroundColor: Colors.grey[300],
              child: widget.tutor.fotoPerfil == null || widget.tutor.fotoPerfil!.isEmpty
                  ? Text(
                      widget.tutor.nombre.isNotEmpty ? widget.tutor.nombre[0].toUpperCase() : 'T',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isFromUser 
                    ? const Color(0xFF2196F3) // Azul para mensajes del usuario
                    : const Color(0xFFE91E63), // Rosa para mensajes recibidos
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.mensaje,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.fecha),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                      if (isFromUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          _getStatusIcon(message.estado),
                          size: 12,
                          color: Colors.white70,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isFromUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'enviado':
        return Icons.check;
      case 'entregado':
        return Icons.done_all;
      case 'leido':
        return Icons.done_all;
      case 'fallido':
        return Icons.error;
      default:
        return Icons.schedule;
    }
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Escribe tu mensaje...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF2196F3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
} 
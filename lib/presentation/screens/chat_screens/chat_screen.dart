import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/tutors/models/tutor_model.dart';
import '../../../core/services/chat/models/chat_message_model.dart';
import '../../../core/services/chat/models/conversation_model.dart';
import '../../../core/services/auth/repositories/auth_repository.dart';
import '../../providers/simple_auth_providers.dart';
import '../../providers/chat_providers.dart';
import '../../../core/services/api_service_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final tutorsAsync = ref.watch(tutorsProvider);
    // Obtener el usuario actual (userId de la API)
    final currentUserAsync = ref.watch(authRepositoryProvider).getCurrentUser().asStream();

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
          // Solo la lista de conversaciones (elimina la de contactos)
          Expanded(
            child: tutorsAsync.when(
              data: (tutors) => StreamBuilder(
                stream: currentUserAsync,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const SizedBox();
                  }
                  final userId = snapshot.data?.userId;
                  if (userId == null) return const SizedBox();
                  final conversationsAsync = ref.watch(userConversationsProvider(userId));
                  return conversationsAsync.when(
                    data: (conversations) => _buildConversationsList(conversations, userId),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text('Error al cargar conversaciones: $error')),
                  );
                },
              ),
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

  Widget _buildConversationsList(List<ConversationModel> conversations, String userId) {
    print('Conversaciones recibidas de la API para $userId: ${conversations.length}');
    for (var c in conversations) {
      print(' - ID: \'${c.id}\' | ${c.participant1Id} <-> ${c.participant2Id}');
    }
    final isAlumno = ref.watch(isAlumnoProvider);
    final tutorsAsync = ref.watch(tutorsProvider);
    final apiService = ref.read(apiServiceProvider);
    // Caché local para alumnos
    final Map<String, Map<String, dynamic>> alumnoCache = {};
    // --- Agregar conversación especial de IA al inicio ---
    final iaConversation = ConversationModel(
      id: 'ia_chat',
      participant1Id: userId,
      participant2Id: 'asistente_ia',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    );
    final allConversations = [iaConversation, ...conversations];
    // ---
    return tutorsAsync.when(
      data: (tutors) {
        // Mostrar todas las conversaciones (más la de IA) sin filtros
        final filteredConversations = allConversations;
        print('Conversaciones que se muestran en pantalla: ${filteredConversations.length}');
        for (var c in filteredConversations) {
          print(' - MOSTRADA: \'${c.id}\' | ${c.participant1Id} <-> ${c.participant2Id}');
        }
        return ListView.builder(
          // Permitir scroll independiente
          // shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredConversations.length,
          itemBuilder: (context, index) {
            final conversation = filteredConversations[index];
            print('Construyendo widget para conversación: ${conversation.id} | ${conversation.participant1Id} <-> ${conversation.participant2Id}');
            // --- Si es la conversación de IA, renderiza especial ---
            if (conversation.id == 'ia_chat') {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF008080),
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
                ),
              );
            }
            // --- Resto de conversaciones normales ---
            final otherId = conversation.participant1Id == userId ? conversation.participant2Id : conversation.participant1Id;
            final tutor = tutors.firstWhere(
              (t) => t.id == otherId,
              orElse: () => TutorModel(
                id: otherId,
                nombre: '',
                correo: '',
                fotoPerfil: null,
                telefono: null,
                especialidad: null,
                descripcion: null,
                isOnline: null,
                createdAt: null,
                updatedAt: null,
              ),
            );
            final isOtherTutor = tutors.any((t) => t.id == otherId);
            // El future ahora siempre consulta el perfil del otro usuario (o el propio si es consigo mismo)
            return FutureBuilder<Map<String, dynamic>?>(
              future: (alumnoCache[otherId] != null
                  ? Future.value(alumnoCache[otherId])
                  : apiService.getUserProfile(otherId).then((data) {
                      alumnoCache[otherId] = data;
                      return data;
                    })),
              builder: (context, snapshot) {
                String nombre = tutor.nombre;
                String? fotoPerfil = tutor.fotoPerfil;
                // Si hay datos de la API (ya sea alumno, tutor o uno mismo), úsalos
                if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                  nombre = snapshot.data!['nombre'] ?? snapshot.data!['email'] ?? (otherId == userId ? 'Tú mismo' : '');
                  fotoPerfil = snapshot.data!['fotoPerfil'] ?? null;
                }
                // Si no hay nombre, intenta usar el email o un texto por defecto
                if ((nombre.isEmpty || nombre == 'Usuario') && snapshot.hasData && snapshot.data != null) {
                  nombre = snapshot.data!['email'] ?? (otherId == userId ? 'Tú mismo' : '');
                }
                if (nombre.isEmpty) {
                  nombre = otherId == userId ? 'Tú mismo' : 'Sin nombre';
                }
                print('Construyendo Container para conversación: ${conversation.id} | Nombre: $nombre | otherId: $otherId');
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
                      backgroundImage: fotoPerfil != null && fotoPerfil.isNotEmpty
                          ? NetworkImage(fotoPerfil)
                          : null,
                      backgroundColor: Colors.grey[300],
                      child: fotoPerfil == null || fotoPerfil.isEmpty
                          ? Text(
                              nombre.isNotEmpty ? nombre[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    title: Text(
                      nombre.isNotEmpty ? nombre : (otherId == userId ? 'Tú mismo' : 'Usuario'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text('ID: ${conversation.id}'),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black87,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationScreen(
                            conversation: conversation,
                            otherUser: TutorModel(
                              id: otherId,
                              nombre: nombre,
                              correo: '',
                              fotoPerfil: fotoPerfil,
                              telefono: null,
                              especialidad: null,
                              descripcion: null,
                              isOnline: null,
                              createdAt: null,
                              updatedAt: null,
                            ),
                            currentUserId: userId,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error al cargar tutores: $error')),
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
    // Limpiar cache global si existe
    if (mounted) {
      try {
        // Si tienes acceso a alumnoCache aquí, límpialo
        // Si no, ignora este bloque y solo deja el comentario
        // alumnoCache.clear();
      } catch (_) {}
    }
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
                    if (widget.tutor.correo.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.tutor.correo,
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

// Pantalla genérica de conversación
class ConversationScreen extends ConsumerStatefulWidget {
  final ConversationModel conversation;
  final TutorModel otherUser;
  final String currentUserId;

  const ConversationScreen({
    Key? key,
    required this.conversation,
    required this.otherUser,
    required this.currentUserId,
  }) : super(key: key);

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final conversationData = await ref.read(conversationMessagesProvider({
        'conversationId': widget.conversation.id,
        'usuarioId': widget.currentUserId,
      }).future);
      if (conversationData['data'] != null && conversationData['data']['messages'] != null) {
        final messages = conversationData['data']['messages'] as List;
        setState(() {
          _messages.clear();
          _messages.addAll(messages.map((json) => ChatMessageModel.fromJson(json)));
          _isLoading = false;
        });
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
    final localMessage = ChatMessageModel(
      id: DateTime.now().toString(),
      mensaje: messageText,
      estado: 'enviado',
      fecha: DateTime.now(),
      usuarioId: widget.currentUserId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isAiResponse: false,
      recipientId: widget.otherUser.id,
      conversationId: widget.conversation.id,
    );
    setState(() {
      _messages.add(localMessage);
    });
    try {
      final serverMessage = await ref.read(chatServiceProvider).sendPrivateMessage(
        mensaje: messageText,
        usuarioId: widget.currentUserId,
        recipientId: widget.otherUser.id,
        conversationId: widget.conversation.id,
      );
      setState(() {
        final index = _messages.indexWhere((m) => m.id == localMessage.id);
        if (index != -1) {
          _messages[index] = serverMessage;
        }
      });
    } catch (e) {
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
            CircleAvatar(
              radius: 16,
              backgroundImage: widget.otherUser.fotoPerfil != null && widget.otherUser.fotoPerfil!.isNotEmpty
                  ? NetworkImage(widget.otherUser.fotoPerfil!)
                  : null,
              backgroundColor: Colors.grey[300],
              child: widget.otherUser.fotoPerfil == null || widget.otherUser.fotoPerfil!.isEmpty
                  ? Text(
                      widget.otherUser.nombre.isNotEmpty ? widget.otherUser.nombre[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              widget.otherUser.nombre.isNotEmpty ? widget.otherUser.nombre : 'Usuario',
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : _buildMessagesList(),
            ),
          ),
          _buildMessageInput(),
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
        final isFromUser = message.usuarioId == widget.currentUserId;
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
                  backgroundImage: widget.otherUser.fotoPerfil != null && widget.otherUser.fotoPerfil!.isNotEmpty
                      ? NetworkImage(widget.otherUser.fotoPerfil!)
                      : null,
                  backgroundColor: Colors.grey[300],
                  child: widget.otherUser.fotoPerfil == null || widget.otherUser.fotoPerfil!.isEmpty
                      ? Text(
                          widget.otherUser.nombre.isNotEmpty ? widget.otherUser.nombre[0].toUpperCase() : 'U',
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
                        ? const Color(0xFF2196F3)
                        : const Color(0xFFE91E63),
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
      },
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
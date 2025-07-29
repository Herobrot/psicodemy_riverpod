class ApiRoutes {
  // Rutas del microservicio de autenticación
  static const String baseAuth = '/auth';
  static const String authHealth = '$baseAuth/health';

  static const String authValidate = '$baseAuth/validate';
  static const String authFirebase = '$baseAuth/firebase';

  // Ruta dinámica para /auth/users/{userType}
  static String authUsers(String userType) => '$baseAuth/users/$userType';
  // Ruta dinámica para /auth/profile/{userId}
  static String authProfileUser(String userId) => '$baseAuth/profile/$userId';

  // Rutas del microservicio de citas
  static const String baseAppointments = '/s1/appointments';
  static const String healthS1 = '/s1/health';

  // Ruta dinámica para /s1/appoinments/{id}
  static String appointmentId(String id) => '$baseAppointments/$id';

  // Ruta dinámica para /s1/appoinments/{id}/status
  static String appointmentIdStatus(String id) =>
      '$baseAppointments/$id/status';

  // Rutas del microservicio de chat
  static const String baseChat = '/s3/chat';
  static const String chatHealth = '$baseChat/health';
  static const String chatMessage = '$baseChat/message';
  static const String chatStatus = '$baseChat/status';
  static const String chatAiInfo = '$baseChat/ai/info';
  static const String chatAiTest = '$baseChat/ai/test';
  static const String chatAttempt = '$baseChat/attempt';

  // Rutas dinámicas para chat
  static String chatHistory(String estudianteId) =>
      '$baseChat/history/$estudianteId';
  static String chatHistoryMessages(String estudianteId) =>
      '$baseChat/history/$estudianteId/messages';
  static String chatAttempts(String estudianteId) =>
      '$baseChat/attempts/$estudianteId';

  // Rutas del microservicio de conversaciones
  static const String baseConversations = '/s3/conversations';
  static const String conversationsMessage = '$baseConversations/message';
  static const String conversationsStatus = '$baseConversations/status';

  // Rutas dinámicas para conversaciones
  static String userConversations(String usuarioId) =>
      '$baseConversations/$usuarioId';
  static String conversationMessages(String conversationId) =>
      '$baseConversations/$conversationId/messages';

  // Rutas de WebSocket
  static const String wsInfo = '/s3/ws-info';
}

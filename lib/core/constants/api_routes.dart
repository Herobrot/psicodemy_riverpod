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
  static String appointmentIdStatus(String id) => '$baseAppointments/$id/status';
}
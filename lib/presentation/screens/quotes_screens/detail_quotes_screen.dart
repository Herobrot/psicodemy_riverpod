import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../forum_screens/forum_screen.dart';
import '../home_screens/home_screen.dart';

class DetalleCitaScreen extends StatefulWidget {
  const DetalleCitaScreen({super.key});

  @override
  State<DetalleCitaScreen> createState() => _DetalleCitaScreenState();
}

class _DetalleCitaScreenState extends State<DetalleCitaScreen> {

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Cita con el Mtro Ali', 
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // TODO: Ir a perfil
              },
              child: CircleAvatar(
                radius: 18,
                backgroundImage: user?.photoURL != null 
                  ? NetworkImage(user!.photoURL!)
                  : const NetworkImage('https://lh3.googleusercontent.com/a/default-user=s96-c'),
                child: user?.photoURL == null 
                  ? Text(
                      user?.email?.isNotEmpty == true 
                        ? user!.email![0].toUpperCase() 
                        : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF5CC9C0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=8'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Informacion del tutor', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Ali Santiago Zahun'),
                        Text('+52 9614389077'),
                        Text('Ali@ids.upchiapas.edu.mx'),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                        child: const Text('Whatsapp →', style: TextStyle(color: Color(0xFF5CC9C0))),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                        child: const Text('Correo →', style: TextStyle(color: Color(0xFF5CC9C0))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tu cita fue el 14 de Abril del 2025', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Estado: Cancelado/Aprobado/Realizada/Reprogramada', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Por Hacer', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('• Hablar con el profe alonso para la recovnalidacion de la materia de redes 2'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF366A73),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Terminar tareas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/notification_providers.dart';

class NotificationInitializer extends ConsumerStatefulWidget {
  const NotificationInitializer({super.key});

  @override
  ConsumerState<NotificationInitializer> createState() => _NotificationInitializerState();
}

class _NotificationInitializerState extends ConsumerState<NotificationInitializer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotifications();
    });
  }

  Future<void> _initializeNotifications() async {
    // Initialize notifications
    await ref.read(notificationStateProvider.notifier).initializeNotifications();
    
    // Listen to foreground messages
    ref.listen<AsyncValue<Map<String, dynamic>>>(
      foregroundMessageProvider,
      (previous, next) {
        next.whenData((message) {
          ref.read(notificationStateProvider.notifier).handleForegroundMessage(message);
        });
      },
    );
    
    // Listen to messages that opened the app
    ref.listen<AsyncValue<Map<String, dynamic>>>(
      messageOpenedAppProvider,
      (previous, next) {
        next.whenData((message) {
          // Handle message that opened the app
          print('Message opened app: $message');
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationStateProvider);
    
    if (notificationState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (notificationState.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${notificationState.error}'),
              ElevatedButton(
                onPressed: () => _initializeNotifications(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    return HomeScreen();
  }
}*/
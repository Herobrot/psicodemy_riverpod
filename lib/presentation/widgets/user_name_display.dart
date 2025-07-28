import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/users/user_mapping_service.dart';

class UserNameDisplay extends ConsumerWidget {
  final String userId;
  final TextStyle? style;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final String? prefix;
  final String? suffix;
  final bool overflowVisible;
  final TextOverflow overflow;

  const UserNameDisplay({
    super.key,
    required this.userId,
    this.style,
    this.loadingWidget,
    this.errorWidget,
    this.prefix,
    this.suffix,
    this.overflowVisible = true,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('🔍 UserNameDisplay: Construyendo widget para userId: $userId');
    final userNameAsync = ref.watch(userNameProvider(userId));

    return userNameAsync.when(
      data: (nombre) {
        print('✅ UserNameDisplay: Nombre obtenido para $userId: $nombre');
        final fullText = '${prefix ?? ''}$nombre${suffix ?? ''}';
        
        if (overflowVisible) {
          return Text(
            fullText,
            style: style ?? DefaultTextStyle.of(context).style,
            overflow: overflow,
            maxLines: 1,
          );
        } else {
          return RichText(
            text: TextSpan(
              style: style ?? DefaultTextStyle.of(context).style,
              children: [
                if (prefix != null) TextSpan(text: prefix),
                TextSpan(text: nombre),
                if (suffix != null) TextSpan(text: suffix),
              ],
            ),
          );
        }
      },
      loading: () {
        print('⏳ UserNameDisplay: Cargando nombre para $userId');
        return loadingWidget ?? 
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            );
      },
      error: (error, stack) {
        print('❌ UserNameDisplay: Error obteniendo nombre para $userId: $error');
        return errorWidget ?? 
            Text(
              userId, // Fallback al ID si hay error
              style: style,
            );
      },
    );
  }
}

// Widget para mostrar múltiples nombres de usuario
class MultipleUserNamesDisplay extends ConsumerWidget {
  final List<String> userIds;
  final TextStyle? style;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final String separator;
  final String? prefix;
  final String? suffix;

  const MultipleUserNamesDisplay({
    super.key,
    required this.userIds,
    this.style,
    this.loadingWidget,
    this.errorWidget,
    this.separator = ', ',
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNamesAsync = ref.watch(userNamesProvider(userIds));

    return userNamesAsync.when(
      data: (userNames) {
        final names = userIds.map((id) => userNames[id] ?? id).join(separator);
        return RichText(
          text: TextSpan(
            style: style ?? DefaultTextStyle.of(context).style,
            children: [
              if (prefix != null) TextSpan(text: prefix),
              TextSpan(text: names),
              if (suffix != null) TextSpan(text: suffix),
            ],
          ),
        );
      },
      loading: () => loadingWidget ?? 
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      error: (_, __) => errorWidget ?? 
          Text(
            userIds.join(separator), // Fallback a los IDs si hay error
            style: style,
          ),
    );
  }
} 
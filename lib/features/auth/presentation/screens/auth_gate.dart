import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'auth_screen.dart';

/// Watches Supabase auth state and swaps between [AuthScreen] and the
/// signed-in app ([child]) live — no manual navigation calls needed on
/// sign-in/out, since [authStateProvider] already reacts to those.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => const AuthScreen(),
      data: (state) {
        final signedIn = state.session != null;
        return signedIn ? child : const AuthScreen();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/feautures/auth/presentation/providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the authentication state (UserModel? from our authState provider)
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Call the signOut method from our AuthController
              await ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: authState.when(
        data: (user) {
          if (user == null) return const Center(child: Text("No user found"));
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (user.photoUrl != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl!),
                    radius: 40,
                  ),
                const SizedBox(height: 16),
                Text("Welcome, ${user.displayName}",
                    style: const TextStyle(fontSize: 20)),
                Text("Email: ${user.email}"),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // For example, navigate to your notes page using GoRouter:
                    // context.go('/notes');
                  },
                  child: const Text("Go to Notes"),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
      ),
    );
  }
}

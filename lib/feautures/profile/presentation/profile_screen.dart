import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_notes_flutter/common/my_button.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/feautures/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
    static const pageName = 'profile';
  static const pagePath = '/profile';

  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: MyText('Profile', fontSize: 22, fontWeight: FontWeight.bold),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        user?.photoUrl != null
                            ? NetworkImage(user!.photoUrl!)
                            : null,
                    child:
                        user?.photoUrl == null
                            ? const Icon(
                              LineIcons.user,
                              size: 60,
                              color: Colors.grey,
                            )
                            : null,
                  ),
                ),
                const SizedBox(height: 16),
                MyText(
                  user?.displayName ?? 'No Name',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                MyText(
                  user?.email ?? 'No Email',
                  fontSize: 16,
                  color: Colors.grey,
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(LineIcons.userEdit),
                  title: MyText('Edit Profile'),
                  trailing: const Icon(LineIcons.angleRight),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(LineIcons.lock),
                  title: MyText('Change Password'),
                  trailing: const Icon(LineIcons.angleRight),
                  onTap: () {},
                ),
                const Spacer(),
                MyButton(
                  text: 'Logout',
                  buttonColor: Colors.red,
                  onPressed:
                      () => ref.read(authControllerProvider.notifier).signOut(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

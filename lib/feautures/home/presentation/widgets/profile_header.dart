import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/core/constants.dart';
import 'package:my_notes_flutter/feautures/auth/presentation/providers/auth_provider.dart';

class ProfileHeader extends ConsumerStatefulWidget {
  const ProfileHeader({super.key});

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).value;

    return Row(
      children: [
        CircleAvatar(
          backgroundImage:
              user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
        ),
        8.width,
        MyText(
          user?.displayName ?? "Guest",
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
        Spacer(),
        Stack(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black87, // Background color
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                style: ButtonStyle(),
                icon: Icon(LineIcons.bell, color: Colors.white),
                onPressed: () {
                  ref.read(authControllerProvider.notifier).signOut();
                },
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Visibility(
                visible: true, // Replace with actual state logic
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red, // Notification dot
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

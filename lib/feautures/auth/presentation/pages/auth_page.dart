import 'dart:async';
import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_notes_flutter/common/my_button.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/common/my_textformfield.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_notes_flutter/core/constants.dart';
import '../providers/auth_provider.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});
  static const pageName = 'auth';
  static const pagePath = '/auth';

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.logScreenView(screenName: 'Auth Page!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/notes_2.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                blendMode: BlendMode.srcIn,
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black12.withValues(alpha: .33),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 600,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 250, // Adjust this width based on the longest word
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center, // Ensures "Be" stays at the left
                      children: <Widget>[
                        MyText(
                          'Be',
                          fontSize: 25.0,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(width: 5),
                        SizedBox(
                          width: 180,
                          height: 130, // Set a fixed width to prevent shifting
                          child: DefaultTextStyle(
                            softWrap: true,
                            textAlign: TextAlign.left,
                            textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                            ),
                            style: GoogleFonts.aDLaMDisplay(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                RotateAnimatedText(
                                  'UNSTOPPABLE',
                                  rotateOut: true,
                                ),
                                RotateAnimatedText(
                                  'PRODUCTIVE',
                                  rotateOut: true,
                                ),
                                RotateAnimatedText(
                                  'INNOVATIVE',
                                  rotateOut: true,
                                ),
                              ],
                              onTap: () {
                                print("Tap Event");
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  16.height,
                  SegmentedButton<int>(
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.grey.shade400.withValues(
                        alpha: .5,
                      ),
                      foregroundColor: Colors.grey,
                      selectedForegroundColor: Colors.black,
                      selectedBackgroundColor: Colors.teal.withValues(
                        alpha: .75,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    segments: const <ButtonSegment<int>>[
                      ButtonSegment<int>(
                        value: 0,
                        label: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: MyText('Login', fontWeight: FontWeight.w600),
                        ),
                      ),
                      ButtonSegment<int>(
                        value: 1,
                        label: MyText('Register', fontWeight: FontWeight.w600),
                      ),
                    ],
                    selected: {isLogin ? 0 : 1},
                    onSelectionChanged: (Set<int> newSelection) {
                      setState(() {
                        isLogin = newSelection.first == 0;
                      });
                    },
                  ),
                  16.height,
                  Divider(color: Colors.black.withValues(alpha: .35)),
                  16.height,
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 350),
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1, .1),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInCubic,
                            ),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child:
                        isLogin
                            ? _buildLoginForm(context, ref)
                            : _buildRegisterForm(context, ref),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, WidgetRef ref) {
    final emailTextController = TextEditingController();
    final passwordTextController = TextEditingController();
    return Column(
      key: ValueKey('login_form'),
      children: [
        MyTextFormField(hintText: 'Email', controller: emailTextController),
        SizedBox(height: 16),
        MyTextFormField(
          hintText: 'Password',
          obscureText: true,
          controller: passwordTextController,
        ),
        SizedBox(height: 16),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withValues(alpha: .75),
              shape: BoxShape.circle,
            ),
            child:
                isLoading
                    ? CircularProgressIndicator.adaptive()
                    : Icon(LineIcons.arrowRight, color: Colors.black),
          ),
          // text: 'Sign In with Email',
          onTap: () async {
            setState(() => isLoading = true);
            await Future.delayed(Duration(seconds: 2));
            ref
                .read(authControllerProvider.notifier)
                .signInWithEmail(
                  emailTextController.text,
                  passwordTextController.text,
                );
            setState(() => isLoading = false);
          },
        ),
        SizedBox(height: 8),
        _buildGoogleSignInButton(ref),
      ],
    );
  }

  Widget _buildRegisterForm(BuildContext context, WidgetRef ref) {
    final emailTextController = TextEditingController();
    final passwordTextController = TextEditingController();
    return Column(
      key: ValueKey('register_form'),
      children: [
        MyTextFormField(hintText: 'Email'),
        SizedBox(height: 16),
        MyTextFormField(hintText: 'Password', obscureText: true),
        SizedBox(height: 16),
        MyTextFormField(hintText: 'Confirm Password', obscureText: true),
        SizedBox(height: 16),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withValues(alpha: .75),
              shape: BoxShape.circle,
            ),
            child:
                isLoading
                    ? CircularProgressIndicator.adaptive()
                    : Icon(LineIcons.arrowRight, color: Colors.black),
          ),
          // text: 'Sign In with Email',
          onTap: () async {
            setState(() => isLoading = true);
            await Future.delayed(Duration(seconds: 2));
            ref
                .read(authControllerProvider.notifier)
                .registerWithEmail(
                  emailTextController.text,
                  passwordTextController.text,
                );
            setState(() => isLoading = false);
          },
        ),

        SizedBox(height: 8),
        isLoading
            ? CircularProgressIndicator.adaptive()
            : _buildGoogleSignInButton(ref),
      ],
    );
  }

  Widget _buildGoogleSignInButton(WidgetRef ref) {
    return Column(
      children: [
        Divider(color: Colors.black.withValues(alpha: .35)),

        SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            setState(() => isLoading = true);
            await Future.delayed(Duration(seconds: 2));
            ref.read(authControllerProvider.notifier).signInWithGoogle();
            setState(() => isLoading = false);
          },
          child:
              isLoading
                  ? CircularProgressIndicator.adaptive()
                  : SizedBox(
                    width: 175,
                    child: Image.asset(
                      'assets/images/ctn_with_google.png',
                      fit: BoxFit.cover,
                    ),
                  ),
        ),
      ],
    );
  }
}

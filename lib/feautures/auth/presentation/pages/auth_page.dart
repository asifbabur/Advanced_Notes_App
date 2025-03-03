import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/common/my_button.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/common/my_textformfield.dart';
import 'package:my_notes_flutter/core/constants.dart';
import '../providers/auth_provider.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});
  static const pageName = 'auth';
  static const pagePath = '/auth';

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  bool isLogin = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAnalytics.instance.logScreenView(screenName: 'Auth Page!');
  }

  @override
  Widget build(BuildContext context) {
    final authStateAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const MyText('Authentication', fontSize: 24)),
      body: authStateAsync.when(
        data: (user) {
          if (user != null) {
            return Center(child: Text('Welcome, ${user.displayName}'));
          } else {
            return isLogin
                ? _buildLoginForm(context, ref)
                : _buildRegisterForm(context, ref);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          MyTextFormField(hintText: 'Email', controller: emailController),
          16.height,
          MyTextFormField(
            hintText: 'Password',
            controller: passwordController,
            obscureText: true,
          ),
          16.height,
          MyButton(
            icon: Icon(Icons.email, color: Colors.white),
            text: 'Sign In with Email',
            onPressed: () async {
              try {
                await ref
                    .read(authControllerProvider.notifier)
                    .signInWithEmail(
                      emailController.text,
                      passwordController.text,
                    );
              } catch (e, stack) {
                FirebaseAnalytics.instance.logEvent(
                  name: 'exception',
                  parameters: {
                    'error': e.toString(),
                    'stack': stack.toString(),
                  },
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Sign in failed: $e')));
              }
            },
          ),
          8.height,
          MyButton(
            icon: Image.asset(
              'assets/images/google_icon.png',
              fit: BoxFit.contain,
            ),
            text: 'Sign In with Google',
            onPressed: () async {
              try {
                await ref
                    .read(authControllerProvider.notifier)
                    .signInWithGoogle();
              } catch (e, stack) {
                FirebaseAnalytics.instance.logEvent(
                  name: 'exception',
                  parameters: {
                    'error': e.toString(),
                    'stack': stack.toString(),
                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Google sign in failed: $e')),
                );
              }
            },
          ),
          16.height,
          GestureDetector(
            onTap: () {
              setState(() {
                isLogin = false;
              });
            },
            child: Text(
              'New member? Register',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          MyTextFormField(hintText: 'Email', controller: emailController),
          16.height,
          MyTextFormField(
            hintText: 'Password',
            controller: passwordController,
            obscureText: true,
          ),
          16.height,
          MyTextFormField(
            hintText: 'Confirm Password',
            controller: confirmPasswordController,
            obscureText: true,
          ),
          16.height,
          MyButton(
            icon: Icon(Icons.email, color: Colors.white),
            text: 'Register with Email',
            onPressed: () async {
              if (passwordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }
              try {
                await ref
                    .read(authControllerProvider.notifier)
                    .registerWithEmail(
                      emailController.text,
                      passwordController.text,
                    );
              } catch (e, stack) {
                FirebaseAnalytics.instance.logEvent(
                  name: 'exception',
                  parameters: {
                    'error': e.toString(),
                    'stack': stack.toString(),
                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Registration failed: $e')),
                );
              }
            },
          ),
          16.height,
          GestureDetector(
            onTap: () {
              setState(() {
                isLogin = true;
              });
            },
            child: Text(
              'Already have an account? Login',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

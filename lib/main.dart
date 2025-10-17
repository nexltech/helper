import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job/Screen/Auth/auth_gate_screen.dart';
import 'providers/user_provider.dart';
import 'providers/admin_provider.dart';
import 'providers/crud_job_provider.dart';
import 'providers/job_applicants_provider.dart';
import 'providers/my_applications_provider.dart';
import 'providers/profile_crud_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/review_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final userProvider = UserProvider();
            // Load session on app start
            userProvider.loadSession();
            return userProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) => AdminProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CrudJobProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => JobApplicantsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyApplicationsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileCrudProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(),
        // Auth gate screen handles routing based on login status and user role
        home: const AuthGateScreen(),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projects/view/login_view.dart';
import 'package:projects/view/register_view.dart';
import 'firebase_options.dart';

void main(){
// https://docs.flutter.dev/resources/architectural-overview#architectural-layers
  WidgetsFlutterBinding.ensureInitialized();
//   the WidgetFlutterBinding is used to interact with the Flutter engine.
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
      routes: {
        '/login/':(context)=> const LoginView(),
        '/register/':(context)=>const RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());

        }

        if (snapshot.connectionState == ConnectionState.done) {
          // final user = FirebaseAuth.instance.currentUser;
          //
          // if (!(user?.emailVerified ?? false)) {
          //   // FIX: Prevent multiple navigations
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     if (ModalRoute.of(context)?.isCurrent ?? false) {
          //       Navigator.of(context).push(
          //         MaterialPageRoute(builder: (context) => const VerifyEmailView()),
          //       );
          //     }
          //   });
          return const LoginView();
        }

        // return const Center(child: Text('Done'));
        return const Center(child: Text("Error initializing Firebase"));
      },
    );
  }
}



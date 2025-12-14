import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projects/view/login_view.dart';
import 'package:projects/view/register_view.dart';
import 'package:projects/view/verify_email_view.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

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
        // if (snapshot.connectionState != ConnectionState.waiting) {
        //   final user = FirebaseAuth.instance.currentUser;
        //   if(user!=null)
        //     {
        //       if(user.emailVerified){
        //         print('Email is verified');
        //       }else{
        //         return const VerifyEmailView();
        //       }
        //     }else{
        //     return const LoginView();
        //   }
        //   return const Text('Done');
        // }
        // else {return const Center(child: CircularProgressIndicator());}
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          return const LoginView();
        }

        if (!user.emailVerified) {
          return const VerifyEmailView();
        }

        // If we reach here → user is logged in AND email is verified
        return const NotesView(); // or whatever your home screen is (not just Text('Done'))


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
class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum MenuAction{logout}


class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mansha Personal Notes'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected:(value) async {
            switch (value){
              case MenuAction.logout:
                final shouldLogOut = await showLogOutDialog(context);
                if(shouldLogOut){
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login/',(_)=> false);
                }
                break;

            }





          },
            itemBuilder: (context){
            return  [
            const PopupMenuItem<MenuAction>(value: MenuAction.logout,child: const Text('Log Out'),),

            ];

              const PopupMenuItem<MenuAction>(value: MenuAction.logout,child: const Text('Logg Out'),);
    },
          )
        ],

      ),
      body: const Text('Hi! You can type anything here- It will be personal'),
    );
  }
}


Future<bool> showLogOutDialog(BuildContext context)
{
  return showDialog<bool>(
    context: context,
    builder: (context){
      return AlertDialog(
        title: const Text('LogOut'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, child: const Text('Cancel')),
          TextButton(onPressed: (){
            Navigator.of(context).pop(true);
            }, child: const Text('LogOut')),
        ],
      );
    },
  ).then((value)=>value??false);
}

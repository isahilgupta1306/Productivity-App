import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/authentication_services.dart';
import '../auth/authentication_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> colorCodes = {
      50: const Color.fromRGBO(147, 205, 72, .1),
      100: const Color.fromRGBO(147, 205, 72, .2),
      200: const Color.fromRGBO(147, 205, 72, .3),
      300: const Color.fromRGBO(147, 205, 72, .4),
      400: const Color.fromRGBO(147, 205, 72, .5),
      500: const Color.fromRGBO(147, 205, 72, .6),
      600: const Color.fromRGBO(147, 205, 72, .7),
      700: const Color.fromRGBO(147, 205, 72, .8),
      800: const Color.fromRGBO(147, 205, 72, .9),
      900: const Color.fromRGBO(147, 205, 72, 1),
    };

    MaterialColor primaryColor =
        MaterialColor(0xFF148F77, colorCodes); //primaryColor
    MaterialColor secondaryColor =
        MaterialColor(0xFF45B39D, colorCodes); //secondary light shade
    MaterialColor darkColor =
        MaterialColor(0xFF283747, colorCodes); //secondary light shade
    MaterialColor redColor = MaterialColor(0xFFC70039, colorCodes);
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
            initialData: null)
      ], //this one will provide context of AuthServ
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: primaryColor,
          colorScheme: ColorScheme.light(
            primary: primaryColor,
            secondary: secondaryColor,
          ),
          dividerColor: darkColor,
          brightness: Brightness.light,
          //fonts
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
          // fonts used : catamaran , robota
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthenticcationWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

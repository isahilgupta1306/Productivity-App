import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/auth/authentication_services.dart';
import 'package:productivity_app/helpers/custom_colors.dart';
import 'package:productivity_app/screens/auth/login_screen.dart';
import 'package:productivity_app/theme_provider.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatefulWidget {
  // const SideDrawer({Key? key}) : super(key: key);
  final String? name;
  SideDrawer(this.name);

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final label_style = TextStyle(
      color: themeProvider.isLightTheme ? cardColorbgColorDark : white,
      fontWeight: FontWeight.w500,
      fontSize: 15,
    );
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            color: themeProvider.isLightTheme ? white : bgColorDark),
        child: ListView(
          children: [
            Container(
              height: 50,
              child: DrawerHeader(
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 30),
                  child: Text(
                    widget.name!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    topRight: Radius.circular(50)),
                onTap: () async {
                  await themeProvider.toggleThemeData();
                  setState(() {});
                },
                splashColor: bgColorDark,
                child: Container(
                  height: deviceSize.height * 0.075,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      const Icon(
                        Icons.format_paint,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Change Theme", style: label_style),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    topRight: Radius.circular(50)),
                onTap: () {
                  context.read<AuthenticationService>().signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                splashColor: bgColorDark,
                child: Container(
                  height: deviceSize.height * 0.075,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      const Icon(
                        Icons.exit_to_app_rounded,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "SignOut",
                        style: label_style,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),

      //mfdmf
    );
  }
}

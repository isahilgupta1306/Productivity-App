import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/auth/authentication_services.dart';
import 'package:productivity_app/helpers/custom_colors.dart';
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
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color: cardColorbgColorDark),
        child: ListView(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: white.withOpacity(0.1)))),
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
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    topRight: Radius.circular(50)),
                onTap: () {
                  context.read<AuthenticationService>().signOut();
                },
                splashColor: bgColorDark,
                child: Container(
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
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "SignOut",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: white),
                        ),
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

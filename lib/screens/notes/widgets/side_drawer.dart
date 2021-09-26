import 'package:flutter/material.dart';
import 'package:productivity_app/helpers/custom_colors.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: cardColorbgColorDark),
        child: ListView(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: white.withOpacity(0.1)))),
              child: const DrawerHeader(
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 30),
                  child: Text(
                    "Google Keep",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      //mfdmf
    );
  }
}

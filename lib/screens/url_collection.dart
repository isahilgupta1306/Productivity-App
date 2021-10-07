import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:productivity_app/helpers/custom_colors.dart';
import 'package:productivity_app/screens/home_screen.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class URLCollection extends StatefulWidget {
  String? url; //({Key? key}) : super(key: key);
  URLCollection({Key? key}) : super(key: key);

  @override
  _URLCollectionState createState() => _URLCollectionState();
}

class _URLCollectionState extends State<URLCollection> {
  late StreamSubscription _intentDataStreamSubscription;
  String? _sharedText = "";

  @override
  void initState() {
    super.initState();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return HomeScreen(2);
      }));
    }, onError: (err) {
      print("getLinkStream error: $err");
      _sharedText = "Some error Occured";
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((value) {
      setState(() {
        _sharedText = value;
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColorDark,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: deviceSize.height * 0.78,
              child: StaggeredGridView.countBuilder(
                  padding: EdgeInsets.all(10),
                  crossAxisCount: 2, //for column
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: cardColorbgColorDark,
                            border: Border.all(color: white.withOpacity(0.22)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "URL Title",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Divider(
                              color: white.withOpacity(0.22),
                              indent: 10,
                              endIndent: 10,
                            ),
                            Text(
                              "link",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: white.withOpacity(0.7),
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  staggeredTileBuilder: (index) {
                    return const StaggeredTile.fit(1);
                    // return StaggeredTile.count(
                    //     1, index.isEven ? 1.4 : 1.0);
                  }),
            ),
            Center(child: Text(_sharedText ??= " ")),
          ],
        ),
      ),
    );
  }
}

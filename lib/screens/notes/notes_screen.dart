import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:productivity_app/helpers/custom_colors.dart';
import 'package:productivity_app/screens/notes/widgets/side_drawer.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  List<String> imageList = [
    'https://cdn.pixabay.com/photo/2019/03/15/09/49/girl-4056684_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/12/15/16/25/clock-5834193__340.jpg',
    'https://cdn.pixabay.com/photo/2020/09/18/19/31/laptop-5582775_960_720.jpg',
    'https://media.istockphoto.com/photos/woman-kayaking-in-fjord-in-norway-picture-id1059380230?b=1&k=6&m=1059380230&s=170667a&w=0&h=kA_A_XrhZJjw2bo5jIJ7089-VktFK0h0I4OWDqaac0c=',
    'https://cdn.pixabay.com/photo/2019/11/05/00/53/cellular-4602489_960_720.jpg',
    'https://cdn.pixabay.com/photo/2017/02/12/10/29/christmas-2059698_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/01/29/17/09/snowboard-4803050_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/02/06/20/01/university-library-4825366_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/11/22/17/28/cat-5767334_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/12/13/16/22/snow-5828736_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/12/09/09/27/women-5816861_960_720.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _drawerKey,
      drawer: SideDrawer(),
      backgroundColor: bgColorDark,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 18, bottom: 20),
              child: Container(
                width: deviceSize.width,
                height: 45,
                decoration: BoxDecoration(
                    color: cardColorbgColorDark,
                    boxShadow: [
                      BoxShadow(
                          color: black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3),
                    ],
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          _drawerKey.currentState?.openDrawer();
                        },
                        icon: Icon(Icons.menu),
                        color: white.withOpacity(0.7),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      //  fontSize: 15, color: white.withOpacity(0.7))
                      SizedBox(
                        width: deviceSize.width * 0.5,
                        child: TextFormField(
                          decoration: const InputDecoration.collapsed(
                              hintText: 'Search your notes'),
                        ),
                      ),
                      Icon(
                        Icons.person_outline,
                        color: Theme.of(context).iconTheme.color,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: deviceSize.height * 0.78,
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: cardColorbgColorDark,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        children: [
                          Text(
                            'Title',
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 15,
                                color: white.withOpacity(0.9),
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Description",
                            textAlign: TextAlign.left,
                            maxLines: 12,
                            style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: white.withOpacity(0.7),
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    );
                  },
                  staggeredTileBuilder: (index) {
                    return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
                  }),
            ),

            //end of grid
          ],
        ),
      ),
      // bottomSheet: getFooter(),
    );
  }
}

// Widget getBody(BuildContext ctx) {
//   var deviceSize = MediaQuery.of(ctx).size;
//   return ListVieW();
// }

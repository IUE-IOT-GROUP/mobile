import 'package:flutter/material.dart';
import 'package:prototype/screens/devices/create_device_screen.dart';
import 'package:prototype/screens/places/create_place_screen.dart';
import 'package:prototype/screens/places/edit_place_screen.dart';
import 'package:prototype/services/place.service.dart';
import 'package:prototype/widgets/child_place_list.dart';
import 'package:prototype/widgets/navDrawer.dart';
import '../../widgets/place_item.dart';
import '../../widgets/device_list.dart';
import '../../models/place.dart';
import '../../global.dart';
import '../main_screen.dart';

class PlaceItemScreen extends StatefulWidget {
  static const routeName = '/place-item-screen';

  @override
  _PlaceItemScreenState createState() => _PlaceItemScreenState();
}

class _PlaceItemScreenState extends State<PlaceItemScreen> with SingleTickerProviderStateMixin {
  Future<Place>? _placeFuture;
  int? _placeId;

  Place? currentPlace;

  Future<Place> fetchPlace() async {
    var place = await PlaceService.getPlaceById(_placeId);

    return place;
  }

  int _currentIndex = 0;
  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController!.index;
    });
  }

  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    Future.delayed(Duration.zero, () {
      setState(() {
        final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, int?>;
        _placeId = routeArgs['placeId'] as int;
        _placeFuture = fetchPlace();
      });
    });
  }

  @override
  void dispose() {
    print("index on disposed: ${_tabController!.index}");
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("index: ${_tabController!.index}");
    final mq = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: FutureBuilder(
        future: _placeFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            currentPlace = snapshot.data;

            print(currentPlace!.places);

            return Scaffold(
              drawer: NavDrawer(),
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(currentPlace!.name!),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(30),
                  child: TabBar(
                    controller: _tabController,
                    unselectedLabelColor: Colors.white.withOpacity(0.3),
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                        text: "Places",
                      ),
                      Tab(
                        text: "Devices",
                      )
                    ],
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              body: TabBarView(
                controller: _tabController,
                children: [
                  ChildPlaceList(currentPlace!.places),
                  DeviceList(
                    isGetAllDevices: false,
                    placeId: currentPlace!.id,
                  )
                ],
              ),
              floatingActionButton: _currentIndex == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.green,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, EditPlaceScreen.routeName, arguments: {'placeId': currentPlace!.id});
                            },
                            child: Icon(Icons.edit),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.green,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(CreatePlace.routeName);
                            },
                            child: Icon(Icons.add),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.red,
                          child: InkWell(
                            onTap: () {
                              ensureDelete();
                            },
                            child: Icon(Icons.delete),
                          ),
                        ),
                      ],
                    )
                  : null,
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void ensureParentDelete() {
    var alert = AlertDialog(
      title: Text('WARNING!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                'You are about to remove ${currentPlace!.name} and there are one or more subplaces in this place. If you delete, all subplaces and devices corresponding to them will be deleted as well. Are you sure?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            var deleteSucces = await PlaceService.deletePlace(currentPlace!);
            if (deleteSucces) {
              Global.warning(context, 'Success!');
              await Navigator.of(context).popAndPushNamed(MainScreen.routeName);
            } else {
              Global.warning(context, 'Something went wrong!');
            }
          },
          child: Text(
            'YES',
            style: TextStyle(color: Colors.green),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'NO',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void ensureDelete() {
    var alert = AlertDialog(
      title: Text('WARNING!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('If you delete a place with subplaces or devices, they will be deleted as well. Are you sure?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            var deleteSuccess = await PlaceService.deletePlace(currentPlace!);
            if (deleteSuccess) {
              Navigator.of(context).pop();
              await Navigator.of(context).popAndPushNamed(MainScreen.routeName);
            } else {
              Global.alert(context, 'ERROR!', 'An error has occured!');
            }
          },
          child: Text(
            'YES',
            style: TextStyle(color: Colors.green),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'NO',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}

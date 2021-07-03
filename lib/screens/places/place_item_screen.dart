import 'package:flutter/material.dart';
import 'package:prototype/screens/places/create_place_screen.dart';
import 'package:prototype/screens/places/edit_place_screen.dart';
import 'package:prototype/services/place.service.dart';
import 'package:prototype/widgets/child_place_list.dart';
import 'package:prototype/widgets/fog_list.dart';
import 'package:prototype/widgets/navDrawer.dart';
import '../../widgets/device_list.dart';
import '../../models/place.dart';
import '../../global.dart';
import '../main_screen.dart';

class PlaceItemScreen extends StatefulWidget {
  static const routeName = '/place-item-screen';

  @override
  _PlaceItemScreenState createState() => _PlaceItemScreenState();
}

class _PlaceItemScreenState extends State<PlaceItemScreen>
    with SingleTickerProviderStateMixin {
  Future<Place>? _placeFuture;
  String? _placeId;

  Place? currentPlace;

  Future<Place> fetchPlace() async {
    var place = await PlaceService.getPlaceById(_placeId);

    return place;
  }

  int _currentIndex = 0;
  void _handleTabSelection() async {
    setState(() {
      _currentIndex = _tabController!.index;
    });
  }

  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    Future.delayed(Duration.zero, () {
      setState(() {
        final routeArgs =
            ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
        _placeId = routeArgs['placeId'] as String;
        _placeFuture = fetchPlace();
      });
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: FutureBuilder(
            future: _placeFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                currentPlace = snapshot.data;
                return Text(currentPlace!.name!);
              }
              return Container();
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: TabBar(
              controller: _tabController,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).accentColor,
              tabs: [
                Tab(
                  text: 'Places',
                ),
                Tab(
                  text: 'Fogs',
                ),
                Tab(
                  text: 'Devices',
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: FutureBuilder(
          future: _placeFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              currentPlace = snapshot.data;
              return TabBarView(
                controller: _tabController,
                children: [
                  ChildPlaceList(currentPlace!.places),
                  FogList(currentPlace!.id),
                  DeviceList(
                    isGetAllDevices: false,
                    placeId: currentPlace!.id,
                  ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: _currentIndex == 0
            ? Global.isFog
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.yellow,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, EditPlaceScreen.routeName,
                                arguments: {'placeId': currentPlace!.id});
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
                            Navigator.of(context).pushNamed(
                                CreatePlace.routeName,
                                arguments: {'parentId': currentPlace!.id});
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
                : null
            : _currentIndex == 1
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.yellow,
                        child: InkWell(
                          onTap: () {},
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
                            Navigator.of(context).pushNamed(
                                CreatePlace.routeName,
                                arguments: {'parentId': currentPlace!.id});
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
            Text(
                'If you delete a place with subplaces or devices, they will be deleted as well. Are you sure?'),
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

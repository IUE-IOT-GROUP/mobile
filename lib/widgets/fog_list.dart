import 'package:flutter/material.dart';
import 'package:prototype/models/fog.dart';
import 'package:prototype/services/place.service.dart';

class FogList extends StatefulWidget {
  String? placeId;
  FogList(this.placeId);
  @override
  _FogListState createState() => _FogListState();
}

class _FogListState extends State<FogList> {
  Future? future;
  Future getFogs() async {
    return await PlaceService.getFogs(widget.placeId!);
  }

  @override
  void initState() {
    super.initState();
    future = getFogs();
  }

  List<Fog> fogs = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          fogs = snapshot.data;
          return fogs.isNotEmpty
              ? Container(
                  child: ListView.builder(
                      itemCount: fogs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 40,
                          color: Theme.of(context).accentColor,
                          child: ListTile(
                            title: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Image.asset(
                                    'assets/images/fog.png',
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name: ${fogs[index].name!}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Port: ${fogs[index].port}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "IP: ${fogs[index].ipAddress}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "MAC: ${fogs[index].macAddress}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              : LayoutBuilder(builder: (context, constrainst) {
                  return Column(
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: constrainst.maxHeight * 0.05),
                          child: Text(
                            'No Fogs',
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: constrainst.maxHeight * 0.05,
                      ),
                      Center(
                        child: Container(
                          height: constrainst.maxHeight * 0.5,
                          child: Image.asset(
                            'assets/images/waiting.png',
                            color: Theme.of(context).accentColor,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  );
                });
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

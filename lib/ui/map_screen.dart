import 'package:flutter/material.dart';
import 'package:flutter_map_example/common/dimens/dimens.dart';
import 'package:flutter_map_example/common/text_style/text_style.dart';
import 'package:flutter_map_example/common/user_states/user_states.dart';
import 'package:flutter_map_example/common/widget/back_btn_widget.dart';
import 'package:flutter_map_example/gen/assets.gen.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List userCurrentState = [UserStates.selectedOrigin]; // current state
  List<GeoPoint> geoPoint = []; // map points
  String distance = 'در حال محسابه فاصله تا مقصد...';
  Widget iconMarker = SvgPicture.asset(Assets.images.origin,height: 100,width: 40); /// map icon marker
  Widget originMarker = SvgPicture.asset(Assets.images.origin,height: 100,width: 40);
  Widget destinationMarker = SvgPicture.asset(Assets.images.destination,height: 100,width: 40);

  //map controller
  MapController mapController = MapController(
    initMapWithUserPosition: false,
    initPosition:
    GeoPoint(latitude: 28.9122,longitude:50.8278)
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // osm map
            SizedBox.expand(
              child: OSMFlutter(
                controller: mapController,
                trackMyPosition: true,
                isPicker: true,
                mapIsLoading: const Center(child:  CircularProgressIndicator()),
                markerOption: MarkerOption(advancedPickerMarker: MarkerIcon(iconWidget: iconMarker)),
                initZoom: 15,
                minZoomLevel: 8,
                maxZoomLevel: 18,
                stepZoom: 1,
              ),
            ),
            // state
            currentState(),
            // back btn
            Positioned(
              top: AppDimens.small,
              left: AppDimens.medium,
              child: MapBackBtn(onTap: () {
                if(geoPoint.isNotEmpty){
                  geoPoint.removeLast();
                  iconMarker = SvgPicture.asset(Assets.images.origin,height: 100,width: 40);
                  mapController.init();
                }
                if(userCurrentState.length > 1){
                  setState(() {
                    userCurrentState.removeLast();
                  });
                }
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget originState() {
    return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.large),
              child: ElevatedButton(
                  onPressed: () async {
                    // get origin location point
                    GeoPoint originGeoPoint = await mapController.getCurrentPositionAdvancedPositionPicker();
                    geoPoint.add(originGeoPoint);
                    iconMarker = destinationMarker;
                    setState(() {
                      userCurrentState.add(UserStates.selectedDestination);
                    });
                    mapController.init();
                  },
                  child: Text("انتخاب مبدا",style: AppTextStyle.btnTxtStyle)),
            ),
          );
  }
  Widget destinationState() {
    return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.large),
              child: ElevatedButton(
                  onPressed: () async {
                    // add destination point to list
                    await mapController.getCurrentPositionAdvancedPositionPicker().then((value) {
                      geoPoint.add(value);
                    });
                    // mark origin and destination to map
                    mapController.cancelAdvancedPositionPicker();
                    mapController.addMarker(geoPoint.first,markerIcon: MarkerIcon(iconWidget:originMarker));
                    mapController.addMarker(geoPoint.last,markerIcon: MarkerIcon(iconWidget: destinationMarker));
                    //ToDo : مارکر نقشه باگ داره و تو هر دو نقطه مارکر مبدا رو قرار میده

                   // calculate distance
                   await distance2point(geoPoint.first, geoPoint.last).then((value) {
                     setState(() {
                       if(value <= 1000){
                         distance = "فاصله تا مقصد ${value.toInt()} متر";
                       }else{
                         distance = "فاصله تا مقصد ${value.toInt()} کیلو متر";
                       }
                     });
                   });
                    setState(() {
                      userCurrentState.add(UserStates.requestDriver);
                    });
                  },
                  child: Text("انتخاب مقصد",style: AppTextStyle.btnTxtStyle)),
            ),
          );
  }
  Widget reqDriverState() {
    mapController.zoomOut();
    return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.large),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(child: Text(distance)),
                  ),
                  const SizedBox(height: AppDimens.medium),
                  //request driver btn
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Text("درخواست راننده",style: AppTextStyle.btnTxtStyle)),
                  ),
                ],
              ),
            ),
          );
  }

  Widget currentState(){
    Widget widget = originState();
    switch(userCurrentState.last){
      case UserStates.selectedOrigin :
        widget = originState();
        break;
      case UserStates.selectedDestination :
        widget = destinationState();
        break;
      case UserStates.requestDriver :
        widget = reqDriverState();
    }
    return widget;
  }
}


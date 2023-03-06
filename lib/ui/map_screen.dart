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
  List userCurrentState = [UserStates.selectedOrigin];
  List<GeoPoint> geoPoint = []; /// map points
  Widget markIcon = SvgPicture.asset(Assets.images.origin,height: 100,width: 40); // map icon marker

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
                markerOption: MarkerOption(advancedPickerMarker: MarkerIcon(iconWidget: markIcon)),
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
                    /// get origin location point
                    GeoPoint originGeoPoint = await mapController.getCurrentPositionAdvancedPositionPicker();
                    geoPoint.add(originGeoPoint);
                    markIcon = SvgPicture.asset(Assets.images.destination);
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
                  onPressed: () {
                    setState(() {
                      userCurrentState.add(UserStates.requestDriver);
                    });
                  },
                  child: Text("انتخاب مقصد",style: AppTextStyle.btnTxtStyle)),
            ),
          );
  }
  Widget reqDriverState() {
    return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.large),
              child: ElevatedButton(
                  onPressed: () {},
                  child: Text("درخواست راننده",style: AppTextStyle.btnTxtStyle)),
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


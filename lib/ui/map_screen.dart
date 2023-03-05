import 'package:flutter/material.dart';
import 'package:flutter_map_example/common/dimens/dimens.dart';
import 'package:flutter_map_example/common/text_style/text_style.dart';
import 'package:flutter_map_example/common/widget/back_btn_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // osm map
            Container(color: Colors.grey.shade300),
            // btn
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.large),
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text("انتخاب مبدا",style: AppTextStyle.btnTxtStyle)),
              ),
            ),
            // back btn
            Positioned(
              top: AppDimens.small,
              left: AppDimens.medium,
              child: MapBackBtn(onTap: () {}),
            )
          ],
        ),
      ),
    );
  }
}


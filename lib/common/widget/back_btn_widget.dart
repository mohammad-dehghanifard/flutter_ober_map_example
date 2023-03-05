import 'package:flutter/material.dart';
import 'package:flutter_map_example/common/dimens/dimens.dart';

class MapBackBtn extends StatelessWidget {
  const MapBackBtn({
    super.key,
    required this.onTap
  });
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  blurRadius: 18,
                  color: Colors.black26,
                  offset: Offset(2,3)
              )
            ]
        ),
        child: const Icon(Icons.arrow_back,size: AppDimens.large),
      ),
    );
  }
}
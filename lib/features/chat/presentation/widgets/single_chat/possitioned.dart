import 'package:flutter/material.dart';
import 'package:inistagram/core/const/colors.dart';


class MyPosition extends StatefulWidget {
  final void Function()? selectVideo;
  final void Function()? sendGifMessage; 
  final void Function()? getImageFromGallery;
  final void Function()? getImageFromCamera;

  const MyPosition({super.key, this.selectVideo, this.sendGifMessage, this.getImageFromGallery, this.getImageFromCamera});
  @override
  State<MyPosition> createState() => _MyPositionState();
}

class _MyPositionState extends State<MyPosition> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 62,
      top: 400,
      left: 15,
      right: 15,
      child: Container(
        width: double.infinity,
        height:55,
        //MediaQuery.of(context).size.width * 0.18,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        decoration: BoxDecoration(
          color: bottomAttachContainerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _attachWindowItem(
                  icon: Icons.document_scanner,
                  color: Colors.deepPurpleAccent,
                  title: "Document",
                ),
                _attachWindowItem(
                    icon: Icons.camera_alt,
                    color: Colors.pinkAccent,
                    title: "Camera",
                    onTap: widget.getImageFromCamera),
                _attachWindowItem(
                  onTap: widget.getImageFromGallery,
                    icon: Icons.image,
                    color: Colors.purpleAccent,
                    title: "Gallery"),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _attachWindowItem(
                    icon: Icons.headphones,
                    color: Colors.deepOrange,
                    title: "Audio"),
                _attachWindowItem(
                    icon: Icons.location_on,
                    color: Colors.green,
                    title: "Location"),
                _attachWindowItem(
                    icon: Icons.account_circle,
                    color: Colors.deepPurpleAccent,
                    title: "Contact"),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _attachWindowItem(
                  icon: Icons.bar_chart,
                  color: tabColor,
                  title: "Poll",
                ),
                _attachWindowItem(
                    icon: Icons.gif_box_outlined,
                    color: Colors.indigoAccent,
                    title: "Gif",
                    onTap: widget.sendGifMessage),
                _attachWindowItem(
                  icon: Icons.videocam_rounded,
                  color: Colors.lightGreen,
                  title: "Video",
                  onTap:widget.selectVideo
                  ,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _attachWindowItem(
      {IconData? icon, Color? color, String? title, VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 55,
              height: 55,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40), color: color),
              child: Icon(icon),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "$title",
              style: const TextStyle(color: greyColor, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }




}

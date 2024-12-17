import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inistagram/core/class/responsive_screen.dart';
import 'package:inistagram/core/const/colors.dart';

class MyPosition extends StatefulWidget {
  final void Function()? selectVideo;
  final void Function()? sendGifMessage;
  final void Function()? getImageFromGallery;
  final void Function()? getImageFromCamera;
  final void Function()? getDoc;
  final void Function()? getAudio;
  final void Function()? getVideo;
  final void Function()? getContact;
  final void Function()? getLocation;

  const MyPosition({
    super.key,
    this.selectVideo,
    this.sendGifMessage,
    this.getImageFromGallery,
    this.getImageFromCamera,
    this.getDoc,
    this.getAudio,
    this.getVideo,
    this.getContact,
    this.getLocation,
  });
  @override
  State<MyPosition> createState() => _MyPositionState();
}

class _MyPositionState extends State<MyPosition> {
  @override
  Widget build(BuildContext context) {
    ResponsiveScreen.initialize(context);
    return Positioned(
      bottom: 60.h,
      //top: ResponsiveScreen.height * 0.30,
      left: 15.w,
      right: 15.w,
      child: Container(
        width: double.infinity,
        //height: 55.h,
        //MediaQuery.of(context).size.width * 0.18,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: bottomAttachContainerColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _attachWindowItem(
                  onTap: widget.getDoc,
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
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _attachWindowItem(
                    onTap: widget.getAudio,
                    icon: Icons.headphones,
                    color: Colors.deepOrange,
                    title: "Audio"),
                _attachWindowItem(
                    onTap: widget.getLocation,
                    icon: Icons.location_on,
                    color: Colors.green,
                    title: "Location"),
                _attachWindowItem(
                    onTap: widget.getContact,
                    icon: Icons.account_circle,
                    color: Colors.deepPurpleAccent,
                    title: "Contact"),
              ],
            ),
            SizedBox(height: 20.h),
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
                  onTap: widget.selectVideo,
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
              width: 55.w,
              height: 55.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r), color: color),
              child: Icon(icon),
            ),
            SizedBox(height: 5.h),
            Text(
              "$title",
              style: TextStyle(color: greyColor, fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }
}

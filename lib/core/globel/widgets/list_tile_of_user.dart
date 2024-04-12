import 'package:flutter/material.dart';


class ListTileOfUser extends StatelessWidget {
  final void Function()? onTap;
  final Widget? subtitle;
  final Widget? trailing;

  const ListTileOfUser({super.key, this.onTap, this.trailing, this.subtitle});

  @override
  Widget build(BuildContext context) {
    // var service = Provider.of<HandleImage>(context);
    return ListTile(
      onTap: onTap,
      leading: const CircleAvatar(
        radius: 23,
        //backgroundImage: service.profileImage(false),
      ),
      title: const Text("UserName"),
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}

class ListTileOfUser2 extends StatelessWidget {
  final void Function()? onTap;
  final ImageProvider<Object>?  imageUrl;
  final String title;
  final Widget? subtitle;
  final Widget? trailing;

  const ListTileOfUser2(
      {super.key,
      this.onTap,
      this.trailing,
      this.subtitle,
      required this.imageUrl,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 23,
        backgroundImage: imageUrl,
      ),
      title:  Text(title),
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}

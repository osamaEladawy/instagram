// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/class/handle_image.dart';
import '../../../../core/functions/data_formates.dart';
import '../../../../core/shared/widgets/list_tile_of_user.dart';

class ListOfStories extends StatelessWidget {
  const ListOfStories({super.key});

  @override
  Widget build(BuildContext context) {
    var service = Provider.of<HandleImage>(context);
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("stories").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapsht) {
          if (snapsht.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snapsht.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Watting"),
            );
          }
          if (!snapsht.hasData) {
            return const Center(
              child: Text("Not data here"),
            );
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTileOfUser(
                  subtitle: Text(
                    formatDateTime(DateTime.now()),
                  ),
                );
              });
        });
  }
}

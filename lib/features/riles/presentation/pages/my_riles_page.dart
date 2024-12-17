import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:inistagram/core/const/colors.dart';
import 'package:inistagram/features/riles/domain/entities/riles_entity.dart';
import 'package:inistagram/features/riles/presentation/manager/riles/cubit/riles_cubit.dart';
import 'package:inistagram/features/riles/presentation/widgets/delete_riles_update_alert.dart';
import 'package:inistagram/shared/widgets/profile_widget.dart';
import 'package:inistagram/features/home/screens/home.dart'; 

class MyRilesPage extends StatefulWidget {
  final RilesEntity riles;
  const MyRilesPage({super.key, required this.riles});

  @override
  State<MyRilesPage> createState() => _MyRilesPageState();
}

class _MyRilesPageState extends State<MyRilesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: const Text("My Status"),
        ),
        body:
        Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: profileWidget(imageUrl: widget.riles.imageUrl),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(  
                child: Text(
                  GetTimeAgo.parse(widget.riles.createdAt!
                      .toDate()
                      .subtract(Duration(seconds: DateTime.now().second))),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: greyColor.withOpacity(.5),
                ),
                color: appBarColor,
                iconSize: 28,
                onSelected: (value) {},
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "Delete",
                    child: GestureDetector(
                      onTap: () {
                        deleteRilesUpdate(context, onTap: () {
                          Navigator.pop(context);
                          BlocProvider.of<RilesCubit>(context).deleteStatus(
                              status: RilesEntity(
                                  statusId: widget.riles.statusId));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomePage(),
                            ),
                          );
                        });
                      },
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    ),
    );
  }
}
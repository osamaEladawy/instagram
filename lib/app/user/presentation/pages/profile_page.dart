import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/app/user/presentation/manager/get_single_user/get_single_user_cubit.dart';
import 'package:inistagram/app/user/presentation/widgets/profile/appbartitle.dart';
import 'package:inistagram/app/user/presentation/widgets/profile/detialesForUsers.dart';
import 'package:inistagram/app/user/presentation/widgets/profile/tabsofposts.dart';
import 'package:inistagram/controller/user_providers.dart';
import 'package:provider/provider.dart';
import '../../../../view_model/profile/profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileViewModel _model = ProfileViewModel();

  getDataForUser() async {
    await _model.getData(context, widget.uid);
    setState(() {});
  }

  getAllPost()async{
    await _model.getPosts();
    setState(() {
      
    });
  }


  @override
  void initState() {
      BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(userId: widget.uid);
    super.initState();
    getDataForUser();
    getAllPost();
   
  }

  @override
  Widget build(BuildContext context) {
    var userEntity = Provider.of<UsersProviders>(context).users;

    return _model.loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(onPressed: (){
                Navigator.of(context).pop();
              },icon:const Icon(Icons.arrow_back_ios),),
              centerTitle: false,
              title: AppBarTitleForProfile(
                model: _model,
                userEntity: userEntity,
              ),
              actions: [
                 if (FirebaseAuth.instance.currentUser!.uid ==
                    _model.userData['uid'])
                TextButton(
                    onPressed: () async {
                     await _model.privateMyProfile(widget.uid);
                     setState((){});
                    },
                    child: _model.value == true
                        ? const Text("puplic")
                        : const Text("private")),
                if (FirebaseAuth.instance.currentUser!.uid ==
                    _model.userData['uid'])
                  IconButton(
                    onPressed: () async {
                      await _model.logOut(context);
                    },
                    icon: const Icon(Icons.logout),
                  ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  DetialesForUser(
                      model: _model, userEntity: userEntity!, uid: widget.uid),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("${_model.userData['username']}"),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("${_model.userData['bio']}"),
                  ),
                  const Divider(),

                 if (FirebaseAuth.instance.currentUser!.uid ==
                    _model.userData['uid'])
                   TabsForPosts(
                    uid: widget.uid, postId: _model.post['postId'], 
                  ),

                  if(FirebaseAuth.instance.currentUser!.uid !=
                    _model.userData['uid']&& _model.isFollow == true &&_model.userData['isPrivate'] == false)
                  Expanded(
                    child: TabsForPosts(
                      uid: widget.uid, postId: _model.post["postId"], 
                    ),
                  ),

                ],
              ),
            ),
          );
  }
}

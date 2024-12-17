import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:inistagram/core/class/handel_request.dart';
import 'package:inistagram/core/functions/extinctions.dart';
import 'package:inistagram/shared/model/post_model.dart';
import 'package:inistagram/features/search/cubit/search_cubit.dart';

import '../../user/data/remote/models/user_model.dart';
import '../../../core/const/page_const.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //final SearchViewModel _model = SearchViewModel();

  @override
  void dispose() {
    super.dispose();
    SearchCubit.instance.search.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: TextFormField(
              controller: SearchCubit.instance.search,
              decoration: const InputDecoration(
                labelText: "Search for a user",
              ),
              onChanged: (value) {
                SearchCubit.instance.toggleShowUsers();
               
                // setState(() {
                //   _model.isShowUsers = true;
                // });
              },
            ),
          ),
          body: SearchCubit.instance.isShowUsers == true &&
                  SearchCubit.instance.search.text.isNotEmpty
              ? FutureBuilder(
                  future: SearchCubit.instance.searchForUsers(),
                  builder: (context, snapshot) {
                    return HandelRequest(
                      snapshot: snapshot,
                      widget: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot result =
                                snapshot.data!.docs[index];
                            UserModel user = UserModel.fromSnapshot(result);
                            if (user.imageUrl != null &&
                                user.username != null) {
                              return ListTile(
                                onTap: () {
                                  context.pushNamed(
                                    PageConst.profilePage,
                                    arguments: user.uid,
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage("${user.imageUrl}"),
                                ),
                                title: Text("${user.username}"),
                              );
                            } else {
                              return Container();
                            }
                          }),
                    );
                  },
                )
              : FutureBuilder(
                  future: SearchCubit.instance.searchForPosts(),
                  builder: (context, snapshot) {
                    return HandelRequest(
                      snapshot: snapshot,
                      widget: AlignedGridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot result =
                              snapshot.data!.docs[index];
                          PostModel post = PostModel.fromSnapshot(result);
                          if (post.postUrl != null) {
                            return InkWell(
                                onTap: () {
                                  context.pushNamed(
                                    PageConst.profilePage,
                                    arguments: post.uid,
                                  );
                                },
                                child: Image.network("${post.postUrl}"));
                          } else {
                            return Container();
                          }
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:inistagram/core/class/handel_request.dart';
import 'package:inistagram/core/shared/model/post_model.dart';

import '../../features/user/data/remote/models/user_model.dart';
import '../../core/const/page_const.dart';
import '../../core/functions/navigationpage.dart';
import '../../view_model/search/search_view_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchViewModel _model = SearchViewModel();

  @override
  void dispose() {
    super.dispose();
    _model.search.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _model.search,
          decoration: const InputDecoration(
            labelText: "Search for a user",
          ),
          onChanged: (value) {
            setState(() {
              _model.isShowUsers = true;
            });
          },
        ),
      ),
      body: _model.isShowUsers == true && _model.search.text.isNotEmpty
          ? FutureBuilder(
              future: _model.searchForUsers(),
              builder: (context, snapshot) {
                return HandelRequest(
                  snapshot: snapshot,
                  widget: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot result =
                            snapshot.data!.docs[index];
                        UserModel user = UserModel.fromSnapshot(result);
                        if (user.imageUrl != null && user.username != null) {
                          return ListTile(
                            onTap: () {
                              navigationNamePage(context, PageConst.profilePage,user.uid);
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage("${user.imageUrl}"),
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
              future: _model.searchForPosts(),
              builder: (context, snapshot) {
                return HandelRequest(snapshot: snapshot, widget: AlignedGridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot result = snapshot.data!.docs[index];
                    PostModel post = PostModel.fromSnapshot(result);
                    if (post.postUrl != null) {
                      return InkWell(
                          onTap: () {
                              navigationNamePage(context, PageConst.profilePage,post.uid);
                          },
                          child: Image.network("${post.postUrl}"));
                    } else {
                      return Container();
                    }
                  },
                ),);
              },
            ),
    );
  }
}

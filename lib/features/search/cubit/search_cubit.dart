import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/my_app.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static final SearchCubit _searchCubit =
      BlocProvider.of(navigatorKey.currentContext!);
  static SearchCubit get instance => _searchCubit;

  final TextEditingController search = TextEditingController();
  bool isShowUsers = false;

  void toggleShowUsers() {
    isShowUsers = true;
    emit(ShowUsers(isShowUsers: this.isShowUsers));
    emit(SearchUsers());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchForUsers() async =>
      await FirebaseFirestore.instance
          .collection("users")
          .where("username", isGreaterThanOrEqualTo: search.text)
          .get();

  Future<QuerySnapshot<Map<String, dynamic>>> searchForPosts() async =>
      await FirebaseFirestore.instance.collection("posts").get();
}

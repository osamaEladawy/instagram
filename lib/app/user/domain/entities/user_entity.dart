// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  late final String? uid;
  late final String? username;
  late final String? email;
  late final String? bio;
  late final String? imageUrl;
  late final List? following;
  late final List? followers;
  late final List? saves;
  late final bool? isOnline;
  late final dateWhenLogOut;
  late final bool? isPrivate;

    UserEntity({
    this.saves,
    this.following,
    this.followers,
    this.imageUrl,
    this.username,
    this.isOnline,
    this.bio,
    this.uid,
    this.email,
    this.dateWhenLogOut,
    this.isPrivate
});

  @override
  List<Object?> get props => [
        username,
        email,
        uid,
        bio,
        isOnline,
        imageUrl,
        followers,
        following,
        saves,
        isOnline,
        dateWhenLogOut, 
        isPrivate,
      ];
}

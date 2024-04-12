
import 'package:equatable/equatable.dart';

class RilesImageEntity extends Equatable{

  final String? url;
  final String? type;
  final List<String>? viewers;

  const RilesImageEntity({this.url, this.viewers, this.type});


  factory RilesImageEntity.fromJson(Map<String, dynamic> json) {
    return RilesImageEntity(
        url: json['url'],
        type: json['type'],
        viewers: List.from(json['viewers'])
    );
  }

  static Map<String, dynamic> toJsonStatic(RilesImageEntity rilesImageEntity) => {
    "url": rilesImageEntity.url,
    "viewers": rilesImageEntity.viewers,
    "type": rilesImageEntity.type,
  };
  
  Map<String, dynamic> toJson() => {
    "url": url,
    "viewers": viewers,
    "type": type,
  };

  @override
  List<Object?> get props => [
    url,
    viewers,
    type,
  ];
}
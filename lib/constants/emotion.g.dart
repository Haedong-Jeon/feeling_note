// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Emotion _$EmotionFromJson(Map<String, dynamic> json) => Emotion(
      isPositiveEmotion: json['isPositiveEmotion'] == 1 ? true : false,
      lastFeelDate: json['lastFeelDate'] as String,
    )
      ..imagePath = json['imagePath'] as String
      ..imageOnlinePath = json['imageOnlinePath'] as String
      ..imageOnlineStorageDepth = json['imageOnlineStorageDepth'] as String
      ..lastFeelTime = json['lastFeelTime'] as String
      ..isSelected = json['isSelected'] == 1 ? true : false
      ..inKor = json['inKor'] as String
      ..emoji = json['emoji'] as String
      ..content = json['content'] as String
      ..userUid = json['userUid'] as String
      ..id = json['id'] as int;

Map<String, dynamic> _$EmotionToJson(Emotion instance) => <String, dynamic>{
      'isPositiveEmotion': instance.isPositiveEmotion ? 1 : 0,
      'lastFeelDate': instance.lastFeelDate,
      'imagePath': instance.imagePath,
      'imageOnlinePath': instance.imageOnlinePath,
      'imageOnlineStorageDepth': instance.imageOnlineStorageDepth,
      'lastFeelTime': instance.lastFeelTime,
      'isSelected': instance.isSelected ? 1 : 0,
      'inKor': instance.inKor,
      'emoji': instance.emoji,
      'content': instance.content,
      'userUid': instance.userUid,
      'id': instance.id,
    };

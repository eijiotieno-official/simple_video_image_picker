import 'dart:io';
import 'dart:typed_data';

import 'package:simple_video_image_picker/src/enums/pick_type_enum.dart';

class PickedItem {
  final String id;
  final String title;
  final File file;
  final Uint8List bytes;
  final PickType type;
  PickedItem({
    required this.id,
    required this.title,
    required this.file,
    required this.bytes,
    required this.type,
  });

  @override
  String toString() {
    return 'PickedItem(id: $id, title: $title, file: $file, bytes: $bytes, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PickedItem &&
      other.id == id &&
      other.title == title &&
      other.file == file &&
      other.bytes == bytes &&
      other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      file.hashCode ^
      bytes.hashCode ^
      type.hashCode;
  }

  PickedItem copyWith({
    String? id,
    String? title,
    File? file,
    Uint8List? bytes,
    PickType? type,
  }) {
    return PickedItem(
      id: id ?? this.id,
      title: title ?? this.title,
      file: file ?? this.file,
      bytes: bytes ?? this.bytes,
      type: type ?? this.type,
    );
  }
}

import 'package:hive/hive.dart';
part 'recent_file_model.g.dart';

@HiveType(typeId: 1)
class RecentFile {
  @HiveField(0)
  String path;
  @HiveField(1)
  int sizeInBytes;
  @HiveField(2)
  DateTime dateOpened;

  RecentFile({
    required this.path,
    required this.sizeInBytes,
    required this.dateOpened,
  });
}

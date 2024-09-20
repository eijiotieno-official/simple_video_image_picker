import 'package:photo_manager/photo_manager.dart';
import 'package:simple_video_image_picker/src/enums/pick_type_enum.dart';

class FetchService {
  static Future<void> _grantPermissions() async {
    try {
      final PermissionState permissionState =
          await PhotoManager.requestPermissionExtend();
      if (!permissionState.hasAccess) {
        throw Exception('Permission is not accessible.');
      }
    } catch (e) {
      throw Exception('Error granting permissions: $e');
    }
  }

  static Future<List<AssetPathEntity>> fetchAlbums(PickType pickType) async {
    try {
      await _grantPermissions();

      final FilterOptionGroup filterOptions = FilterOptionGroup(
        videoOption: const FilterOption(
          needTitle: true,
          sizeConstraint: SizeConstraint(ignoreSize: true),
        ),
        imageOption: const FilterOption(
          needTitle: true,
          sizeConstraint: SizeConstraint(ignoreSize: true),
        ),
      );

      final RequestType requestType = _getRequestType(pickType);

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: requestType,
        filterOption: filterOptions,
      );

      return albums;
    } catch (e) {
      throw Exception('Error fetching albums: $e');
    }
  }

  static RequestType _getRequestType(PickType pickType) {
    switch (pickType) {
      case PickType.image:
        return RequestType.image;
      case PickType.video:
        return RequestType.video;
      default:
        return RequestType.common;
    }
  }

  static Future<List<AssetEntity>> fetchEntities({
    required AssetPathEntity album,
    required int page,
  }) async {
    try {
      const int pageSize = 30;
      final List<AssetEntity> entities = await album.getAssetListPaged(
        page: page,
        size: pageSize,
      );

      return entities;
    } catch (e) {
      throw Exception('Error fetching media: $e');
    }
  }
}

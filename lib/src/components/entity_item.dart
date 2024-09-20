import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:transparent_image/transparent_image.dart';

class EntityItem extends StatelessWidget {
  final Function(AssetEntity) onTap;
  final AssetEntity entity;
  final bool isSelected;
  const EntityItem(
      {super.key,
      required this.onTap,
      required this.entity,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(entity),
      child: Stack(
        children: [
          _buildMediaWidget(),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.15),
              child: entity.type == AssetType.video
                  ? const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          if (isSelected) _buildIsSelectedOverlay(),
        ],
      ),
    );
  }

  Widget _buildMediaWidget() {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(isSelected ? 10.0 : 0.0),
        child: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          fit: BoxFit.cover,
          image: AssetEntityImageProvider(
            entity,
            thumbnailSize: const ThumbnailSize.square(500),
            isOriginal: false,
          ),
        ),
      ),
    );
  }

  Widget _buildIsSelectedOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.1),
        child: const Center(
          child: Icon(
            Icons.check_circle_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}

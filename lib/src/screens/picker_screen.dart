import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:simple_video_image_picker/simple_video_image_picker.dart';
import 'package:simple_video_image_picker/src/components/entity_item.dart';

import 'package:simple_video_image_picker/src/models/picked_item_model.dart';
import 'package:simple_video_image_picker/src/services/fetch_service.dart';

class PickerScreen extends StatefulWidget {
  final List<PickedItem> pickedItems;
  final Color backgroundColor;
  final Color accentColor;
  final PickType type;
  final int maxCount;
  const PickerScreen({
    super.key,
    required this.pickedItems,
    required this.backgroundColor,
    required this.accentColor,
    required this.type,
    required this.maxCount,
  });

  @override
  State<PickerScreen> createState() => _PickerScreenState();
}

class _PickerScreenState extends State<PickerScreen> {
  List<PickedItem> _pickedItems = [];

  Future<void> _confirm() async {}

  bool _isEntityPicked(AssetEntity entity) =>
      _selectedEntities.any((test) => test.id == entity.id);

  void _pickEntity(AssetEntity entity) {
    if (_isEntityPicked(entity)) {
      _selectedEntities.removeWhere((test) => test.id == entity.id);
    } else {
      _selectedEntities.add(entity);
    }
    setState(() {});
  }

  @override
  void initState() {
    _pickedItems = widget.pickedItems;
    super.initState();
    _loadAlbums();
    _scrollController.addListener(_loadMoreMedias);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMoreMedias);
    _scrollController.dispose();
    super.dispose();
  }

  void _loadAlbums() async {
    List<AssetPathEntity> albums =
        await FetchService.fetchAlbums(widget.type);
    if (albums.isNotEmpty) {
      setState(() {
        _currentAlbum = albums.first;
        _albums = albums;
      });
      _loadEntities();
    }
  }

  void _loadEntities() async {
    _lastPage = _currentPage;
    if (_currentAlbum != null) {
      List<AssetEntity> entities = await FetchService.fetchEntities(
        album: _currentAlbum!,
        page: _currentPage,
      );
      setState(() {
        _entities.addAll(entities);
      });
    }
  }

  void _loadMoreMedias() {
    if (_scrollController.position.pixels /
            _scrollController.position.maxScrollExtent >
        0.33) {
      if (_currentPage != _lastPage) {
        _loadEntities();
      }
    }
  }

  final ScrollController _scrollController = ScrollController();
  AssetPathEntity? _currentAlbum;
  List<AssetPathEntity> _albums = [];
  final List<AssetEntity> _entities = [];
  final List<AssetEntity> _selectedEntities = [];
  int _lastPage = 0;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<AssetPathEntity>(
          borderRadius: BorderRadius.circular(16.0),
          value: _currentAlbum,
          items: _albums
              .map(
                (e) => DropdownMenuItem<AssetPathEntity>(
                  value: e,
                  child: Text(e.name.isEmpty ? "0" : e.name),
                ),
              )
              .toList(),
          onChanged: (AssetPathEntity? value) {
            setState(() {
              _currentAlbum = value;

              _currentPage = 0;

              _lastPage = 0;

              _entities.clear();
            });

            _loadEntities();

            _scrollController.jumpTo(0.0);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: GridView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: _entities.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
          ),
          itemBuilder: (context, index) => EntityItem(
            entity: _entities[index],
            isSelected: _isEntityPicked(_entities[index]),
            onTap: _pickEntity,
          ),
        ),
      ),
      floatingActionButton: _selectedEntities.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: _confirm,
              child: const Icon(Icons.check_rounded),
            ),
    );
  }
}

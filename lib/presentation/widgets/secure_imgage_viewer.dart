import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/repositories/secure_storage_service.dart';

class SecureImageViewer extends StatefulWidget {
  final double radius;
  final String? overrideUrl;
  const SecureImageViewer({super.key, this.radius = 40, this.overrideUrl});

  @override
  State<SecureImageViewer> createState() => _SecureImageViewerState();
}

class _SecureImageViewerState extends State<SecureImageViewer> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
    final url = widget.overrideUrl ?? await SecureStorageService.getProfileImageUrl();
    if (mounted) {
      setState(() => _imageUrl = url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: Colors.grey[200],
      backgroundImage: _imageUrl != null
          ? CachedNetworkImageProvider(_imageUrl!)
          : null,
      child: _imageUrl == null
          ? Icon(Icons.person, size: widget.radius * 0.7)
          : null,
    );
  }
}
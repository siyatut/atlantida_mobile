import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductImageBox extends StatelessWidget {
  const ProductImageBox({
    super.key,
    required this.imageUrl,
    this.borderRadius = 16,
    this.backgroundColor,
    this.fit = BoxFit.contain,
  });

  final String? imageUrl;
  final double borderRadius;
  final Color? backgroundColor;
  final BoxFit fit;

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bg = backgroundColor ?? cs.surface;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: _hasImage
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: fit,
                placeholder: (_, __) => _Loader(
                  color: theme.progressIndicatorTheme.color,
                ),
                errorWidget: (_, __, ___) => _Placeholder(fit: fit),
              )
            : _Placeholder(fit: fit),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.fit});
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/placeholder-product.png',
      fit: fit,
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader({this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

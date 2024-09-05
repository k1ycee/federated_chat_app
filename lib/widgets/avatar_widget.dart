import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    this.size,
    this.color,
    this.url,
    this.bytes,
    this.icon,
    this.svgColor,
    this.showBorder = false,
    this.radius = 100,
  });

  final String? url;
  final Widget? icon;
  final Uint8List? bytes;
  final double? size;
  final Color? color, svgColor;
  final bool showBorder;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: showBorder
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    radius,
                  ), // Adjust the border radius as needed
                  border: Border.all(
                    color: Colors.white, // Set the border color to white
                    width: 1.0, // Set the border width as needed
                  ),
                )
              : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              height: size ?? 35,
              width: size ?? 35,
              color: color ?? Colors.transparent,
              child: Builder(
                builder: (context) {
                  if (icon != null) {
                    return icon!;
                  }

                  if (bytes != null) {
                    return Image.memory(
                      bytes!,
                      fit: BoxFit.cover,
                      height: size ?? 32,
                      width: size ?? 32,
                    );
                  }

                  if (url == null || url!.isEmpty) {
                    return const Icon(Icons.person);
                  }
                  if (url!.contains('.svg')) {
                    return SvgPicture.asset(
                      url!,
                      color: svgColor,
                      fit: BoxFit.cover,
                    );
                  }

                  return CachedNetworkImage(
                    imageUrl: url!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Icon(Icons.person),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

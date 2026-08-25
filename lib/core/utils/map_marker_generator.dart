import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:propertyhub/core/themes/app_colors.dart';
import 'package:propertyhub/core/themes/app_typography.dart';

class MapMarkerGenerator {
  static Future<BitmapDescriptor> createPriceMarker(String priceStr) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    const double width = 100.0;
    const double height = 48.0;
    const double borderRadius = 24.0; 
    const double arrowWidth = 12.0;
    const double arrowHeight = 8.0;
    
    final Rect rect = const Rect.fromLTWH(0.0, 0.0, width, height - arrowHeight);

    
    final Paint fillPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = AppColors.secondaryContainer
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final RRect rrect = RRect.fromRectAndRadius(rect, const Radius.circular(borderRadius));
    
    final Path path = Path();
    path.addRRect(rrect);
    
    path.moveTo(width / 2 - arrowWidth / 2, height - arrowHeight);
    path.lineTo(width / 2, height);
    path.lineTo(width / 2 + arrowWidth / 2, height - arrowHeight);
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: priceStr,
      style: TextStyle(
        fontFamily: AppTypography.serifFont,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: AppColors.secondaryContainer,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (width - textPainter.width) / 2,
        ((height - arrowHeight) - textPainter.height) / 2,
      ),
    );

    final ui.Image image = await pictureRecorder.endRecording().toImage(
      width.toInt(),
      height.toInt(),
    );
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(uint8List);
  }

  static String formatPrice(double price) {
    if (price >= 1000000) {
      return '\$${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '\$${(price / 1000).toStringAsFixed(0)}K';
    }
    return '\$${price.toStringAsFixed(0)}';
  }
}

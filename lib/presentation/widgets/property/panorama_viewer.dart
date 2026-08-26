import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PanoramaViewer extends StatefulWidget {
  final String imageUrl;
  final VoidCallback? onBack;

  const PanoramaViewer({
    super.key,
    required this.imageUrl,
    this.onBack,
  });

  @override
  State<PanoramaViewer> createState() => _PanoramaViewerState();
}

class _PanoramaViewerState extends State<PanoramaViewer> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(
        _getHtml(widget.imageUrl),
        baseUrl: 'https://storage.googleapis.com/',
      );
  }

  String _getHtml(String imageUrl) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <script src="https://cdnjs.cloudflare.com/ajax/libs/pannellum/2.5.6/pannellum.js"></script>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/pannellum/2.5.6/pannellum.css" />
      <style>
        body, html { margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; background: #000; }
        #panorama { width: 100%; height: 100%; }
        
        /* Move zoom controls to top right */
        .pnlm-controls-container {
          top: 60px !important;
          right: 20px !important;
          left: auto !important;
          bottom: auto !important;
          margin: 0 !important;
        }
        .pnlm-zoom-controls {
          top: 0 !important;
          right: 0 !important;
          left: auto !important;
          bottom: auto !important;
          margin: 0 !important;
        }
        
        /* Hide fullscreen button as we are in app */
        .pnlm-fullscreen-toggle-button {
          display: none !important;
        }
      </style>
    </head>
    <body>
      <div id="panorama"></div>
      <script>
        pannellum.viewer('panorama', {
          "type": "equirectangular",
          "panorama": "$imageUrl",
          "autoLoad": true,
          "autoRotate": 0,
          "compass": true,
          "controls": {
            "mouseZoom": true,
            "touchZoom": true
          }
        });
      </script>
    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '👆 Drag to explore 360° view',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

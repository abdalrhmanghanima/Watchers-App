import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart' as svg;
import 'package:flutter_svg/svg.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'renders the Watchers logo SVG to a 1024x1024 PNG for launcher icons',
    () async {
      const size = 1024;
      const source = 'assets/icons/watchers_logo.svg';
      final out = File('build/icons/watchers_logo.png');

      final svgString = File(source).readAsStringSync();
      final info = await vg.loadPicture(svg.SvgStringLoader(svgString), null);

      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      final fill = ui.Paint()..color = const ui.Color(0xFF09051A);
      canvas.drawRect(
        ui.Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        fill,
      );
      canvas.scale(size / info.size.width);
      canvas.drawPicture(info.picture);
      final picture = recorder.endRecording();

      final image = await picture.toImage(size, size);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      await out.parent.create(recursive: true);
      await out.writeAsBytes(bytes!.buffer.asUint8List());

      expect(out.lengthSync(), greaterThan(1000));
    },
  );
}

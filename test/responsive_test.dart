import 'package:flutter_test/flutter_test.dart';
import 'package:watchers/core/responsive/responsive_breakpoints.dart';
import 'package:watchers/core/responsive/responsive_sizes.dart';

void main() {
  group('DeviceBreakpoints', () {
    test('maps phone widths to the expected tier', () {
      expect(DeviceBreakpoints.tierOfWidth(320), DeviceTier.small);
      expect(DeviceBreakpoints.tierOfWidth(340), DeviceTier.small);
      expect(DeviceBreakpoints.tierOfWidth(359), DeviceTier.normal);
      expect(DeviceBreakpoints.tierOfWidth(360), DeviceTier.normal);
      expect(DeviceBreakpoints.tierOfWidth(390), DeviceTier.normal);
      expect(DeviceBreakpoints.tierOfWidth(411), DeviceTier.normal);
      expect(DeviceBreakpoints.tierOfWidth(412), DeviceTier.large);
      expect(DeviceBreakpoints.tierOfWidth(430), DeviceTier.large);
      expect(DeviceBreakpoints.tierOfWidth(480), DeviceTier.large);
    });

    test('default sizes reflect the design viewport', () {
      final normal = ResponsiveSizes.forTier(DeviceTier.normal);
      expect(normal.pagePadding, 16);
      expect(normal.sectionGap, 24);
      expect(normal.moviesHeroHeight, 420);
      expect(normal.heroTitleSize, 34);
    });
  });

  group('ResponsiveSizes', () {
    test('values scale up with the device tier', () {
      final small = ResponsiveSizes.forTier(DeviceTier.small);
      final normal = ResponsiveSizes.forTier(DeviceTier.normal);
      final large = ResponsiveSizes.forTier(DeviceTier.large);
      for (final value in [
        (small.pagePadding, normal.pagePadding, large.pagePadding),
        (small.sectionGap, normal.sectionGap, large.sectionGap),
        (small.blockGap, normal.blockGap, large.blockGap),
        (small.buttonHeight, normal.buttonHeight, large.buttonHeight),
        (small.profileAvatar, normal.profileAvatar, large.profileAvatar),
        (
          small.showDetailHeroHeight,
          normal.showDetailHeroHeight,
          large.showDetailHeroHeight,
        ),
        (small.posterSm.width, normal.posterSm.width, large.posterSm.width),
        (small.posterSm.height, normal.posterSm.height, large.posterSm.height),
        (small.posterMd.width, normal.posterMd.width, large.posterMd.width),
        (small.rowThumb.width, normal.rowThumb.width, large.rowThumb.width),
        (small.listThumb.width, normal.listThumb.width, large.listThumb.width),
      ]) {
        expect(value.$2 > value.$1, isTrue, reason: '$value');
        expect(value.$3 > value.$2, isTrue, reason: '$value');
      }
    });

    test('poster sizes keep the Figma 2:3 aspect ratio', () {
      for (final tier in DeviceTier.values) {
        final sizes = ResponsiveSizes.forTier(tier);
        for (final size in [
          sizes.posterSm,
          sizes.posterMd,
          sizes.posterLg,
          sizes.detailPoster,
        ]) {
          expect(size.width / size.height, closeTo(2 / 3, 0.01));
        }
      }
    });

    test('row and grid metrics stay inside the phone width', () {
      final small = ResponsiveSizes.forTier(DeviceTier.small, width: 320);
      final usable = 320 - small.pagePadding * 2;
      final gaps = small.gridSpacing * (small.gridColumns - 1);
      final cellWidth = (usable - gaps) / small.gridColumns;
      expect(cellWidth, greaterThan(90));
      expect(
        small.posterSm.width + small.pagePadding * 2,
        lessThanOrEqualTo(320),
      );
    });

    test('hero heights scale with the device height and clamp', () {
      final short = ResponsiveSizes.forTier(DeviceTier.normal, height: 568);
      final design = ResponsiveSizes.forTier(DeviceTier.normal, height: 844);
      final tall = ResponsiveSizes.forTier(DeviceTier.normal, height: 926);
      expect(short.moviesHeroHeight, closeTo(420 * 0.92, 0.01));
      expect(design.moviesHeroHeight, 420);
      expect(tall.moviesHeroHeight, closeTo(420 * 1.08, 0.01));
      expect(short.heightScale, closeTo(0.92, 0.01));
      expect(design.heightScale, 1.0);
      expect(tall.heightScale, closeTo(1.08, 0.01));
    });

    test('grid configuration stays consistent across tiers', () {
      for (final tier in DeviceTier.values) {
        final sizes = ResponsiveSizes.forTier(tier);
        expect(sizes.gridColumns, 3);
        expect(sizes.browseGenreColumns, 2);
      }
    });
  });
}

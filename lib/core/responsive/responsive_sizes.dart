import 'package:flutter/material.dart';

import 'responsive_breakpoints.dart';

class ResponsiveSizes {
  const ResponsiveSizes._(
    this.tier,
    this._v,
    this.screenWidth,
    this.screenHeight,
  );

  factory ResponsiveSizes.of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ResponsiveSizes._(
      DeviceBreakpoints.tierOfWidth(size.width),
      _values[DeviceBreakpoints.tierOfWidth(size.width)]!,
      size.width,
      size.height,
    );
  }

  static ResponsiveSizes forTier(
    DeviceTier tier, {
    double width = DeviceBreakpoints.designWidth,
    double height = DeviceBreakpoints.designHeight,
  }) => ResponsiveSizes._(tier, _values[tier]!, width, height);

  final DeviceTier tier;
  final double screenWidth;
  final double screenHeight;
  final _ResponsiveValues _v;

  double get heightScale =>
      (screenHeight / DeviceBreakpoints.designHeight).clamp(0.92, 1.08);

  double get pagePadding => _v.pagePadding;
  double get sectionGap => _v.sectionGap;
  double get blockGap => _v.blockGap;
  double get itemGap => _v.itemGap;

  Size get posterSm => _v.posterSm;
  Size get posterMd => _v.posterMd;
  Size get posterLg => _v.posterLg;
  Size get rowThumb => _v.rowThumb;
  Size get listThumb => _v.listThumb;
  Size get detailPoster => _v.detailPoster;
  Size get similarCard => _v.similarCard;
  Size get continueWatchingCard => _v.continueWatchingCard;
  Size get episodeThumb => _v.episodeThumb;

  double get buttonHeight => _v.buttonHeight;
  double get iconActionSize => _v.iconActionSize;
  double get iconButtonSize => _v.iconButtonSize;
  double get authModeButtonHeight => _v.authModeButtonHeight;
  double get searchFieldHeight => _v.searchFieldHeight;

  double get profileAvatar => _v.profileAvatar;
  double get castAvatar => _v.castAvatar;
  double get commentAvatar => _v.commentAvatar;
  double get commentInputAvatar => _v.commentInputAvatar;
  double get settingsAvatar => _v.settingsAvatar;
  double get statusIcon => _v.statusIcon;
  double get heroTitleSize => _v.heroTitleSize;

  double get moviesHeroHeight => _v.moviesHeroHeight * heightScale;
  double get showDetailHeroHeight => _v.showDetailHeroHeight * heightScale;
  double get movieDetailHeroHeight => _v.movieDetailHeroHeight * heightScale;

  int get gridColumns => _v.gridColumns;
  double get gridSpacing => _v.gridSpacing;
  int get browseGenreColumns => _v.browseGenreColumns;
  double get browseGenreSpacing => _v.browseGenreSpacing;

  static const Map<DeviceTier, _ResponsiveValues> _values = {
    DeviceTier.small: (
      pagePadding: 14,
      sectionGap: 20,
      blockGap: 12,
      itemGap: 12,
      posterSm: Size(96, 144),
      posterMd: Size(116, 174),
      posterLg: Size(132, 198),
      rowThumb: Size(48, 68),
      listThumb: Size(40, 56),
      detailPoster: Size(72, 108),
      similarCard: Size(88, 124),
      continueWatchingCard: Size(180, 100),
      episodeThumb: Size(80, 52),
      buttonHeight: 48,
      iconActionSize: 44,
      iconButtonSize: 36,
      authModeButtonHeight: 36,
      searchFieldHeight: 46,
      profileAvatar: 64,
      castAvatar: 52,
      commentAvatar: 32,
      commentInputAvatar: 28,
      settingsAvatar: 56,
      statusIcon: 64,
      heroTitleSize: 30,
      moviesHeroHeight: 380,
      showDetailHeroHeight: 280,
      movieDetailHeroHeight: 320,
      gridColumns: 3,
      gridSpacing: 6,
      browseGenreColumns: 2,
      browseGenreSpacing: 8,
    ),
    DeviceTier.normal: (
      pagePadding: 16,
      sectionGap: 24,
      blockGap: 16,
      itemGap: 12,
      posterSm: Size(104, 156),
      posterMd: Size(128, 192),
      posterLg: Size(148, 222),
      rowThumb: Size(52, 74),
      listThumb: Size(44, 62),
      detailPoster: Size(80, 120),
      similarCard: Size(96, 136),
      continueWatchingCard: Size(200, 112),
      episodeThumb: Size(88, 58),
      buttonHeight: 52,
      iconActionSize: 48,
      iconButtonSize: 36,
      authModeButtonHeight: 40,
      searchFieldHeight: 48,
      profileAvatar: 72,
      castAvatar: 56,
      commentAvatar: 36,
      commentInputAvatar: 32,
      settingsAvatar: 56,
      statusIcon: 72,
      heroTitleSize: 34,
      moviesHeroHeight: 420,
      showDetailHeroHeight: 300,
      movieDetailHeroHeight: 340,
      gridColumns: 3,
      gridSpacing: 8,
      browseGenreColumns: 2,
      browseGenreSpacing: 8,
    ),
    DeviceTier.large: (
      pagePadding: 20,
      sectionGap: 28,
      blockGap: 20,
      itemGap: 12,
      posterSm: Size(112, 168),
      posterMd: Size(144, 216),
      posterLg: Size(160, 240),
      rowThumb: Size(56, 80),
      listThumb: Size(48, 68),
      detailPoster: Size(88, 132),
      similarCard: Size(104, 148),
      continueWatchingCard: Size(224, 126),
      episodeThumb: Size(96, 64),
      buttonHeight: 56,
      iconActionSize: 52,
      iconButtonSize: 40,
      authModeButtonHeight: 44,
      searchFieldHeight: 52,
      profileAvatar: 80,
      castAvatar: 60,
      commentAvatar: 40,
      commentInputAvatar: 36,
      settingsAvatar: 56,
      statusIcon: 80,
      heroTitleSize: 38,
      moviesHeroHeight: 450,
      showDetailHeroHeight: 320,
      movieDetailHeroHeight: 360,
      gridColumns: 3,
      gridSpacing: 8,
      browseGenreColumns: 2,
      browseGenreSpacing: 10,
    ),
  };
}

typedef _ResponsiveValues = ({
  double pagePadding,
  double sectionGap,
  double blockGap,
  double itemGap,
  Size posterSm,
  Size posterMd,
  Size posterLg,
  Size rowThumb,
  Size listThumb,
  Size detailPoster,
  Size similarCard,
  Size continueWatchingCard,
  Size episodeThumb,
  double buttonHeight,
  double iconActionSize,
  double iconButtonSize,
  double authModeButtonHeight,
  double searchFieldHeight,
  double profileAvatar,
  double castAvatar,
  double commentAvatar,
  double commentInputAvatar,
  double settingsAvatar,
  double statusIcon,
  double heroTitleSize,
  double moviesHeroHeight,
  double showDetailHeroHeight,
  double movieDetailHeroHeight,
  int gridColumns,
  double gridSpacing,
  int browseGenreColumns,
  double browseGenreSpacing,
});

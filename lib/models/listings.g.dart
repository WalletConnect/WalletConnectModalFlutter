// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'listings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletDataImpl _$$WalletDataImplFromJson(Map<String, dynamic> json) =>
    _$WalletDataImpl(
      listing: Listing.fromJson(json['listing'] as Map<String, dynamic>),
      installed: json['installed'] as bool,
      recent: json['recent'] as bool,
    );

Map<String, dynamic> _$$WalletDataImplToJson(_$WalletDataImpl instance) =>
    <String, dynamic>{
      'listing': instance.listing.toJson(),
      'installed': instance.installed,
      'recent': instance.recent,
    };

_$ListingResponseImpl _$$ListingResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ListingResponseImpl(
      listings: (json['listings'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Listing.fromJson(e as Map<String, dynamic>)),
      ),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$$ListingResponseImplToJson(
        _$ListingResponseImpl instance) =>
    <String, dynamic>{
      'listings': instance.listings.map((k, e) => MapEntry(k, e.toJson())),
      'total': instance.total,
    };

_$ListingImpl _$$ListingImplFromJson(Map<String, dynamic> json) =>
    _$ListingImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      homepage: json['homepage'] as String,
      imageId: json['image_id'] as String,
      app: App.fromJson(json['app'] as Map<String, dynamic>),
      injected: (json['injected'] as List<dynamic>?)
          ?.map((e) => Injected.fromJson(e as Map<String, dynamic>))
          .toList(),
      mobile: Redirect.fromJson(json['mobile'] as Map<String, dynamic>),
      desktop: Redirect.fromJson(json['desktop'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ListingImplToJson(_$ListingImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'homepage': instance.homepage,
    'image_id': instance.imageId,
    'app': instance.app.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('injected', instance.injected?.map((e) => e.toJson()).toList());
  val['mobile'] = instance.mobile.toJson();
  val['desktop'] = instance.desktop.toJson();
  return val;
}

_$AppImpl _$$AppImplFromJson(Map<String, dynamic> json) => _$AppImpl(
      browser: json['browser'] as String?,
      ios: json['ios'] as String?,
      android: json['android'] as String?,
      mac: json['mac'] as String?,
      windows: json['windows'] as String?,
      linux: json['linux'] as String?,
      chrome: json['chrome'] as String?,
      firefox: json['firefox'] as String?,
      safari: json['safari'] as String?,
      edge: json['edge'] as String?,
      opera: json['opera'] as String?,
    );

Map<String, dynamic> _$$AppImplToJson(_$AppImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('browser', instance.browser);
  writeNotNull('ios', instance.ios);
  writeNotNull('android', instance.android);
  writeNotNull('mac', instance.mac);
  writeNotNull('windows', instance.windows);
  writeNotNull('linux', instance.linux);
  writeNotNull('chrome', instance.chrome);
  writeNotNull('firefox', instance.firefox);
  writeNotNull('safari', instance.safari);
  writeNotNull('edge', instance.edge);
  writeNotNull('opera', instance.opera);
  return val;
}

_$InjectedImpl _$$InjectedImplFromJson(Map<String, dynamic> json) =>
    _$InjectedImpl(
      injectedId: json['injected_id'] as String,
      namespace: json['namespace'] as String,
    );

Map<String, dynamic> _$$InjectedImplToJson(_$InjectedImpl instance) =>
    <String, dynamic>{
      'injected_id': instance.injectedId,
      'namespace': instance.namespace,
    };

_$ListingParamsImpl _$$ListingParamsImplFromJson(Map<String, dynamic> json) =>
    _$ListingParamsImpl(
      page: (json['page'] as num?)?.toInt(),
      search: json['search'] as String?,
      entries: (json['entries'] as num?)?.toInt(),
      version: (json['version'] as num?)?.toInt(),
      chains: json['chains'] as String?,
      recommendedIds: json['recommendedIds'] as String?,
      excludedIds: json['excludedIds'] as String?,
      sdks: json['sdks'] as String?,
    );

Map<String, dynamic> _$$ListingParamsImplToJson(_$ListingParamsImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('page', instance.page);
  writeNotNull('search', instance.search);
  writeNotNull('entries', instance.entries);
  writeNotNull('version', instance.version);
  writeNotNull('chains', instance.chains);
  writeNotNull('recommendedIds', instance.recommendedIds);
  writeNotNull('excludedIds', instance.excludedIds);
  writeNotNull('sdks', instance.sdks);
  return val;
}

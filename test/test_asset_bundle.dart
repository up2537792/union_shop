import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

/// A tiny in-memory AssetBundle that returns safe content for common asset
/// requests used during widget tests. For images it returns a 1x1 PNG; for
/// manifest files it returns minimal valid content so the framework doesn't
/// throw when decoding structured binary data.
class TestAssetBundle extends CachingAssetBundle {
  static final Uint8List _kOnePxPng = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=');

  @override
  Future<ByteData> load(String key) async {
    final lk = key.toLowerCase();

    // Binary asset manifest may be requested by the framework; return a
    // valid StandardMessageCodec-encoded empty map so decoding doesn't fail.
    if (lk.endsWith('assetmanifest.bin') || lk.contains('assetmanifest.bin')) {
      final codec = const StandardMessageCodec();
      final ByteData? encoded = codec.encodeMessage(<String, dynamic>{});
      return encoded ?? ByteData(0);
    }

    // Textual manifests
    if (lk.endsWith('assetmanifest.json') || lk.endsWith('fontmanifest.json')) {
      final bytes = utf8.encode('{}');
      return ByteData.view(Uint8List.fromList(bytes).buffer);
    }

    // Images: return tiny 1x1 PNG
    if (lk.endsWith('.png') || lk.endsWith('.jpg') || lk.endsWith('.jpeg')) {
      return ByteData.view(_kOnePxPng.buffer);
    }

    // Default: small JSON body
    final bytes = utf8.encode('{}');
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    // Provide an empty string for any textual asset requests to avoid
    // throwing when tests call DefaultAssetBundle.of(context).loadString(...)
    return '';
  }

  @override
  Future<T> loadStructuredBinaryData<T>(String key, MessageCodec<T> codec) async {
    try {
      final ByteData? encoded = codec.encodeMessage(<String, dynamic>{});
      final T? decoded = codec.decodeMessage(encoded) as T?;
      if (decoded != null) return decoded;
    } catch (_) {
      // fallthrough to default
    }

    // As a fallback try decoding a null message, then coercing to T.
    try {
      final ByteData? encoded = codec.encodeMessage(null);
      final T? decoded = codec.decodeMessage(encoded) as T?;
      if (decoded != null) return decoded;
    } catch (_) {}

    // If we still don't have a value, return an empty map/string as appropriate.
    // This cast is safe for the typical structured types the framework expects.
    final fallback = <String, dynamic>{} as dynamic;
    return fallback as T;
  }
}

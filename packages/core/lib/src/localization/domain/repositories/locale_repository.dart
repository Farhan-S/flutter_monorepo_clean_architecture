import 'package:dartz/dartz.dart';

import '../../../network/api_exceptions.dart';
import '../entities/app_locale.dart';

/// Repository interface for locale operations
abstract class LocaleRepository {
  /// Get saved locale
  Future<Either<ApiException, AppLocale?>> getSavedLocale();

  /// Save locale preference
  Future<Either<ApiException, bool>> saveLocale(AppLocale locale);

  /// Clear saved locale (use system locale)
  Future<Either<ApiException, bool>> clearLocale();
}

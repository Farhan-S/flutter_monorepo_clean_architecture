import 'package:dartz/dartz.dart';

import '../../../network/api_exceptions.dart';
import '../entities/app_locale.dart';
import '../repositories/locale_repository.dart';

/// Use case to get saved locale
class GetSavedLocaleUseCase {
  final LocaleRepository repository;

  GetSavedLocaleUseCase(this.repository);

  Future<Either<ApiException, AppLocale?>> call() async {
    return await repository.getSavedLocale();
  }
}

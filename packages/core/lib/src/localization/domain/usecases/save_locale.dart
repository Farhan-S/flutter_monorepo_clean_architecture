import 'package:dartz/dartz.dart';

import '../../../network/api_exceptions.dart';
import '../entities/app_locale.dart';
import '../repositories/locale_repository.dart';

/// Use case to save locale preference
class SaveLocaleUseCase {
  final LocaleRepository repository;

  SaveLocaleUseCase(this.repository);

  Future<Either<ApiException, bool>> call(AppLocale locale) async {
    return await repository.saveLocale(locale);
  }
}

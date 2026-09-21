import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/features/auth/domain/usecases/authorize_admin_use_case.dart';
import 'package:ecommerce_admin/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login_use_case.dart';
import 'domain/usecases/logout_use_case.dart';
import 'presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(FirebaseAuth.instance, FirebaseFirestore.instance),
    );

    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()));

    Get.lazyPut<GetCurrentUserUseCase>(() => GetCurrentUserUseCase(Get.find<AuthRepository>()));

    Get.lazyPut<LoginUseCase>(() => LoginUseCase(Get.find<AuthRepository>()));

    Get.lazyPut<AuthorizeAdminUseCase>(() => AuthorizeAdminUseCase(Get.find<AuthRepository>()));

    Get.lazyPut<LogoutUseCase>(() => LogoutUseCase(Get.find<AuthRepository>()));

    Get.lazyPut<AuthController>(
      () => AuthController(
        Get.find<AuthorizeAdminUseCase>(),
        Get.find<LoginUseCase>(),
        Get.find<LogoutUseCase>(),
        Get.find<GetCurrentUserUseCase>(),
      ),
    );
  }
}

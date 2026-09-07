import '../../domain/entities/admin_user.dart';

class AdminUserModel extends AdminUser {
  const AdminUserModel({required super.id, required super.email, super.name});

  factory AdminUserModel.fromFirebase({required String id, required String email, String? name}) {
    return AdminUserModel(id: id, email: email, name: name);
  }

  AdminUser toEntity() {
    return AdminUser(id: id, email: email, name: name);
  }
}

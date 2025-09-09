class RegisterUser {
  final String id;
  final String username;
  final String email;
  final String role;
  final String loginType;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RegisterAvatar avatar;

  RegisterUser({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.loginType,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.avatar,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) {
    return RegisterUser(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      loginType: json['loginType'],
      isEmailVerified: json['isEmailVerified'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      avatar: RegisterAvatar.fromJson(json['avatar']),
    );
  }
}

class RegisterAvatar {
  final String url;
  final String localPath;
  final String id;

  RegisterAvatar({
    required this.url,
    required this.localPath,
    required this.id,
  });

  factory RegisterAvatar.fromJson(Map<String, dynamic> json) {
    return RegisterAvatar(
      url: json['url'],
      localPath: json['localPath'],
      id: json['_id'],
    );
  }
}

class RegisterApiResponse {
  final int statusCode;
  final RegisterUser? user;
  final String message;
  final bool success;

  RegisterApiResponse({
    required this.statusCode,
    this.user,
    required this.message,
    required this.success,
  });

  factory RegisterApiResponse.fromJson(Map<String, dynamic> json) {
    return RegisterApiResponse(
      statusCode: json['statusCode'],
      user:
          json['data'] != null && json['data']['user'] != null
              ? RegisterUser.fromJson(json['data']['user'])
              : null,
      message: json['message'],
      success: json['success'],
    );
  }
}

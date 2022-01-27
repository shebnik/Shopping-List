import 'dart:convert';

class AppUser {
  final String uid;
  final String email;
  
  AppUser({
    required this.uid,
    required this.email,
  });

  AppUser copyWith({
    String? uid,
    String? email,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) => AppUser.fromMap(json.decode(source));

  @override
  String toString() => 'AppUser(uid: $uid, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppUser &&
      other.uid == uid &&
      other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;
}

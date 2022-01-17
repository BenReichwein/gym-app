class User {
  String? name;
  String? email;
  String? phone;
  String? type;
  String? token;

  User({
    this.name = "", 
    this.email = "", 
    this.phone = "", 
    this.type = "", 
    this.token = "", 
  });

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        name: responseData['name'],
        email: responseData['email'],
        phone: responseData['phone'],
        type: responseData['type'],
        token: responseData['token'],
    );
  }
}
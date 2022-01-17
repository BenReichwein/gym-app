import 'dart:ffi';

String? validateEmail(String ?value) {
  // ignore: avoid_init_to_null
  String? _msg = null;
  RegExp regex = RegExp(r"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$");
  if (value!.isEmpty) {
    _msg = "Your email is required";
  } else if (!regex.hasMatch(value)) {
    _msg = "Please provide a valid emal address";
  }
  return _msg;
}
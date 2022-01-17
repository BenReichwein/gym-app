class AppUrl {
  static String localBaseURL = "http://localhost:8080/";

  static Uri login = Uri.parse(localBaseURL + "auth/login");
  static Uri register = Uri.parse(localBaseURL + "auth/register");
  static Uri getToken = Uri.parse(localBaseURL + "auth/gettoken");
}

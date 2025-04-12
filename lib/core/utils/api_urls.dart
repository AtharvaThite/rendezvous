class ApiUrls {
  const ApiUrls._();
  static const String baseUrl = 'http://15.207.23.3';

  static const String requestEmailCode =
      '$baseUrl/api/users/request-email-code';

  static const String verifyEmailCode = '$baseUrl/api/users/verify-email-code';
  static const String createUser = '$baseUrl/api/users/createUserNoReferral';
  static const String adminApproval = '$baseUrl/api/users/approveUser';
}

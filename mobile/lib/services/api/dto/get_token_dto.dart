class GetTokenDto {
  String? accessToken;
  String? detail;

  GetTokenDto({
    required this.accessToken,
  });

  GetTokenDto.error({
    required this.detail,
  });

  factory GetTokenDto.fromJson(Map<String, dynamic> json) {
    if (json['accessToken'] != null) {
      return GetTokenDto(
        accessToken: json['accessToken'],
      );
    }

    return GetTokenDto.error(detail: json['detail'] ?? 'неизвестная ошибка');
  }
}

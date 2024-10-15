class StoreDTO {
  final int id;
  final String name;
  final String uuid;
  final String type;
  final String logoURL;

  StoreDTO({
    required this.id,
    required this.name,
    required this.uuid,
    required this.type,
    required this.logoURL,
  });

  // JSON 데이터를 StoreDTO로 변환하는 팩토리 메서드
  factory StoreDTO.fromJson(Map<String, dynamic> json) {
    return StoreDTO(
      id: json['id'] ?? 0, // null일 경우 기본값 설정
      name: json['name'] ?? '이름 없음', // null일 경우 기본값 설정
      uuid: json['uuid'] ?? '',
      type: json['type'] ?? '',
      logoURL: json['logoURL'] ?? '',
    );
  }
}

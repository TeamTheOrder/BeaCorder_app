class StoreDTO {
  final int storeId;
  final String storeName;
  final String storeImg;
  final String examImg;

  StoreDTO({
    required this.storeId,
    required this.storeName,
    required this.storeImg,
    required this.examImg
  });

  // JSON 데이터를 StoreDTO로 변환하는 팩토리 메서드
  factory StoreDTO.fromJson(Map<String, dynamic> json) {
    return StoreDTO(
      storeId: json['storeId'] ?? 0, // null일 경우 기본값 설정
      storeName: json['storeName'] ?? '이름 없음', // null일 경우 기본값 설정
      storeImg: json['storeImg'] ?? '',
      examImg: json['examImg'] ?? '',
    );
  }
}

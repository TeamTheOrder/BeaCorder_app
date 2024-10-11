class BeaconDetail {
  final String storeName;
  final String storeImg;
  final int storeId;


  BeaconDetail({
    required this.storeId,
    required this.storeImg,
    required this.storeName
});

  factory BeaconDetail.fromJson(Map<String, dynamic> json) {
    return BeaconDetail(
      storeId: json['storeId'],
      storeName: json['storeName'],
      storeImg: json['storeImg']
    );
  }
}
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  // 실시간 업데이트를 위한 UUID 리스트
  static List<String> uuidList = [];

  // Manufacturer Data에서 UUID, major, minor 추출
  static String parseManufacturerData(Map<int, List<int>> manufacturerData) {
    List<int> data = manufacturerData[76]!;

    // UUID는 2번째부터 17번째 바이트까지 (16바이트)
    String uuid = data.sublist(2, 18).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    // Major는 18-19 바이트
    String major = data.sublist(18, 20).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    // Minor는 20-21 바이트
    String minor = data.sublist(20, 22).map((b) => b.toRadixString(16).padLeft(2, '0')).join();

    return 'UUID: $uuid, Major: $major, Minor: $minor';
  }

  // BLE 스캔 시작 및 실시간 스캔 결과를 UUIDList로 업데이트
  static Future<void> startBleScan() async {
    uuidList.clear();
    // Bluetooth 상태 확인 후 스캔 시작
    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

    // 스캔 시작 (10초간) - 특정 서비스 UUID 및 이름으로 필터링
    await FlutterBluePlus.startScan(
      withServices: [Guid("fff1")],  // 특정 서비스 UUID (fff1)를 필터링
      withNames: ["border"],         // 특정 이름 (border)로 필터링
      androidUsesFineLocation: true,
      timeout: const Duration(seconds: 5),  // 10초간 스캔
    );

    // 스캔 결과 처리 (실시간으로 스캔된 결과를 listen)
    FlutterBluePlus.onScanResults.listen((results) {
      for (ScanResult result in results) {
        // Manufacturer Data에서 UUID, major, minor 추출
        String parsedData = parseManufacturerData(result.advertisementData.manufacturerData);

        // 만약 Manufacturer Data에서 UUID를 추출했다면, 리스트에 추가
        if (parsedData.isNotEmpty) {
          String uuid = parsedData.split(', ')[0].replaceAll('UUID: ', '');  // UUID 부분만 추출

          // UUID가 중복되지 않으면 리스트에 추가
          if (!uuidList.contains(uuid)) {
            uuidList.add(uuid);

            // UUID 리스트 상태 변화 출력
            print("Updated UUID List: $uuidList");
          }
        }
      }
    });

    // 스캔이 종료될 때까지 대기
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
  }
}

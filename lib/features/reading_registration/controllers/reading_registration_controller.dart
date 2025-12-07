import 'package:get/get.dart';

class ReadingRegistrationController extends GetxController {
  // --- 상태 변수 ---

  // 1. 북스토퍼 기기 관련
  RxBool hasDevice = true.obs; // 기기 등록 여부
  RxBool isStopperConnected = true.obs; // 연결 상태 (블루투스)
  RxString customName = "Hechi Stopper Pro".obs; // 사용자가 설정한 이름
  final String modelName = "Hechi-SP-2025"; // 모델명 (불변)
  RxInt batteryLevel = 85.obs;

  // 기기 이름 (설정 이름 없으면 모델명 표시)
  String get displayDeviceName => customName.value.isEmpty ? modelName : customName.value;

  // 2. 현재 연결된 도서 (null이면 연결 안 됨)
  Rxn<Map<String, dynamic>> connectedBook = Rxn<Map<String, dynamic>>();

  // 3. 최근 연결된 도서 목록 (Mock Data)
  RxList<Map<String, dynamic>> recentBooks = <Map<String, dynamic>>[
    {'title': '좋아서 그래', 'image': 'https://via.placeholder.com/150/2'},
    {'title': '결국 너의 시간은 온다', 'image': 'https://via.placeholder.com/150/3'},
    {'title': '키스 자렛', 'image': 'https://via.placeholder.com/150/4'},
    {'title': '그 비스크 돌은 사랑을 한다', 'image': 'https://via.placeholder.com/150/5'},
  ].obs;

  // --- Actions ---

  // 블루투스 연결/해제 토글
  void toggleConnection() {
    isStopperConnected.value = !isStopperConnected.value;
  }

  // 상세 페이지 이동
  void navigateToStopperDetail() {
    Get.toNamed('/reading_registration/stopper_detail');
  }

  // 최근 도서 목록 페이지 이동
  void navigateToRecentBooksList() {
    Get.toNamed('/reading_registration/recent_books');
  }

  // [수정] 도서 연결 (책 선택 시)
  void connectBook(Map<String, dynamic> newBook) {
    // 1. 만약 기존에 연결되어 있던 책이 있다면, 최근 목록의 맨 앞으로 복귀시킴
    if (connectedBook.value != null) {
      recentBooks.insert(0, connectedBook.value!);
    }

    // 2. 새로 연결할 책이 최근 목록에 있다면 제거 (목록에서 안 보이게)
    // title을 기준으로 같은 책인지 확인하여 제거
    recentBooks.removeWhere((book) => book['title'] == newBook['title']);

    // 3. 새 책 연결
    connectedBook.value = newBook;

    Get.snackbar("연결 완료", "${newBook['title']} 도서가 연결되었습니다.",
        snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
  }

  // [수정] 도서 연결 해제
  void disconnectBook() {
    if (connectedBook.value != null) {
      // 1. 해제되는 책을 최근 목록의 맨 앞으로 이동
      recentBooks.insert(0, connectedBook.value!);

      // 2. 연결 상태 초기화
      connectedBook.value = null;
    }
  }

  // [상세 페이지 기능] 기기 연결 해제 (단순 연결 끊기)
  void disconnectDeviceAction() {
    isStopperConnected.value = false;
    Get.back(); // 상세 페이지 닫기
    Get.snackbar("알림", "기기 연결이 해제되었습니다.", snackPosition: SnackPosition.BOTTOM);
  }

  // [상세 페이지 기능] 이 기기 지우기
  void forgetDeviceAction() {
    // 기기를 지울 때도 책 연결은 해제되므로, 책을 목록으로 돌려놓는 것이 안전함
    if (connectedBook.value != null) {
      recentBooks.insert(0, connectedBook.value!);
      connectedBook.value = null;
    }

    hasDevice.value = false;
    isStopperConnected.value = false;

    Get.until((route) => Get.currentRoute == '/reading_registration'); // 메인으로 복귀
    Get.snackbar("알림", "기기가 삭제되었습니다.", snackPosition: SnackPosition.BOTTOM);
  }
}
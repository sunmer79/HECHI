import 'package:get/get.dart';
import '../services/api_service.dart';

class BookNoteProvider {
  final ApiService api = ApiService();

  Future<List> fetchBookmarks(int bookId) async {
    return await api.get("/bookmarks/books/$bookId");
  }

  Future<Map<String, dynamic>> createBookmark(int bookId, int page) async {
    return await api.post("/bookmarks/", {"book_id": bookId, "page": page});
  }

  Future<void> deleteBookmark(int id) async {
    await api.delete("/bookmarks/$id");
  }

  Future<List> fetchHighlights(int bookId) async {
    return await api.get("/highlights/books/$bookId");
  }

  Future<Map<String, dynamic>> createHighlight(
      int bookId, int page, String sentence, bool isPublic) async {
    return await api.post("/highlights/",
        {"book_id": bookId, "page": page, "sentence": sentence, "is_public": isPublic});
  }

  Future<Map<String, dynamic>> updateHighlight(int id, bool isPublic, String sentence) async {
    return await api.put("/highlights/$id", {"is_public": isPublic, "sentence": sentence});
  }

  Future<void> deleteHighlight(int id) async {
    await api.delete("/highlights/$id");
  }

  Future<List> fetchMemos(int bookId) async {
    return await api.get("/notes/books/$bookId");
  }

  Future<Map<String, dynamic>> createMemo(int bookId, int? page, String content) async {
    return await api.post("/notes/", {"book_id": bookId, "page": page, "content": content});
  }

  Future<Map<String, dynamic>> updateMemo(int id, String content) async {
    return await api.put("/notes/$id", {"content": content});
  }

  Future<void> deleteMemo(int id) async {
    await api.delete("/notes/$id");
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/local/local_db.dart';
import '../../../../data/todo_repository.dart';
import '../../../../data/memory/todo_data.dart';

mixin TodoDataProvider {}

class SearchFragment extends StatefulWidget with TodoDataProvider {
  const SearchFragment({
    Key? key,
  }) : super(key: key);
  @override
  _SearchFragmentState createState() => _SearchFragmentState();
}
class _SearchFragmentState extends State<SearchFragment> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoData = Get.find<TodoData>();
    return Material(
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: '검색을 해보세요',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _searchTodo();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                    () => ListView.builder(
                  itemCount: todoData.searchList.length,
                  itemBuilder: (context, index) {
                    final todo = todoData.searchList[index];
                    return ListTile(
                      title: Text(todo.title),
                      // 다른 필요한 정보 표시
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _searchTodo() async {
    final todoData = Get.find<TodoData>();
    final result = await LocalDB.instance.searchTodo(_searchController.text);

    if (result.isSuccess) {
      todoData.searchList.clear();
      todoData.searchList.addAll(result.successData);
      print('Search list updated: ${todoData.searchList}'); // 확인용 디버깅 출력
    } else if (result.isFailure) {
      Get.snackbar('에러', '검색 중 오류가 발생했습니다.');
    }
  }
}

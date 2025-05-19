import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/screens/users/widgets/item_user.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:flutter_app/widgets/header.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final ScrollController listViewScroll = ScrollController();
  final int limit = 10;

  List<Users> users = [];
  bool isLoading = false;
  int page = 1;
  bool isLoadMore = true;

  @override
  void initState() {
    super.initState();
    getData();
    listViewScroll.addListener(scrollListener);
  }

  void scrollListener() {
    if (listViewScroll.position.pixels >= listViewScroll.position.maxScrollExtent - 200 && !isLoading && isLoadMore) {
      getData();
    }
  }

  void getData() async {
    setState(() => isLoading = true);
    try {
      final res = await AuthService().getAllUser(page: page, limit: limit);
      setState(() {
        users.addAll(res.users);
        page = res.currentPage + 1;
        isLoadMore = res.users.length == limit;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: const Header(icon: Icons.people, title: "User", iconColor: Colors.blue),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              controller: listViewScroll,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: users.length + (isLoading ? 2 : 0),
              itemBuilder: (context, index) {
                if (isLoading && index >= users.length) {
                  return Skeletonizer(enabled: isLoading, child: ItemUser());
                }
                final user = users[index];

                return ItemUser(user: user);
              },
            ),
          ),
        ],
      ),
    );
  }
}

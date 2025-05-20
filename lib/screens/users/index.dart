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
  final ScrollController _scrollController = ScrollController();
  final int _limit = 10;

  List<Users> _users = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final nearBottom = _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200;
    if (nearBottom && !_isLoading && _hasMore) _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final res = await AuthService().getAllUser(page: _currentPage, limit: _limit);
      setState(() {
        _users.addAll(res.users);
        _currentPage++;
        _hasMore = res.users.length == _limit;
      });
    } catch (e) {
      print("Error loading users: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0), // Ẩn thanh AppBar
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Header(icon: Icons.people, title: "User", iconColor: Colors.blue),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: _users.length + (_isLoading ? 2 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index >= _users.length) {
                  return const Skeletonizer(enabled: true, child: ItemUser());
                }
                return ItemUser(user: _users[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

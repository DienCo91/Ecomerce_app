import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:intl/intl.dart';

class ItemUser extends StatelessWidget {
  const ItemUser({super.key, this.user});

  final Users? user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 20),
            _buildInfoSection('Email', user?.email ?? "#####", Icons.email_outlined),
            const Divider(height: 24),
            _buildInfoSection('Provider', user?.provider ?? 'Email', Icons.login_outlined),
            const Divider(height: 24),
            _buildAccountInfo(),
            const Divider(height: 24),
            _buildRoleSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue,
          child: Text(
            '${user?.firstName[0] ?? ""}${user?.lastName != '' ? user?.lastName[0] : ""}',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Name', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                '${user?.firstName} ${user?.lastName}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal.shade300, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountInfo() {
    String formattedDate;
    try {
      final createdDate = user?.created;
      formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(createdDate ?? DateTime.now());
    } catch (e) {
      formattedDate = 'Not available';
    }

    return Row(
      children: [
        Icon(Icons.calendar_today_outlined, color: Colors.teal.shade300, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Account Created', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(formattedDate, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSection() {
    return Row(
      children: [
        Icon(Icons.badge_outlined, color: Colors.teal.shade300, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Role', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.teal.shade100),
                ),
                child: Text(
                  user?.role ?? 'Member',
                  style: TextStyle(color: Colors.teal.shade700, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

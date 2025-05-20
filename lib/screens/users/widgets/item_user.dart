import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:intl/intl.dart';

class ItemUser extends StatelessWidget {
  const ItemUser({super.key, this.userData});

  final Users? userData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatarAndName(),
            const SizedBox(height: 20),
            _buildInfoRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: userData?.email ?? "N/A",
            ),
            const Divider(height: 24),
            _buildInfoRow(
              icon: Icons.login_outlined,
              label: 'Provider',
              value: userData?.provider ?? 'Email',
            ),
            const Divider(height: 24),
            _buildAccountCreatedDate(),
            const Divider(height: 24),
            _buildUserRole(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarAndName() {
    final initials = "${userData?.firstName?.characters.firstOrNull ?? ''}${userData?.lastName?.characters.firstOrNull ?? ''}";

    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue,
          child: Text(
            initials.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
                "${userData?.firstName ?? ''} ${userData?.lastName ?? ''}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
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

  Widget _buildAccountCreatedDate() {
    String createdDateText = 'Not available';
    try {
      final createdDate = userData?.created;
      if (createdDate != null) {
        createdDateText = DateFormat('EEEE, MMMM d, yyyy').format(createdDate);
      }
    } catch (_) {}

    return _buildInfoRow(
      icon: Icons.calendar_today_outlined,
      label: 'Account Created',
      value: createdDateText,
    );
  }

  Widget _buildUserRole() {
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
                  userData?.role ?? 'Member',
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

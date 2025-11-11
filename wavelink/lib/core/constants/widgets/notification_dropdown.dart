import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';

class NotificationDropdown {
  static OverlayEntry? _overlayEntry;

  /// Toggles the notification dropdown (open / close)
  static void toggle(BuildContext context, {VoidCallback? onViewAll}) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      return;
    }

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: kToolbarHeight + 8,
        right: 16,
        width: 280,
        child: Material(
          color: Colors.transparent,
          child: _buildDropdown(context, onViewAll),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  /// Builds the dropdown UI
  static Widget _buildDropdown(BuildContext context, VoidCallback? onViewAll) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.navy.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(
            '⚙ Maintenance Due',
            'Generator inspection pending today',
            AppColors.aqua,
          ),
          _buildItem(
            '🧱 Repair Submitted',
            'Dock Light Replacement logged successfully',
            AppColors.green,
          ),
          _buildItem(
            '⚠ Safety Alert',
            'Slip hazard reported near Terminal 3',
            AppColors.red,
          ),
          const Divider(color: Colors.white24),
          TextButton(
            onPressed: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
              if (onViewAll != null) onViewAll();
            },
            child: const Text(
              'View All',
              style: TextStyle(color: AppColors.aqua, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single notification row
  static Widget _buildItem(String title, String subtitle, Color color) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: color.withOpacity(0.8),
        child: const Icon(Icons.notifications, color: Colors.white, size: 16),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}

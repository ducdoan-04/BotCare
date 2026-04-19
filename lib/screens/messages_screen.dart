import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'chat_screen.dart';
import 'notification_screen.dart';
import 'new_message_sheet.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // Set to empty list [] to view Empty State
  final List<Map<String, dynamic>> _messages = [
    {
      'name': 'CareBot Assistant',
      'subtitle': 'Digital Medical Assistant',
      'time': '09.46 AM',
      'unread': 1,
      'type': 'Appointment',
      'isPinned': true,
      'isBot': true,
      'avatarId': null,
    },
    {
      'name': 'Jacob Jones',
      'subtitle': 'Poli Dermatologi',
      'time': '09.46 AM',
      'unread': 0,
      'type': 'Lab Result',
      'isPinned': false,
      'isBot': false,
      'avatarId': 1,
    },
    {
      'name': 'Jenny Wilson',
      'subtitle': 'Poli Cardiology',
      'time': '08.46 AM',
      'unread': 0,
      'type': 'Appointment',
      'isPinned': false,
      'isBot': false,
      'avatarId': 2,
    },
    {
      'name': 'Jenny Wilson',
      'subtitle': 'Poli Dermatologi',
      'time': '08.36 AM',
      'unread': 2,
      'type': 'Lab Result',
      'isPinned': false,
      'isBot': false,
      'avatarId': 3,
    },
    {
      'name': 'Jenny Wilson',
      'subtitle': 'Poli General Practitioners',
      'time': '07.46 AM',
      'unread': 0,
      'type': 'Appointment',
      'isPinned': false,
      'isBot': false,
      'avatarId': 4,
    },
    {
      'name': 'Jenny Wilson',
      'subtitle': 'General Practitioners',
      'time': '07.36 AM',
      'unread': 0,
      'type': 'Lab Result',
      'isPinned': false,
      'isBot': false,
      'avatarId': 5,
    },
    {
      'name': 'Jenny Wilson',
      'subtitle': 'Poli Cardiology',
      'time': '07.16 AM',
      'unread': 0,
      'type': 'Appointment',
      'isPinned': false,
      'isBot': false,
      'avatarId': 6,
    },
    {
      'name': 'Jenny Wilson',
      'subtitle': 'Poli Dermatologi',
      'time': '07.06 AM',
      'unread': 0,
      'type': 'Lab Result',
      'isPinned': false,
      'isBot': false,
      'avatarId': 7,
    },
  ];

  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar
            _buildAppBar(),

            // Main Content Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: _messages.isEmpty
                    ? _buildEmptyState()
                    : _buildPopulatedState(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Message',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          if (_messages.isEmpty)
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationScreen()));
              },
              child: _buildBadgeIcon(Icons.notifications_none, true),
            )
          else
            Row(
              children: [
                _buildHeaderIcon(Icons.search),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationScreen()));
                  },
                  child: _buildBadgeIcon(Icons.notifications_none, true),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const NewMessageSheet(),
                    );
                  },
                  child: _buildHeaderIcon(Icons.add,
                      color: const Color(0xFF008394), iconColor: Colors.white),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBadgeIcon(IconData iconData, bool hasBadge) {
    return Stack(
      children: [
        _buildHeaderIcon(iconData),
        if (hasBadge)
          Positioned(
            top: 10,
            right: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFE93C3C),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeaderIcon(IconData iconData, {Color? color, Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? Colors.white,
      ),
      child:
          Icon(iconData, color: iconColor ?? AppColors.textPrimary, size: 24),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFE6F2F3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 32,
              color: Color(0xFF008394),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your inbox is empty. Messages from patients\nand staff will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const NewMessageSheet(),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFF008394), width: 1.5),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Color(0xFF008394), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'New Message',
                    style: TextStyle(
                      color: Color(0xFF008394),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildPopulatedState() {
    final filteredMessages = _selectedCategory == 'All'
        ? _messages
        : _messages.where((m) => m['type'] == _selectedCategory).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Message list',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              _buildFilterChip('All', null),
              const SizedBox(width: 12),
              _buildFilterChip(
                  'Appointment', const Color(0xFFE93C3C)), // Red dot
              const SizedBox(width: 12),
              _buildFilterChip(
                  'Lab Result', const Color(0xFFD0D5DD)), // Grey dot
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Message List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: filteredMessages.length,
            itemBuilder: (context, index) {
              final msg = filteredMessages[index];
              return _buildMessageTile(
                context,
                name: msg['name'],
                subtitle: msg['subtitle'],
                time: msg['time'],
                unreadCount: msg['unread'],
                type: msg['type'],
                isPinned: msg['isPinned'],
                isBot: msg['isBot'],
                avatarId: msg['avatarId'],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, Color? dotColor) {
    bool isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF008394) : const Color(0xFFF2F4F7),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            if (dotColor != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF008394)
                    : const Color(0xFFA0A5A9),
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTile(
    BuildContext context, {
    required String name,
    required String subtitle,
    required String time,
    required int unreadCount,
    required String type,
    bool isPinned = false,
    bool isBot = false,
    int? avatarId,
  }) {
    Color dotColor = type == 'Appointment'
        ? const Color(0xFFE93C3C)
        : const Color(0xFFD0D5DD);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              name: name,
              subtitle: subtitle,
              avatarUrl: isBot
                  ? 'images/avatars/chatbot.jpg'
                  : 'images/avatars/avatar-${avatarId ?? 1}.jpg',
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(
            bottom: 24), // Increased spacing between items
        padding: isPinned
            ? const EdgeInsets.symmetric(vertical: 12, horizontal: 12)
            : const EdgeInsets.symmetric(horizontal: 12),
        decoration: isPinned
            ? BoxDecoration(
                color: const Color(0xFFF0FDF4), // Light teal tinted bg
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF008394), width: 1),
              )
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            SizedBox(
              width: 56,
              height: 56,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(16),
                      image: isBot
                          ? const DecorationImage(
                              image: AssetImage('images/avatars/chatbot.jpg'),
                              fit: BoxFit.cover,
                            )
                          : (avatarId != null
                              ? DecorationImage(
                                  image: AssetImage(
                                      'images/avatars/avatar-$avatarId.jpg'),
                                  fit: BoxFit.cover,
                                )
                              : null),
                    ),
                    child: null,
                  ),

                  // Online/Category Dot
                  Positioned(
                    top: -2,
                    right: 0, // Aligned towards the right edge of the avatar
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),

                  // Pinned Icon
                  if (isPinned)
                    Positioned(
                      top: -6,
                      left: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.push_pin,
                            color: Color(0xFFE93C3C), size: 12),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Trailing Info (Time & Badge)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                if (unreadCount > 0)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE93C3C),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(
                      height: 20), // Placeholder to keep height consistent
              ],
            ),
          ],
        ),
      ),
    );
  }
}

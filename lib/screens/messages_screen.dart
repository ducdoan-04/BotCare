import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Message',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: [
                      _buildHeaderIcon(Icons.search),
                      const SizedBox(width: 12),
                      _buildHeaderIcon(Icons.notifications_none),
                      const SizedBox(width: 12),
                      _buildHeaderIcon(Icons.add, color: AppColors.primary, iconColor: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            
            // White Container
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Message list',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          _buildFilterChip('All', true),
                          const SizedBox(width: 12),
                          _buildFilterChip('Appointment', false, colorDot: AppColors.error),
                          const SizedBox(width: 12),
                          _buildFilterChip('Lab Result', false, colorDot: AppColors.textLight),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Message List
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        children: [
                          _buildMessageTile(
                            context,
                            name: 'CareBot Assistant',
                            subtitle: 'Digital Medical Assistant',
                            time: '09.46 AM',
                            unreadCount: 1,
                            isBot: true,
                            isActive: true,
                            isHighlighted: true,
                          ),
                          _buildMessageTile(
                            context,
                            name: 'Jacob Jones',
                            subtitle: 'Poli Dermatologi',
                            time: '09.46 AM',
                            unreadCount: 0,
                            imageId: 11,
                          ),
                          _buildMessageTile(
                            context,
                            name: 'Jenny Wilson',
                            subtitle: 'Poli Cardiology',
                            time: '08.46 AM',
                            unreadCount: 0,
                            isActive: true,
                            imageId: 12,
                          ),
                          _buildMessageTile(
                            context,
                            name: 'Jenny Wilson',
                            subtitle: 'Poli Dermatologi',
                            time: '08.36 AM',
                            unreadCount: 2,
                            imageId: 13,
                          ),
                          _buildMessageTile(
                            context,
                            name: 'Jenny Wilson',
                            subtitle: 'Poli General Practitioners',
                            time: '07.46 AM',
                            unreadCount: 0,
                            isActive: true,
                            imageId: 14,
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData iconData, {Color? color, Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? AppColors.background,
        border: color == null ? Border.all(color: AppColors.border) : null,
      ),
      child: Icon(iconData, color: iconColor ?? AppColors.textPrimary, size: 24),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, {Color? colorDot}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          if (colorDot != null) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colorDot,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(
    BuildContext context, {
    required String name,
    required String subtitle,
    required String time,
    required int unreadCount,
    bool isBot = false,
    bool isActive = false,
    bool isHighlighted = false,
    int? imageId,
  }) {
    final avatarUrl = imageId != null ? 'https://i.pravatar.cc/150?img=$imageId' : 'https://i.pravatar.cc/150?img=41'; // Placeholder if no image ID. In reality, the bot might have an asset

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              name: name,
              subtitle: subtitle,
              avatarUrl: avatarUrl,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isHighlighted ? Border.all(color: AppColors.primary) : null,
        ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isBot ? Colors.blue.shade100 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  image: imageId != null 
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                ),
                child: isBot ? const Icon(Icons.smart_toy, color: Colors.blue, size: 32) : null,
              ),
              if (isActive)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          
          // Trail
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              if (unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ));
  }
}

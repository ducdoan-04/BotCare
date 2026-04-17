import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum MessageType {
  text,
  attachment,
  quickActionCenter,
  textWithButtons,
}

class ChatMessageData {
  final String text;
  final bool isMe;
  final String time;
  final String senderName;
  final String senderAvatar;
  final MessageType type;

  ChatMessageData({
    this.text = '',
    required this.isMe,
    required this.time,
    required this.senderName,
    required this.senderAvatar,
    this.type = MessageType.text,
  });
}

class ChatScreen extends StatefulWidget {
  final String name;
  final String subtitle;
  final String avatarUrl;

  const ChatScreen({
    super.key,
    this.name = 'Jacob Jones',
    this.subtitle = 'Poli Dermatologi',
    this.avatarUrl = 'https://i.pravatar.cc/150?img=11',
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String _myAvatar = 'https://i.pravatar.cc/150?img=47';

  late List<ChatMessageData> messages;

  @override
  void initState() {
    super.initState();
    // Combine all different mocked message designs from the images into one conversation flow to demonstrate the UI components
    messages = [
      ChatMessageData(
        text: "Hello, Jacob! Let me check. Could you please provide your test reference number or date of the test?",
        isMe: true,
        time: "09.35 AM",
        senderName: "You",
        senderAvatar: _myAvatar,
        type: MessageType.text,
      ),
      ChatMessageData(
        text: "Hi, I'm Jacob Jones. Can I get the results of my recent lab test?",
        isMe: false,
        time: "09.40 AM",
        senderName: widget.name,
        senderAvatar: widget.avatarUrl,
        type: MessageType.text,
      ),
      ChatMessageData(
        text: "",
        isMe: false,
        time: "",
        senderName: "",
        senderAvatar: "",
        type: MessageType.quickActionCenter, // Demonstrates the centered "Quick action" card
      ),
      ChatMessageData(
        text: "Hi Jacon Jones! 👋\n\nJust a reminder — your appointment with Brooklyn Simmons (Dermatology Department) is scheduled for:\n\n📅 Today – May 5, 2026\n🕒 5:23 PM (WIB)\n\nPlease choose one of the following options:",
        isMe: true,
        time: "09.46 AM",
        senderName: "You",
        senderAvatar: _myAvatar,
        type: MessageType.textWithButtons, // Demonstrates the bubble with Confirm/Reschedule buttons
      ),
      ChatMessageData(
        text: "Thank you! I've found your results. here are your lab results and don't hesitate to contact us if you have any further questions.",
        isMe: true,
        time: "09.48 AM",
        senderName: "You",
        senderAvatar: _myAvatar,
        type: MessageType.text,
      ),
      ChatMessageData(
        text: "",
        isMe: true,
        time: "09.50 AM",
        senderName: "You",
        senderAvatar: _myAvatar,
        type: MessageType.attachment, // Demonstrates the Lab Report PDF bubble
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessage(messages[index]);
                },
              ),
            ),
            _buildInputBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Optional back button since we navigate to it, even if design doesn't explicitly show it
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              widget.avatarUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 48,
                height: 48,
                color: Colors.grey.shade200,
                child: const Icon(Icons.person, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(widget.subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          _buildHeaderIcon(Icons.phone),
          const SizedBox(width: 8),
          _buildHeaderIcon(Icons.info_outline),
          const SizedBox(width: 8),
          _buildHeaderIcon(Icons.close),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData iconData) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Icon(iconData, size: 20, color: AppColors.textPrimary),
    );
  }

  Widget _buildMessage(ChatMessageData msg) {
    if (msg.type == MessageType.quickActionCenter) {
      return _buildQuickActionCenter();
    }

    CrossAxisAlignment alignment = msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          _buildBubbleContent(msg),
          const SizedBox(height: 8),
          _buildSenderInfo(msg),
        ],
      ),
    );
  }

  Widget _buildBubbleContent(ChatMessageData msg) {
    // Shared bubble decoration
    BoxDecoration bubbleDecoration = BoxDecoration(
      color: msg.isMe ? const Color(0xFFC4E4E6) : Colors.white, // Light teal for "You"
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        if (!msg.isMe)
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
      ],
    );

    Widget content;
    if (msg.type == MessageType.attachment) {
      // PDF Attachment Mock
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.white,
              height: 220,
              padding: const EdgeInsets.all(16),
              // Dummy content to look like a report document
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.science, color: Color(0xFF1E3A8A), size: 20),
                      const SizedBox(width: 8),
                      const Text("SMART PATHOLOGY LAB", style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const Divider(color: Color(0xFF1E3A8A), thickness: 2, height: 20),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _mockDocText("Yash M. Patel\nAge: 21 Years\nSex: Male", isSmall: true),
                      Container(width: 40, height: 40, color: Colors.grey.shade300), // QR mock
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("C.S.F. EXAMINATION ROUTINE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _mockDocText("Investigation\n\nChloride\nProteins", isSmall: true, isBold: true),
                      _mockDocText("Result\n\n101.40\n38.00", isSmall: true),
                      _mockDocText("Reference Value\n\n98-107\n20-45", isSmall: true),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              "Jacob_Jones_Lab_Report.pdf",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          )
        ],
      );
    } else if (msg.type == MessageType.textWithButtons) {
      // Text with Confirm/Reschedule buttons inside bubble
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            msg.text,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.5),
          ),
          const SizedBox(height: 16),
          _buildBubbleButton("Confirm", true),
          const SizedBox(height: 12),
          _buildBubbleButton("Reschedule", false),
        ],
      );
    } else {
      // Normal Text
      content = Text(
        msg.text,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.5),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: msg.type == MessageType.attachment ? const EdgeInsets.all(12) : const EdgeInsets.all(16),
      decoration: bubbleDecoration,
      child: content,
    );
  }

  Widget _mockDocText(String txt, {bool isSmall = false, bool isBold = false}) {
    return Text(
      txt,
      style: TextStyle(
        fontSize: isSmall ? 8 : 10,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: Colors.grey.shade800,
        height: 1.4,
      ),
    );
  }

  Widget _buildBubbleButton(String label, bool isPrimaryLightTarget) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isPrimaryLightTarget ? Colors.white : Colors.transparent, // Confirm is white inside the teal bubble
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.normal, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildSenderInfo(ChatMessageData msg) {
    List<Widget> children = [
      if (msg.isMe) ...[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${msg.senderName} • ${msg.time} ", style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const Icon(Icons.done_all, color: AppColors.primary, size: 14),
          ],
        ),
        const SizedBox(width: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            msg.senderAvatar,
            width: 28,
            height: 28,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(width: 28, height: 28, color: Colors.grey.shade200, child: const Icon(Icons.person, size: 16)),
          ),
        )
      ] else ...[
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            msg.senderAvatar,
            width: 28,
            height: 28,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(width: 28, height: 28, color: Colors.grey.shade200, child: const Icon(Icons.person, size: 16)),
          ),
        ),
        const SizedBox(width: 8),
        Text("${msg.senderName} • ${msg.time}", style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ]
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildQuickActionCenter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Text("Quick action", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              const SizedBox(height: 20),
              _buildQuickActionBtn("Appointment Management"),
              const SizedBox(height: 12),
              _buildQuickActionBtn("Emergency & Consultation"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionBtn(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF6F7), // extremely light cyan
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC4E4E6), width: 1.5),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildInputBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24), // Extra bottom padding for SafeArea overlap
      color: Colors.transparent, // It sits over the background
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter message',
                  hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            const Icon(Icons.image_outlined, color: AppColors.textSecondary, size: 24),
            const SizedBox(width: 16),
            const Icon(Icons.link_rounded, color: AppColors.textSecondary, size: 24),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF007A8A), // Teal
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

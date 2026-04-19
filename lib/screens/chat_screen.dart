import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'chat_detail_screen.dart';

enum MessageType {
  text,
  attachment,
  quickActionCenter,
  textWithButtons,
  systemAppointmentAction,
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
  final bool isNewChat;

  const ChatScreen({
    super.key,
    this.name = 'Jacob Jones',
    this.subtitle = 'Poli Dermatologi',
    this.avatarUrl = 'images/avatars/avatar-4.jpg',
    this.isNewChat = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String _myAvatar =
      'images/avatars/avatar-1.jpg'; // Match design girl avatar
  final String _botAvatar = 'images/avatars/chatbot.jpg';

  late List<ChatMessageData> messages;

  @override
  void initState() {
    super.initState();
    if (widget.isNewChat) {
      messages = [
        ChatMessageData(
          text: "",
          isMe: false, // system messages can just act neutral
          time: "",
          senderName: "",
          senderAvatar: "",
          type: MessageType.systemAppointmentAction,
        ),
      ];
    } else if (widget.name == 'CareBot Assistant') {
      messages = [
        ChatMessageData(
          text:
              "Hello! I'm CareBot. How can I help\nyou with your health schedule\ntoday?",
          isMe: false,
          time: "09.41 AM",
          senderName: "CareBot Assistant",
          senderAvatar: 'images/avatars/chatbot.jpg',
          type: MessageType.text,
        ),
        ChatMessageData(
          text: "",
          isMe: false,
          time: "",
          senderName: "",
          senderAvatar: "",
          type: MessageType.quickActionCenter,
        ),
        ChatMessageData(
          text: "I've been feeling a bit dizzy today,\nwhat should I do?",
          isMe: true,
          time: "09.41 AM",
          senderName: "You",
          senderAvatar: _myAvatar,
          type: MessageType.text,
        ),
      ];
    } else if (widget.name.contains('Jacob')) {
      messages = [
        ChatMessageData(
          text:
              "Hello, Jacob! Let me check.\nCould you please provide your test\nreference number or date of the\ntest?",
          isMe: true,
          time: "09.35 AM",
          senderName: "You",
          senderAvatar: _myAvatar,
          type: MessageType.text,
        ),
        ChatMessageData(
          text:
              "Hi, I'm Jacob Jones. Can I get the\nresults of my recent lab test?",
          isMe: false,
          time: "09.40 AM",
          senderName: widget.name,
          senderAvatar: widget.avatarUrl,
          type: MessageType.text,
        ),
        ChatMessageData(
          text:
              "Thank you! I've found your results.\nhere are your lab results and don't\nhesitate to contact us if you have\nany further questions.",
          isMe: true,
          time: "09.48 AM",
          senderName: "You",
          senderAvatar: _myAvatar,
          type: MessageType.text,
        ),
        ChatMessageData(
          text: "Jacob_Jones_Lab_Report.pdf", // Label text
          isMe: true,
          time: "09.36 AM", // Matched visual anachronism in screenshot
          senderName: "You",
          senderAvatar: _myAvatar,
          type: MessageType.attachment,
        ),
      ];
    } else {
      messages = [
        ChatMessageData(
          text: "",
          isMe: false, // system messages can just act neutral
          time: "",
          senderName: "",
          senderAvatar: "",
          type: MessageType.systemAppointmentAction,
        ),
        ChatMessageData(
          text:
              "appointment_reminder", // A special marker since we will use RichText
          isMe: true, // TEAL bubble
          time: "09.46 AM",
          senderName: "You",
          senderAvatar: _myAvatar,
          type: MessageType.textWithButtons,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
          0xFFF2F9F9), // Light greenish-blue background matching the design
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: _buildHeader(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(messages[messages.length - 1 - index]);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: _buildInputBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    bool isBot = widget.name == 'CareBot Assistant';
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Avatar
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    image: (widget.avatarUrl.startsWith('assets') ||
                            widget.avatarUrl.startsWith('http'))
                        ? null // handled by child below
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: (widget.avatarUrl.startsWith('assets') ||
                            widget.avatarUrl.startsWith('images'))
                        ? Image.asset(widget.avatarUrl,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) =>
                                const Icon(Icons.person, color: Colors.grey))
                        : widget.avatarUrl.startsWith('http')
                            ? Image.network(widget.avatarUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(
                                    Icons.person,
                                    color: Colors.grey))
                            : const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFE93C3C), // Red dot indicating online or appointment type
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Name and Subtitle
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(widget.subtitle,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          // Actions
          GestureDetector(
            onTap: () {},
            child: _buildHeaderIcon(Icons.phone),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailScreen(
                    name: widget.name,
                    subtitle: widget.subtitle,
                    avatarUrl: widget.avatarUrl,
                  ),
                ),
              );
            },
            child: _buildHeaderIcon(Icons.info_outline),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: _buildHeaderIcon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData iconData) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFFF2F4F7),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 20, color: AppColors.textPrimary),
    );
  }

  Widget _buildAvatar(String avatarUrl, {bool isBot = false}) {
    final bool isLocal =
        avatarUrl.startsWith('assets') || avatarUrl.startsWith('images');
    final bool isNetwork = avatarUrl.startsWith('http');

    Widget imageWidget;
    if (isLocal && avatarUrl.isNotEmpty) {
      imageWidget = Image.asset(
        avatarUrl,
        width: 36,
        height: 36,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _avatarPlaceholder(),
      );
    } else if (isNetwork) {
      imageWidget = Image.network(
        avatarUrl,
        width: 36,
        height: 36,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _avatarPlaceholder(),
      );
    } else {
      imageWidget = _avatarPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageWidget,
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      width: 36,
      height: 36,
      color: Colors.grey.shade200,
      child: const Icon(Icons.person, size: 20, color: Colors.grey),
    );
  }


  Widget _buildMessage(ChatMessageData msg) {
    if (msg.type == MessageType.systemAppointmentAction) {
      return Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Center(
          child: _buildSystemAppointmentAction(),
        ),
      );
    }

    if (msg.type == MessageType.quickActionCenter) {
      return Padding(
        padding: const EdgeInsets.only(
            top: 24.0), // Changed bottom to top for reverse list
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 48), // Padding equals avatar (36) + gap (12)
            Flexible(child: _buildQuickActionCenter()),
            const SizedBox(width: 24), // Padding on right
          ],
        ),
      );
    }

    CrossAxisAlignment alignment =
        msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.only(
          top: 24.0), // Changed bottom to top for reverse list
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Row(
            mainAxisAlignment:
                msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!msg.isMe) ...[
                _buildAvatar(msg.senderAvatar,
                    isBot: msg.senderName == 'CareBot Assistant'),
                const SizedBox(width: 12),
              ],
              Flexible(
                child: Container(
                  padding: msg.type == MessageType.attachment
                      ? EdgeInsets.zero
                      : const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: msg.type == MessageType.attachment
                        ? Colors.transparent
                        : (msg.isMe ? const Color(0xFFBBDCE2) : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(msg.isMe ? 16 : 0),
                      bottomRight: Radius.circular(msg.isMe ? 0 : 16),
                    ),
                  ),
                  child: _buildBubbleContent(msg),
                ),
              ),
              if (msg.isMe) ...[
                const SizedBox(width: 12),
                _buildAvatar(msg.senderAvatar),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment:
                msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!msg.isMe)
                const SizedBox(
                    width:
                        48), // Indent text under bubble, ignoring avatar space
              _buildSenderInfo(msg),
              if (msg.isMe) const SizedBox(width: 48), // Indent from right
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildBubbleContent(ChatMessageData msg) {
    Widget content;
    if (msg.type == MessageType.attachment) {
      content = Container(
        constraints: const BoxConstraints(maxWidth: 280),
        child: ClipRRect(
          borderRadius: msg.isMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(0))
              : const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(16)),
          child: Container(
            color: Colors.white,
            height: 280,
            child: Stack(
              children: [
                // Faked lab report graphic to strictly match UI without external image
                Positioned.fill(
                  child: Column(children: [
                    const SizedBox(height: 24),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.biotech,
                          color: Colors.blue.shade800, size: 28),
                      const SizedBox(width: 8),
                      Text("SMART PATHOLOGY LAB",
                          style: TextStyle(
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ]),
                    const SizedBox(height: 12),
                    Container(
                        height: 4,
                        width: double.infinity,
                        color: Colors.blue.shade800),
                    const SizedBox(height: 16),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                            children: List.generate(
                                6,
                                (i) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(children: [
                                      Container(
                                          height: 6,
                                          width: 40,
                                          color: Colors.grey.shade300),
                                      const Spacer(),
                                      Container(
                                          height: 6,
                                          width: 30,
                                          color: Colors.grey.shade300),
                                      const SizedBox(width: 20),
                                      Container(
                                          height: 6,
                                          width: 30,
                                          color: Colors.grey.shade300),
                                    ]))))),
                  ]),
                ),
                // Icon watermark mimic
                Positioned(
                  top: 120,
                  left: 100,
                  right: 100,
                  child: Icon(Icons.medication,
                      size: 80, color: Colors.grey.shade100),
                ),
                // Gradient overlay at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFBBE2E6)
                              .withOpacity(0.0), // Fade to teal
                          const Color(0xFFBBE2E6), // Solid teal at bottom
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    padding:
                        const EdgeInsets.only(left: 20, bottom: 20, top: 30),
                    alignment: Alignment.bottomLeft,
                    child: Text(msg.text,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (msg.type == MessageType.textWithButtons) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (msg.text == 'appointment_reminder')
            RichText(
              text: const TextSpan(
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.5,
                    fontFamily:
                        'Outfit'), // Replace fontfamily with standard if needed, or omit
                children: [
                  TextSpan(
                      text:
                          "Hi Jacon Jones! 👋\n\nJust a reminder — your appointment\nwith "),
                  TextSpan(
                      text: "Brooklyn Simmons",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " (Dermatology\nDepartment) is scheduled for:\n\n📅 Today – May 5, 2026\n🕒 5:23 PM (WIB)\n\nPlease choose one of the following\noptions:"),
                ],
              ),
            )
          else
            Text(msg.text,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textPrimary, height: 1.5)),
          const SizedBox(height: 16),
          _buildBubbleButton("Confirm", false),
          const SizedBox(height: 12),
          _buildBubbleButton("Reschedule", false),
        ],
      );
    } else {
      content = Text(
        msg.text,
        style: const TextStyle(
            fontSize: 14, color: AppColors.textPrimary, height: 1.5),
      );
    }

    return content;
  }

  Widget _buildBubbleButton(String label, bool isPrimaryLightTarget) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isPrimaryLightTarget ? Colors.white : const Color(0xFFDFEFF1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF66B0BD), width: 1.5),
      ),
      child: Center(
        child: Text(label,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
      ),
    );
  }

  Widget _buildSenderInfo(ChatMessageData msg) {
    List<Widget> children = [
      if (msg.isMe) ...[
        Text("You",
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(width: 4),
        Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
                color: Color(0xFFD0D5DD), shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(msg.time,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(width: 4),
        const Icon(Icons.check,
            color: Color(0xFF008394), size: 14), // Matches single teal check
      ] else ...[
        Text(msg.senderName,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(width: 4),
        Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
                color: Color(0xFFD0D5DD), shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(msg.time,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ]
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildSystemAppointmentAction() {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFC4E4E6), // Light teal background
        borderRadius: BorderRadius.circular(12), // Uniform circular corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Quick action",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          _buildSystemActionBtn("Confirm Appointment", true, onTap: () {
            setState(() {
              // Remove the quick action card
              messages.removeWhere(
                  (msg) => msg.type == MessageType.systemAppointmentAction);
              // Add the new reminder message
              messages.add(
                ChatMessageData(
                  text: "appointment_reminder",
                  isMe: true,
                  time: "09.46 AM",
                  senderName: "You",
                  senderAvatar: _myAvatar,
                  type: MessageType.textWithButtons,
                ),
              );
            });
          }),
          const SizedBox(height: 12),
          _buildSystemActionBtn("Reschedule Appointment", false),
        ],
      ),
    );
  }

  Widget _buildSystemActionBtn(String label, bool isPrimary,
      {VoidCallback? onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isPrimary
                ? const Color(0xFFE8F5F6)
                : const Color(0xFFE8F5F6), // Same styling for both
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF008394), width: 1.0),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                  color: AppColors
                      .textPrimary, // Texts are extremely dark blue/teal
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ));
  }

  Widget _buildQuickActionCenter() {
    return Container(
      width: 280, // Restrict width so it doesn't overly stretch
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(0), // Sharp bottom left
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Quick action",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          _buildQuickActionBtn("Appointment Management"),
          const SizedBox(height: 12),
          _buildQuickActionBtn("Emergency & Consultation"),
        ],
      ),
    );
  }

  Widget _buildQuickActionBtn(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5F6), // Light teal background
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF008394), width: 1.0),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
              color: Color(0xFF008394),
              fontSize: 13,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildInputBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      color: Colors.transparent, // Inherits Scaffold background color
      child: Container(
        height: 56, // Fixed typical pill shape height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter message',
                  hintStyle:
                      const TextStyle(color: Color(0xFFA0A5A9), fontSize: 15),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  filled:
                      false, // Prevents global theme from drawing an inner white box
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const Icon(Icons.image_outlined,
                color: Color(0xFF6B7280), size: 24),
            const SizedBox(width: 16),
            const Icon(Icons.link_rounded, color: Color(0xFF6B7280), size: 24),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF008394),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_outlined,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 4), // right spacing padding
          ],
        ),
      ),
    );
  }
}

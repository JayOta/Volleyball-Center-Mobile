import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/utils/user_utils.dart';

class UserGreeting extends StatefulWidget {
  final TextStyle? textStyle;
  final bool showDetails;
  
  const UserGreeting({
    super.key,
    this.textStyle,
    this.showDetails = false,
  });

  @override
  State<UserGreeting> createState() => _UserGreetingState();
}

class _UserGreetingState extends State<UserGreeting> {
  String _greeting = 'Carregando...';
  String _memberSince = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (UserUtils.isLoggedIn()) {
      final greeting = await UserUtils.getGreeting();
      final memberSince = UserUtils.getMemberSince();
      
      setState(() {
        _greeting = greeting;
        _memberSince = memberSince;
      });
    } else {
      setState(() {
        _greeting = 'Bem-vindo ao Volleyball Center!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting,
          style: widget.textStyle ?? const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF14276B),
          ),
        ),
        if (widget.showDetails && UserUtils.isLoggedIn() && _memberSince.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            _memberSince,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }
}

// Widget simples para mostrar dados do usuário
class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    if (!UserUtils.isLoggedIn()) {
      return const Text('Usuário não logado');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email: ${UserUtils.getUserEmail()}'),
        Text('Nome: ${UserUtils.getUserDisplayName()}'),
        Text('Email verificado: ${UserUtils.isEmailVerified() ? 'Sim' : 'Não'}'),
        Text('Membro: ${UserUtils.getMemberSince()}'),
      ],
    );
  }
}

// Widget para mostrar avatar/iniciais do usuário
class UserAvatar extends StatefulWidget {
  final double size;
  
  const UserAvatar({super.key, this.size = 40});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  String _initials = 'U';

  @override
  void initState() {
    super.initState();
    _loadInitials();
  }

  Future<void> _loadInitials() async {
    if (UserUtils.isLoggedIn()) {
      final name = await UserUtils.getUserName();
      final words = name.split(' ');
      String initials = '';
      
      if (words.isNotEmpty) {
        initials += words.first.isNotEmpty ? words.first[0].toUpperCase() : '';
      }
      if (words.length > 1) {
        initials += words.last.isNotEmpty ? words.last[0].toUpperCase() : '';
      }
      
      setState(() {
        _initials = initials.isNotEmpty ? initials : 'U';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.size / 2,
      backgroundColor: const Color(0xFF14276B),
      child: Text(
        _initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: widget.size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
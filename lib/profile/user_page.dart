import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/data/fire_user_dao.dart';
import '../common/data/user.dart';
import '../common/data/user_dao.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    final _userDao = Provider.of<UserDao>(context, listen: false);
    final _fireUserDao = Provider.of<FireUserDao>(context, listen: false);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title:
              Text(userId == _fireUserDao.userId() ? 'Мой профиль' : 'Профиль'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SafeArea(
          child: FutureBuilder<User>(
            future: _userDao.getUserByUid(userId),
            builder: (context, snapshot) => snapshot.hasData
                ? ProfileListView(
                    user: snapshot.data!,
                    fireUserDao: _fireUserDao,
                  )
                : const Center(
                    child: LinearProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }
}

class ProfileListView extends StatefulWidget {
  const ProfileListView({
    Key? key,
    required this.user,
    required this.fireUserDao,
  }) : super(key: key);
  final User user;
  final FireUserDao fireUserDao;

  @override
  State<ProfileListView> createState() => _ProfileListViewState();
}

class _ProfileListViewState extends State<ProfileListView> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void initState() {
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMessageCreatorAvatar(widget.user.photoUrl),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: firstNameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Имя',
                    ),
                  ),
                  TextField(
                    controller: lastNameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Фамилия',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Builder(
          builder: (context) =>
              widget.user.reference!.id == widget.fireUserDao.userId()
                  ? ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Временно не работает')),
                        );

                        return;
                        // widget.fireUserDao.logout().then((value) {
                        //   Navigator.popUntil(
                        //     context,
                        //     (ModalRoute.withName('/login')),
                        //   );
                        // });
                      },
                      child: const Text('Выйти из аккаунта'),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
        ),
      ],
    );
  }

  Widget _buildMessageCreatorAvatar(String? userAvatarUrl) {
    return CircleAvatar(
      maxRadius: 64,
      backgroundImage: NetworkImage(userAvatarUrl ??
          'https://firebasestorage.googleapis.com/v0/b/newu-share-taxi.appspot.com/o/avatar.png?alt=media&token=735f2da2-a631-4650-9372-0ba9bfa673aa'),
    );
  }
}

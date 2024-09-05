import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix_project/core/services/matrix_service.dart';
import 'package:matrix_project/core/services/navigation_service.dart';
import 'package:matrix_project/views/chat_page.dart';
import 'package:matrix_project/views/login.dart';

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  _RoomListPageState createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  void _logout() async {
    final client = MatrixService.client;
    await client.logout();
    navigator.replaceTop(const LoginPage());
  }

  void _join(Room room) async {
    if (room.membership != Membership.join) {
      await room.join();
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RoomPage(room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final client = MatrixService.client;
    return Scaffold(
      backgroundColor: Colors.black12,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MatrixService.client.inviteUser('', '');
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: const Text(
          'Chats',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: _logout,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: client.onSync.stream,
        builder: (context, _) => ListView.builder(
          itemCount: client.rooms.length,
          itemBuilder: (context, i) {
            return ListTile(
              leading: CircleAvatar(
                foregroundImage: client.rooms[i].avatar == null
                    ? null
                    : NetworkImage(
                        client.rooms[i].avatar!
                            .getThumbnail(
                              client,
                              width: 56,
                              height: 56,
                            )
                            .toString(),
                      ),
              ),
              title: Row(
                children: [
                  Expanded(
                      child: Text(
                    client.rooms[i].displayname,
                    style: const TextStyle(color: Colors.white),
                  )),
                  if (client.rooms[i].notificationCount > 0)
                    Material(
                      borderRadius: BorderRadius.circular(99),
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child:
                            Text(client.rooms[i].notificationCount.toString()),
                      ),
                    )
                ],
              ),
              subtitle: Text(
                client.rooms[i].lastEvent?.body ?? 'No messages',
                maxLines: 1,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => _join(client.rooms[i]),
            );
          },
        ),
      ),
    );
  }
}

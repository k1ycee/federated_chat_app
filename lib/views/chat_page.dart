import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class RoomPage extends StatefulWidget {
  final Room room;
  const RoomPage({required this.room, super.key});

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late final Future<Timeline> _timelineFuture;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    _timelineFuture = widget.room.getTimeline(
        onChange: (i) {
          _listKey.currentState?.setState(() {});
        },
        onInsert: (i) {
          _listKey.currentState?.insertItem(i);
        },
        onRemove: (i) {
          _listKey.currentState?.removeItem(i, (_, __) => const ListTile());
        },
        onUpdate: () {});
    super.initState();
  }

  final TextEditingController _sendController = TextEditingController();

  void _send() {
    widget.room.sendTextEvent(_sendController.text.trim());
    _sendController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text(widget.room.displayname),
        backgroundColor: Colors.black12,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<Timeline>(
                future: _timelineFuture,
                builder: (context, snapshot) {
                  final timeline = snapshot.data;
                  if (timeline == null) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: AnimatedList(
                            key: _listKey,
                            reverse: true,
                            initialItemCount: timeline.events
                                .where((element) =>
                                    element.type == 'm.room.message')
                                .length,
                            itemBuilder: (context, i, animation) {
                              return timeline.events[i].relationshipEventId !=
                                      null
                                  ? Container()
                                  : ScaleTransition(
                                      scale: animation,
                                      child: Opacity(
                                        opacity:
                                            timeline.events[i].status.isSent
                                                ? 1
                                                : 0.5,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            foregroundImage: timeline.events[i]
                                                        .sender.avatarUrl ==
                                                    null
                                                ? null
                                                : NetworkImage(timeline
                                                    .events[i].sender.avatarUrl!
                                                    .getThumbnail(
                                                      widget.room.client,
                                                      width: 56,
                                                      height: 56,
                                                    )
                                                    .toString()),
                                          ),
                                          title: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                    timeline.events[i].sender
                                                        .calcDisplayname(),
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              ),
                                              Text(
                                                timeline
                                                    .events[i].originServerTs
                                                    .toIso8601String(),
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(
                                              timeline.events[i]
                                                  .getDisplayEvent(timeline)
                                                  .body,
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    );
                            }),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _sendController,
                    decoration: const InputDecoration(
                        hintText: 'Send message',
                        filled: true,
                        fillColor: Colors.white),
                  )),
                  IconButton(
                    icon: const Icon(
                      Icons.send_outlined,
                      color: Colors.white,
                    ),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

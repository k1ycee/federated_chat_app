import 'package:matrix/matrix.dart';
import 'package:matrix_project/core/utils/exception.dart';
import 'package:matrix_project/core/utils/extension/extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class MatrixService {
  static Client client = Client("matrix-server", databaseBuilder: (_) async {
    final dir = await getApplicationSupportDirectory();
    final database =
        await sqlite.openDatabase('${dir.toString()}/database.sqlite');
    final db = MatrixSdkDatabase(
      'matrix',
      database: database,
    );
    await db.open();
    return db;
  });

  static Future<void> init() async {
    try {
      const homeServerUrl = '';
      await client.checkHomeserver(Uri.parse(homeServerUrl));
      if (client.isLogged() == false) {
        await client.init();
      }
    } catch (e) {
      e.toString();
    }
  }

  static Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    if (client.isLogged() == false) {
      await init();
    }
    return await client.login(
      LoginType.mLoginPassword,
      password: password,
      identifier: AuthenticationUserIdentifier(user: username),
    );
  }

  static Future<Room> joinRoom(String roomId, [String username = '']) async {
    if (roomId.isEmpty) {
      final rid = await createRoom(username);
      Room room = Room(client: client, id: rid);
      return room;
    }
    Room room = Room(client: client, id: roomId);
    return room;
  }

  static Future<String> createRoom(String username) async {
    final roomId = await client.createRoom(
      invite: [username],
      isDirect: true,
      visibility: Visibility.private,
    );
    return roomId;
  }

  static Future<CachedProfileInformation> fetchUserProfile(
      String username) async {
    try {
      return await client.getUserProfile(username);
    } catch (e) {
      e.toString().showError();
      throw CustomExceptionHandler(message: e.toString());
    }
  }
}

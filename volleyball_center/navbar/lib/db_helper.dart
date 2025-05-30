import 'package:mysql/mysql.dart';
import 'package:path/path.dart';
import 'post.dart';

class DBHelper {
  static Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'posts.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE posts(id INTEGER PRIMARY KEY, title TEXT, body TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertPosts(List<Post> posts) async {
    final db = await initDb();
    for (var post in posts) {
      await db.insert('posts', post.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<List<Post>> getPosts() async {
    final db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query('posts');
    return List.generate(
      maps.length,
      (i) => Post(
        id: maps[i]['id'],
        title: maps[i]['title'],
        body: maps[i]['body'],
      ),
    );
  }
}

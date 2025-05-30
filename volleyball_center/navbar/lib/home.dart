import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post.dart';
import 'db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndSavePosts();
  }

  Future<void> fetchAndSavePosts() async {
    try {
      final response =
          await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        posts = data.map((json) => Post.fromJson(json)).toList();
      //  await DBHelper.insertPosts(posts);
      } else {
       // posts = await DBHelper.getPosts(); // fallback local
      }
    } catch (e) {
     // posts = await DBHelper.getPosts(); // offline fallback
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notícias")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                );
              },
            ),
    );
  }
}
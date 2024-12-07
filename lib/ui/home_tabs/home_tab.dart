// home_tab.dart
import 'package:be_social/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/post_provider.dart';
import '../../providers/user_provider.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Home')),
      body: FutureBuilder(
        future: Provider.of<PostProvider>(context, listen: false).fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Consumer<PostProvider>(
            builder: (context, postProvider, child) {
              return ListView.builder(
                itemCount: postProvider.posts.length,
                itemBuilder: (context, index) {
                  Post post = postProvider.posts[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    post.userProfileImageUrl),
                              ),
                              Text(post.userName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        if (post.imageUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.5,
                                  width: MediaQuery.of(context).size.width*0.9,
                                  child: Image.network(post.imageUrl!,fit: BoxFit.fitWidth,)),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width/2.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: (){},
                                          icon: Icon(Icons.favorite,size: 25,color: Colors.grey,)
                                      ),
                                      // Text(postProvider.countLikes(post.id)==0?"":postProvider.countLikes(post.id).toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                      Text("",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: (){
                                        //show comment box to enter
                                      },
                                      icon: Icon(Icons.message,size: 25,)),
                                  IconButton(
                                      onPressed: (){
                                        //share
                                      },
                                      icon: Icon(Icons.send,size: 25,)),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: (){
                                  //save in saved posts
                                },
                                icon: Icon(Icons.bookmark_border,size: 25,)),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(postProvider.posts[index].content),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

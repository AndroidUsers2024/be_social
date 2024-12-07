import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../model/user_model.dart';
import '../../providers/post_provider.dart';
import '../../providers/user_provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchUser();
    Provider.of<PostProvider>(context, listen: false).fetchUserPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        UserModel? user = userProvider.user;
        if (user == null) {
          return Center(child: CircularProgressIndicator());
        }

        _usernameController.text = user.username;
        _bioController.text = user.bio;

        return CustomScrollView(
         slivers: [
           Consumer<UserProvider>(
             builder: (context, value, child) {
               return SliverAppBar(
                 // pinned: true,
                 expandedHeight: 300.0,
                 automaticallyImplyLeading: false,
                 flexibleSpace: FlexibleSpaceBar(
                   background: Container(
                     color: Colors.deepPurple[200],
                     child: Padding(
                       padding: const EdgeInsets.only(left: 50.0,top: 50),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           CircleAvatar(
                             radius: 50,
                             backgroundImage: NetworkImage(
                                 value.user!.profileImageUrl),
                           ),
                           SizedBox(height: 10),
                           Text(
                             "Name: ${value.user!.username}",
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 24,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           Text(
                             "Mobile: ${value.user!.mobile}",
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 24,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           Text(
                             "Email: ${value.user!.email}",
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 24,
                               fontWeight: FontWeight.bold,
                             ),
                           ),

                           Text(
                             value.user!.bio,
                             style: TextStyle(color: Colors.white),
                           ),
                         ],
                       ),
                     ),
                   ),
                 ),
               );
             },
           ),
           Consumer<PostProvider>(
             builder: (context, postProvider, child) {
               return postProvider.userPosts==null?
                   CircularProgressIndicator()
               :SliverList(
                 delegate: SliverChildBuilderDelegate(
                       (context, index) {
                     return Card(
                       margin: EdgeInsets.all(8.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text(postProvider.userPosts[index].content),
                           ),
                           if (postProvider.userPosts[index].imageUrl != null)
                             Center(
                               child: Container(
                                   height: MediaQuery.of(context).size.height*0.5,
                                   width: MediaQuery.of(context).size.width*0.9,
                                   child: Image.network(postProvider.userPosts[index].imageUrl!,fit: BoxFit.fitWidth,)),
                             ),
                         ],
                       ),
                     );
                   },
                   childCount: postProvider.userPosts.length,
                 ),
               );
             },

           ),
         ],
        );


          /*Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.profileImageUrl != null
                      ? NetworkImage(user.profileImageUrl!)
                      : null,
                  child: user.profileImageUrl == null ? Icon(Icons.person, size: 50) : null,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                  enabled: _isEditing,
                ),
                TextField(
                  controller: _bioController,
                  decoration: InputDecoration(labelText: 'Bio'),
                  enabled: _isEditing,
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _isEditing
                          ? () async {
                        await userProvider.updateProfile(
                          user.id,
                          _usernameController.text,
                          _bioController.text,
                        );
                        setState(() {
                          _isEditing = false; // Disable editing after update
                        });
                      }
                          : () {
                        setState(() {
                          _isEditing = true; // Enable editing
                        });
                      },
                      child: Text(_isEditing ? 'Save' : 'Edit Profile'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle logout functionality
                      },
                      child: Text('Logout'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('Your Posts', style: TextStyle(fontSize: 20)),
                Expanded(
                  child: Consumer<PostProvider>(
                    builder: (context, postProvider, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
              itemCount: postProvider.posts.length,
              itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(postProvider.posts[index].content),
                        ),
                        if (postProvider.posts[index].imageUrl != null)
                          Center(
                            child: Container(
                                height: MediaQuery.of(context).size.height*0.5,
                                width: MediaQuery.of(context).size.width*0.9,
                                child: Image.network(postProvider.posts[index].imageUrl!,fit: BoxFit.fitWidth,)),
                          ),
                      ],
                    ),
                  );
              },
            );
                    },
                  ),
                ),
                *//*Expanded(
                  child: ListView.builder(
                    itemCount: 10, // Replace with actual post count
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Post ${index + 1}'), // Replace with actual post data
                      );
                    },
                  ),
                ),*//*
              ],
            ),
          ),
        );*/
      },
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:quenc/models/Post.dart';
// import 'package:quenc/providers/ReportGolangService.dart';
// import 'package:quenc/widgets/post/PostShowingContainer.dart';

// class PostWithRefresher extends StatefulWidget {
//   const PostWithRefresher({
//     Key key,
//   }) : super(key: key);

//   @override
//   _PostWithRefresherState createState() => _PostWithRefresherState();
// }

// class _PostWithRefresherState extends State<PostWithRefresher> {
//   OrderByOption orderBy = OrderByOption.LikeCount;
//   List<Post> retrievedPosts;
//   bool isInit = false;

//   void orderByUpdater(OrderByOption o) {
//     setToNull();
//     setState(() {
//       orderBy = o;
//     });
//     loadMore();
//   }

//   void setToNull() {
//     setState(() {
//       isInit = false;
//       retrievedPosts = null;
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies

//     if (!isInit) {
//       await loadMore();
//       isInit = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         refresh();
//       },
//       child: PostShowingContainer(
//         isInit: isInit,
//         posts: retrievedPosts,
//         infiniteScrollUpdater: loadMore,
//         refresh: refresh,
//         orderBy: orderBy,
//         orderByUpdater: orderByUpdater,
//       ),
//     );
//   }
// }

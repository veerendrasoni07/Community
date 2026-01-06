// import 'package:flutter/material.dart';
//
// class ContainerForAchievements extends StatelessWidget {
//   final double height;
//   final double width;
//   final String logo;
//   final String title;
//   final String desc;
//   final Color titlecolor;
//   final Color desccolor;
//
//   const ContainerForAchievements({
//     super.key,
//     required this.logo,
//     required this.title,
//     required this.desc,
//     required this.height,
//     required this.width, required this.titlecolor, required this.desccolor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       width: width,
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color.fromARGB(255, 88, 163, 200),
//             const Color.fromARGB(255, 37, 66, 80),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 15,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Expanded(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.asset(
//                 logo,
//                 height: 150,
//                 width: 200,
//                 color: Colors.black,
//                 fit: BoxFit.fill,
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.w800,
//                 fontSize: 28,
//                 color: titlecolor,
//                 letterSpacing: 1.2,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 12),
//             Text(
//               desc,
//               style: TextStyle(
//                 fontSize: 18,
//                 color: desccolor,
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

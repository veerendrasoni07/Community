import 'package:codingera2/provider/Admin_Provider/community_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/user.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}


class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(communityProvider.notifier).addCommunityMember(context: context,ref: ref);
  }
  @override
  Widget build(BuildContext context) {
    final members = ref.watch(communityProvider);
    return members.when(
        data: (members){
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Members",style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  )),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: members.length,
                      itemBuilder: (context,index){
                        final member = members[index];
                        return _memberTile(member);
                      }
                  )
                ],
              ),
            ),
          );
        },
        error: (error,stackTrace) => Center(child: Text(error.toString()),),
        loading: () => Center(child: CircularProgressIndicator(),)
    );
  }
  Widget _memberTile(User user){
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage:user.profilePic.isNotEmpty ? NetworkImage(user.profilePic) : null,
            child: user.profilePic.isEmpty ? Icon(Icons.person,size: 35,) : null,
          ),
          SizedBox(width: 10,),
          Text(user.fullname,style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white)
          )
        ]
      )
    );
  }
}


import 'package:codingera2/provider/clubProvider.dart';
import 'package:codingera2/views/widgets/modern_club_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubScreen extends ConsumerStatefulWidget {
  const ClubScreen({super.key});

  @override
  ConsumerState<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends ConsumerState<ClubScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(clubProvider.notifier).loadClub();
  }

  @override
  Widget build(BuildContext context) {
    final clubs = ref.watch(clubProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: clubs.when(
          loading: () =>
          const Center(child: CircularProgressIndicator()),

          error: (error, _) => Center(
            child: Text(
              error.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          data: (clubs) {
            return RefreshIndicator(
              onRefresh: () async {
                 await ref.read(clubProvider.notifier).loadClub();
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: clubs.length,
                itemBuilder: (context, index) {
                  return ModernClubTile(
                    index: index,
                    club: clubs[index],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

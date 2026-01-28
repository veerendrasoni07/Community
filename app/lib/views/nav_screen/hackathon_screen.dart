import 'package:codingera2/provider/hackathon_provider.dart';
import 'package:codingera2/views/widgets/modern_hackathon_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HackathonScreen extends ConsumerStatefulWidget {
  const HackathonScreen({super.key});

  @override
  ConsumerState<HackathonScreen> createState() => _HackathonScreenState();
}

class _HackathonScreenState extends ConsumerState<HackathonScreen> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(hackathonProvider.notifier).loadHackathon();
  }


  @override
  Widget build(BuildContext context) {
    final hackathons = ref.watch(hackathonProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: hackathons.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),

          error: (error, _) => Center(
            child: Text(
              error.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          data: (hackathons) {
            return RefreshIndicator(
              onRefresh: () async {
                // THIS is the key line
                 await ref.read(hackathonProvider.notifier).loadHackathon();
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: hackathons.length,
                itemBuilder: (context, index) {
                  return ModernHackathonTile(
                    index: index,
                    hackathon: hackathons[index],
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
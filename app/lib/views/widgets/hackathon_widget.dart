import 'package:codingera2/components/container_hackathon_tile.dart';
import 'package:codingera2/controllers/hackathon_controller.dart';
import 'package:codingera2/models/hackathon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HackathonWidget extends StatefulWidget {
  const HackathonWidget({super.key});

  @override
  State<HackathonWidget> createState() => _HackathonWidgetState();
}

class _HackathonWidgetState extends State<HackathonWidget> {
  final PageController _pageController = PageController();
  late Future<List<Hackathon>> futureHackathon;

  String formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('MMM d, y').format(date); // e.g., Jul 21, 2025
    } catch (_) {
      return rawDate; // fallback if parsing fails
    }
  }

  @override
  void initState() {
    super.initState();
    futureHackathon = HackathonController().loadHackathon();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureHackathon,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: TextStyle(color: Colors.redAccent),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "No Hackathons Available",
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          final hackathons = snapshot.data!;
          return SizedBox(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: hackathons.length,
              itemBuilder: (context, index) {
                final hackathon = hackathons[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8,
                  ),
                  child: Card(
                    elevation: 6,
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                            bottom: Radius.circular(20)
                          ),
                          child: Image.network(
                            hackathon.image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder:
                                (context, child, progress) =>
                                    progress == null
                                        ? child
                                        : Center(
                                          child: CircularProgressIndicator(),
                                        ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hackathon.name,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                hackathon.description ??
                                    "No description available.",
                                style: TextStyle(color: Colors.grey[300]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 20),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: ContainerTile(
                                          title: "Event Date",
                                          subtitle: formatDate(
                                            hackathon.eventdate,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: ContainerTile(
                                          title: "Registration Deadline",
                                          subtitle: formatDate(
                                            hackathon.deadline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ContainerTile(
                                          title: "Prize Pool",
                                          subtitle: hackathon.prize.toString(),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: ContainerTile(
                                          title: "Venue",
                                          subtitle: hackathon.venue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ContainerTile(
                                          title: "Team Size",
                                          subtitle:
                                              hackathon.teamsize.toString(),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: ContainerTile(
                                          title: "Level",
                                          subtitle: hackathon.level,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),

                              Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    // TODO: Navigate to details or registration
                                  },
                                  child: Text("Register"),
                                ),
                              ),
                              SizedBox(height: 20,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

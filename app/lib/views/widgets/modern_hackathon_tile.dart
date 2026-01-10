import 'package:codingera2/models/hackathon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernHackathonTile extends StatelessWidget {
  final int index;
  Hackathon hackathon;
  ModernHackathonTile({super.key,required this.index,required this.hackathon});

  final List<List<Color>> gradientPalette = [
    [Colors.deepPurple,Colors.pink, ],
    [Colors.indigo,Colors.blue, ],
    [Colors.teal,Colors.green, ],
    [Colors.deepOrange,Colors.orange,] ,
    [Colors.deepPurple,Colors.purple, ],
  ];

  @override
  Widget build(BuildContext context) {
    print(hackathon.status.isEmpty ? "status is empty" : hackathon.status);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // top colored container
            Container(
              height: MediaQuery.of(context).size.height*0.2,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration:  BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientPalette[index%gradientPalette.length],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row (chips)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statusChip(hackathon.status),
                      _prizeChip(hackathon.prize.toString()),
                    ],
                  ),

                  const Spacer(),

                  // Title
                  Text(
                    hackathon.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Description
                  Text(
                    hackathon.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Wrap(
              spacing: 2,
              runSpacing:5,
              children: [
                _cleanDetailChip(Icons.location_on,hackathon.eventdate.toString().split("T")[0]),
                _cleanDetailChip(Icons.location_on,hackathon.eventTime),
                _cleanDetailChip(Icons.location_on,"48 hours"),
                _cleanDetailChip(Icons.location_on,hackathon.venue,),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people),
                          Text(hackathon.totalTeam.toString())
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${(hackathon.totalTeam%hackathon.registered)*100}% Filled"),
                      )
                    ],
                  ),
                  ProgressIndicatorTheme(
                    data: ProgressIndicatorThemeData(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      linearMinHeight: 15,
                      color: Colors.green,
                    ),
                    child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade300,
                    value: hackathon.totalTeam%hackathon.registered == 0 ? 0 : hackathon.registered%hackathon.totalTeam.toDouble(),
                    valueColor: AlwaysStoppedAnimation<Color>(gradientPalette[index%gradientPalette.length][0]),
                  )),
                ],
              ),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width*0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(colors: gradientPalette[index%gradientPalette.length])
              ),
              child: Center(
                child: Text("Register Now",style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              ),
            ),
            SizedBox(height: 10,),
            
          ],
        )
      ),
    );
  }


  Widget _statusChip(String status) {
    return Chip(
      backgroundColor: Colors.white,
      label: Text(
        status,
        style: TextStyle(
          color:  Colors.pink,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  Widget _prizeChip(String prize) {
    return Chip(
      backgroundColor: Colors.white,
      label: Text(
        prize,
        style: TextStyle(
          color:  Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _cleanDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
          )
        ]
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }


}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernHackathonTile extends StatelessWidget {
  final int index;
  ModernHackathonTile({super.key,required this.index});

  final List<List<Color>> gradientPalette = [
    [Colors.deepPurple,Colors.pink, ],
    [Colors.indigo,Colors.blue, ],
    [Colors.teal,Colors.green, ],
    [Colors.deepOrange,Colors.orange,] ,
    [Colors.deepPurple,Colors.purple, ],
  ];

  @override
  Widget build(BuildContext context) {
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
                      _statusChip(),
                      _prizeChip("5000"),
                    ],
                  ),

                  const Spacer(),

                  // Title
                  Text(
                    "AI Innovation Challenge",
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
                    "Build innovative AI solutions to solve real-world problems",
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
                _cleanDetailChip(Icons.location_on,"Jan 15 2026"),
                _cleanDetailChip(Icons.location_on,"12:00 PM"),
                _cleanDetailChip(Icons.location_on,"48 hours"),
                _cleanDetailChip(Icons.location_on,"Tech Hub Building A",),
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
                          Text("150/200")
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("62% Filled"),
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
                    value: 0.5,
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


  Widget _statusChip() {
    return Chip(
      backgroundColor: Colors.white,
      label: Text(
        "Upcoming",
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
        "5000 Rs",
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

// import 'package:flutter/material.dart';
// import '/models/food_booth.dart';

// class BoothCard extends StatelessWidget {
//   final FoodBooth booth;
//   final VoidCallback onTap;

//   const BoothCard({required this.booth, required this.onTap, super.key});
//   @override
//   Widget build(BuildContext context) {
//     final hasAllergy = booth.allergy != null;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: 240, // Slightly wider for balance
//           height: 300, // Increased height to prevent overflow
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//             border: Border.all(
//               color: hasAllergy ? Colors.redAccent : Colors.transparent,
//               width: 2,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//                 child: Image.asset(
//                   booth.image,
//                   height: 140, // Slightly taller image
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       booth.name,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       booth.description,
//                       style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                       maxLines: 3, // Allow a bit more room for description
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BoothListItem extends StatelessWidget {
//   final FoodBooth booth;
//   final VoidCallback onTap;

//   const BoothListItem({required this.booth, required this.onTap, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 290,
//         height: 290,
//         margin: const EdgeInsets.only(top: 28),
//         child: Stack(
//           children: [
//             Positioned(
//               top: 28,
//               child: Container(
//                 width: 284,
//                 height: 230,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(25),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.35),
//                       blurRadius: 10,
//                       spreadRadius: 0,
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 50),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: Text(
//                           booth.name,
//                           style: const TextStyle(
//                             fontSize: 25,
//                             fontWeight: FontWeight.normal,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: Text(
//                           "Food Booth: ${booth.boothLocation}",
//                           style: const TextStyle(
//                             fontSize: 23,
//                             fontWeight: FontWeight.w300,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Center(
//                         child: Container(
//                           width: 182,
//                           height: 28,
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.05),
//                             borderRadius: BorderRadius.circular(25),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.45),
//                                 blurRadius: 5,
//                                 spreadRadius: 0,
//                               ),
//                             ],
//                           ),
//                           child: Center(
//                             child: Text(
//                               booth.genre,
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.normal,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 0,
//               left: 83,
//               child: Container(
//                 width: 118,
//                 height: 68,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(25),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.5),
//                       blurRadius: 10,
//                       spreadRadius: 0,
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Image.asset(
//                     booth.logoPath,
//                     width: 60,
//                     height: 50,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

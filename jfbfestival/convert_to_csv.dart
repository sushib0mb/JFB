// import 'dart:io';
// import 'lib/data/food_booths.dart';
// import 'lib/models/dish.dart';

// void main() {
//   final csvBuffer = StringBuffer();

//   // CSV headers
//   csvBuffer.writeln(
//     'name,image,description,allergy,booth_location,map_page_food_location,genre,logo_path,dish_image_path,is_vegan,payments,allergens,dishes'
//   );

//   for (var booth in foodBooths) {
//     csvBuffer.writeln(
//       '"${booth.name}",'
//       '"${booth.image}",'
//       '"${booth.description}",'
//       '"${booth.allergy}",'
//       '"${booth.boothLocation}",'
//       '"${booth.mapPageFoodLocation}",'
//       '"${booth.genre}",'
//       '"${booth.logoPath}",'
//       '"${booth.dishImagePath}",'
//       '${booth.isVegan},'
//       '"${booth.payments.join('|')}",'
//       '"${booth.allergens.join('|')}",'
//       '"${booth.dishes.map((d) => dishToCsv(d)).join('|')}"'
//     );
//   }

//   File('food_booths.csv').writeAsStringSync(csvBuffer.toString());
//   print('food_booths.csv generated successfully!');
// }

// // Helper function to serialize dishes
// String dishToCsv(Dish dish) {
//   return '${dish.name};${dish.description};${dish.price};${dish.allergens.join('/')};${dish.imagePath};${dish.isVegan}';
// }

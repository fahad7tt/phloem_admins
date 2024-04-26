// import 'package:flutter/material.dart';

// class ModuleSelectionWidget extends StatelessWidget {
//   final List<String> modules;
//   final List<String> selectedModules;
//   final Function(List<String>) onModulesSelected;

//   const ModuleSelectionWidget({
//     super.key,
//     required this.modules,
//     required this.selectedModules,
//     required this.onModulesSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Select Modules:'),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: modules.map((module) {
//             final isSelected = selectedModules.contains(module);
//             return GestureDetector(
//               onTap: () {
//                 final newSelectedModules = [...selectedModules];
//                 if (isSelected) {
//                   newSelectedModules.remove(module);
//                 } else {
//                   newSelectedModules.add(module);
//                 }
//                 onModulesSelected(newSelectedModules);
//               },
//               child: Chip(
//                 label: Text(module),
//                 backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
//                 textStyle: TextStyle(
//                   color: isSelected ? Colors.white : Colors.black,
//                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                   decoration: isSelected
//                       ? TextDecoration.lineThrough
//                       : TextDecoration.none,
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';
//
// class FileUploadScreen extends StatefulWidget {
//   const FileUploadScreen({super.key});
//
//   @override
//   State<FileUploadScreen> createState() => _FileUploadScreenState();
// }
//
// class _FileUploadScreenState extends State<FileUploadScreen> {
//   File? _file;
//   String _fileName = '';
//
//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'ppt', 'pptx', 'mp4', 'mov'],
//     );
//
//     if (result != null) {
//       setState(() {
//         _file = File(result.files.single.path!);
//         _fileName = result.files.single.name;
//       });
//     }
//   }
//
//   void _uploadFile() {
//     if (_file == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a file first')),
//       );
//       return;
//     }
//
//     // TODO: Implement file upload logic here
//     print('Uploading file: $_fileName');
//     // You would typically send the file to your server or cloud storage here
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload Resource'),
//         backgroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text(
//               'Select a file to upload:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.file_upload),
//               label: const Text('Choose File'),
//               onPressed: _pickFile,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               _fileName.isNotEmpty ? 'Selected file: $_fileName' : 'No file selected',
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: _uploadFile,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: const Text('Upload'),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.white,
//     );
//   }
// }
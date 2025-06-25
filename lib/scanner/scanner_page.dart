import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final List<File> _mediaFiles = [];
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  bool isCameraInitialized = false;
  bool isRecording = false;
  String predictionResult = "";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await _cameraController?.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final XFile image = await _cameraController!.takePicture();
      File imageFile = File(image.path);
      setState(() {
        _mediaFiles.add(imageFile);
      });
      await _sendImageToBackend(imageFile);
    }
  }

  Future<void> _sendImageToBackend(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.174.189:5000/predict'), // Replace with your IP
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: basename(imageFile.path),
      ),
    );
    var response = await request.send();
    if (response.statusCode == 200) {
      final resBody = await response.stream.bytesToString();
      final jsonData = json.decode(resBody);
      setState(() {
        predictionResult = jsonData['prediction'].toString();
      });
    } else {
      setState(() {
        predictionResult = 'Prediction failed.';
      });
    }
  }

  void _clearMedia() {
    setState(() {
      _mediaFiles.clear();
      predictionResult = '';
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner Page'),
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearMedia,
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          if (isCameraInitialized)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.primary, width: 4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CameraPreview(_cameraController!),
                    ),
                  ),
                  const SizedBox(height: 16),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, size: 40),
                    color: colorScheme.primary,
                    onPressed: _captureImage,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Text(
            predictionResult.isEmpty
                ? "Capture to detect disease"
                : "Result: $predictionResult",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _mediaFiles.length,
              itemBuilder: (context, index) {
                return Image.file(_mediaFiles[index], fit: BoxFit.cover);
              },
            ),
          ),
        ],
      ),
    );
  }
}

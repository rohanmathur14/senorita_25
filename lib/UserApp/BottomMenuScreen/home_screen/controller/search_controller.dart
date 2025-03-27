import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../../api_config/Api_Url.dart';

class SearchSalonController extends GetxController {
  final searchController = TextEditingController();
  final showPrefix = false.obs;
  final searchList = <dynamic>[].obs;
  final imgBaseUrl = ''.obs;
  final lat = ''.obs;
  final long = ''.obs;
  final isSearch = false.obs;

  late stt.SpeechToText _speech;
  RxBool isListening = false.obs;
  RxBool isSpeechAvailable = false.obs;
  RxList<int> waveform = <int>[].obs;
  Timer? _timer;
  final Random _random = Random();

  @override
  Future<void> onInit() async {
    super.onInit();
    await requestMicrophonePermission();
    _speech = stt.SpeechToText();
    isSearch.value = false;
    await initializeSpeech();

  }

  /// Request microphone permission
  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.microphone.request();

      if (status.isDenied) {
        print("❌ Microphone permission denied!");
      } else if (status.isPermanentlyDenied) {
        print("⚠️ Microphone permission permanently denied. Open app settings.");
        await openAppSettings(); // Opens app settings for manual permission grant
      } else {
        print("✅ Microphone permission granted.");
      }
    }
  }

  /// Initialize speech-to-text and check if it’s available
  Future<void> initializeSpeech() async {
    isSpeechAvailable.value = await _speech.initialize(
      onStatus: (status) {
        print('🎤 Speech Status: $status');
        if (status == 'notListening') {
          isListening.value = false; // ✅ Handle auto stop
          _timer?.cancel();
          waveform.value = [1, 1, 1, 1, 1];
          update();
        }
      },
      onError: (error) {
        print('❌ Speech Error: $error');
        isListening.value = false; // ✅ Handle errors
        _timer?.cancel();
        waveform.value = [1, 1, 1, 1, 1]; // Reset visualizer
      },

    );

    if (!isSpeechAvailable.value) {
      print("⚠️ Speech recognition is NOT available on this device!");
    } else {
      print("✅ Speech recognition is available.");
    }
  }

  /// Start listening to speech input
  void startListening() async {
    isListening.value = true;
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      waveform.value = List.generate(5, (_) => _random.nextInt(10) + 1);
    });
    if (!isSpeechAvailable.value) {
      print("⚠️ Speech recognition is not available. Ensure it's initialized properly.");
      return;
    }


    _speech.listen(
      onResult: (result) {
        allHomeScreenApiFunction(result.recognizedWords);
        searchController.text = result.recognizedWords;
        isListening.value = false;
        print("📝 Recognized Text: ${result.recognizedWords}");
        showPrefix.value = true;
        isSearch.value = false;


      },
    );
  }

  /// Stop listening
  void stopListening() {
    isListening.value = false;
    _timer?.cancel();
    waveform.value = [1, 1, 1, 1, 1]; // Reset visualizer
    _speech.stop();
    print("🛑 Stopped listening.");
  }

  /// Fetch salon data based on search query
  Future<void> allHomeScreenApiFunction(String searchValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lat.value = prefs.getString('lat') ?? '';
    long.value = prefs.getString('long') ?? '';

    var headers = {
      'Authorization': 'Bearer ${prefs.getString("token") ?? ""}'
    };

    var request = http.MultipartRequest('POST', Uri.parse(ApiUrls.homeScreen));
    request.fields.addAll({
      'search': searchValue,
      'lat': lat.value,
      'lng': long.value,
      'type': "load"
    });

    print("📡 API Request Data: ${request.fields}");
    request.headers.addAll(headers);

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse).timeout(const Duration(seconds: 60));
      searchList.clear();
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == true) {
          searchList.assignAll(result['data']['topRatedListing'] ?? []);
          imgBaseUrl.value = result['data']['listing_base_url'] ?? '';
          update();
        }
      }
    } catch (e) {
      print("❌ API Error: $e");
    }
  }
}

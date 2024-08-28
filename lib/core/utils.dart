import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tapintapout/backend/api/apiServices.dart';
import 'package:tapintapout/backend/printer/printServices.dart';
import 'package:tapintapout/backend/services/generator.dart';
import 'package:tapintapout/core/sweetalert.dart';

final myBox = Hive.box('myBox');
PrintServices printServices = PrintServices();
FlutterTts flutterTts = FlutterTts();
ApiServices apiServices = ApiServices();
GeneratorServices generatorServices = GeneratorServices();
SweetAlertUtils sweetAlertUtils = SweetAlertUtils();

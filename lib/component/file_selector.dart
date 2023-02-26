import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:untitled2/constants/Constants.dart';

class FileSelector{
  /// 图片选取
  static Future<String?> getDocument() async {
    FlutterDocumentPickerParams? params = FlutterDocumentPickerParams(
      // 允许选取的文件拓展类型，不加此属性则默认支持所有类型
      allowedFileExtensions: [Constants.BACKUP_FILE_EXT],
    );

    String? path = await FlutterDocumentPicker.openDocument(
      params: params,
    );

    return path;
  }
}
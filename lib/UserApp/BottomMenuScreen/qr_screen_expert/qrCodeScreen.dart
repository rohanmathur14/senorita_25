import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../utils/color_constant.dart';
import 'controller/qr_controller.dart';

class QrCodeScreen extends GetWidget<QRScannerController> {

  final QRScannerController qrScannerController = Get.put(QRScannerController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorConstant.screenBack.withOpacity(0.4),
      body: Column(
          children: [
            Expanded(
              child: QRView(
                key: controller.qrKey,
                onQRViewCreated: controller.onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.green,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            ),
            // Obx(() => Text(
            //   'Scanned Data: ${controller.scannedData.value}',
            //   style:const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // )),
          ],
      ),

    );
  }
  Widget _buildQrView(BuildContext context) {
    return GetBuilder<QRScannerController>(
      builder: (_) => QRView(
        key: qrScannerController.qrKey,
        onQRViewCreated: qrScannerController.onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );

  }
}



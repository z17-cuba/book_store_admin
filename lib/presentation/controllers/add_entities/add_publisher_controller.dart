import 'package:book_store_admin/core/loading_overlay.dart';
import 'package:book_store_admin/data/datasources/publisher_datasource.dart';
import 'package:book_store_admin/data/models/publisher_model.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_helper.dart';
import 'package:book_store_admin/presentation/widgets/toast/toast_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPublisherController extends GetxController {
  AddPublisherController({
    required this.publisherDatasource,
  });

  final PublisherDatasource publisherDatasource;

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController websiteUrlController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Future<void> createPublisher(BuildContext context) async {
    try {
      if (formKey.currentState!.validate()) {
        LoadingOverlay.show(context: context);

        final bool success = await publisherDatasource.createPublisher(
          publisher: PublisherModel(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            phone: phoneController.text.trim(),
            websiteUrl: websiteUrlController.text.trim(),
            address: addressController.text.trim(),
          ),
        );

        if (success && context.mounted) {
          LoadingOverlay.hide(context: context);
          Navigator.of(context).pop(); // Close the dialog
          ToastHelper.showToast(
            context: context,
            toast: ToastWithColor.success(
              message: 'app.createdPublisherSuccessfully'.tr,
            ),
          );
        }
      }
    } finally {
      if (context.mounted && LoadingOverlay.isShowing(context: context)) {
        LoadingOverlay.hide(context: context);
      }
    }
  }
}

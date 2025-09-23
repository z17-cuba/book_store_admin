import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class UploadFileCard extends StatelessWidget {
  /// The title of the card.
  final String? title;

  /// The name of the selected file.
  final String? fileName;

  /// The size of the selected file, as a formatted string (e.g., "2.5 MB").
  final String? fileSize;

  /// The helper text to show when no file is selected.
  final String helperText;

  /// The icon to show when no file is selected.
  final IconData icon;

  /// Function to execute when the user wants to select a new file.
  final VoidCallback? onSelectNewFile;

  const UploadFileCard({
    super.key,
    this.title,
    this.fileName,
    this.fileSize,
    required this.helperText,
    this.icon = HugeIcons.strokeRoundedFileUpload,
    this.onSelectNewFile,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasFile = fileName != null && fileName!.isNotEmpty;

    return Container(
      height: 0.3.sh,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).canvasColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(
                top: 24.0,
                left: 24.0,
                right: 24.0,
              ),
              child: Text(
                title!,
                style: textStyleAppBar,
              ),
            ),
          Expanded(
            child: GestureDetector(
              onTap: onSelectNewFile,
              child: Center(
                child: hasFile
                    ? _buildFileDetails(context)
                    : _buildUploadPrompt(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadPrompt(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          helperText.tr,
          style: textStyleAppBar,
          textAlign: TextAlign.center,
        ),
        10.verticalSpace,
        IconButton(
          onPressed: onSelectNewFile,
          icon: HugeIcon(
            icon: icon,
            color: Theme.of(context).highlightColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFileDetails(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedFile02,
          size: 48,
          color: Theme.of(context).highlightColor,
        ),
        16.verticalSpace,
        Text(fileName!, style: textStyleTitle, textAlign: TextAlign.center),
        if (fileSize != null && fileSize!.isNotEmpty) ...[
          8.verticalSpace,
          Text(fileSize!, style: textStyleBody),
        ],
      ],
    );
  }
}

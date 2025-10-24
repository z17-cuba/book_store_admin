import 'dart:typed_data';

import 'package:book_store_admin/presentation/app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hugeicons/hugeicons.dart';

class CircleImageCard extends StatelessWidget {
  /// The [Uint8List] of the image.
  final Uint8List imageBytes;

  /// The url of the image to show in the card.
  final String? imageUrl;

  /// The title of the image card if any.
  final String? title;

  /// Function to execute when the user wants to select a new file.
  final void Function()? onSelectNewFile;

  const CircleImageCard({
    super.key,
    required this.imageBytes,
    this.imageUrl,
    this.title,
    this.onSelectNewFile,
  });

  @override
  Widget build(BuildContext context) {
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
          imageBytes.isEmpty
              ? imageUrl != null && imageUrl!.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(
                          title?.isNotEmpty == true ? 24.0 : 0.0,
                        ),
                        child: GestureDetector(
                          onTap: onSelectNewFile,
                          child: Image.network(
                            imageUrl!,
                            width: double.infinity,
                            height: 0.5.sh,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'app.pressTheIconToUploadAnImage'.tr,
                              style: textStyleAppBar,
                            ),
                            10.verticalSpace,
                            IconButton(
                              onPressed: onSelectNewFile,
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedImageUpload,
                                color: Theme.of(context).highlightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
              : Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(
                      title?.isNotEmpty == true ? 24.0 : 0.0,
                    ),
                    child: GestureDetector(
                      onTap: onSelectNewFile,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          imageBytes,
                          height: 0.5.sh,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

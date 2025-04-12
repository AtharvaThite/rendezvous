import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rendezvous/core/theme/app_colors.dart';
import 'package:rendezvous/core/utils/core_utils.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPickerField extends StatefulWidget {
  const CustomVideoPickerField({
    required this.labelText,
    this.validator,
    this.onVideoSelected,
    super.key,
  });

  final String labelText;
  final String? Function(String?)? validator;
  final void Function(PlatformFile)? onVideoSelected;

  @override
  State<CustomVideoPickerField> createState() => _CustomVideoPickerFieldState();
}

class _CustomVideoPickerFieldState extends State<CustomVideoPickerField> {
  PlatformFile? selectedVideo;
  final TextEditingController fileNameController = TextEditingController();
  double progress = 0.0;
  bool isUploading = false;
  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null && result.files.isNotEmpty) {
      final video = result.files.first;

      if (video.extension != null &&
          ['mp4', 'mov', 'avi'].contains(video.extension!.toLowerCase())) {
        final controller = VideoPlayerController.file(File(video.path!));

        await controller.initialize();

        final durationInSeconds = controller.value.duration.inSeconds;
        await controller.dispose();

        if (durationInSeconds > 20) {
          CoreUtils.showSnackbar(
            context,
            'Please make sure the duration of video is not more than 20 seconds',
          );
          return;
        }

        setState(() {
          selectedVideo = video;
          fileNameController.text = selectedVideo!.name;
          isUploading = true;
          progress = 0.0;
        });

        _simulateUpload();

        widget.onVideoSelected?.call(video);

        _fieldKey.currentState?.validate();
      } else {
        CoreUtils.showSnackbar(context, 'Please select a valid video file.');
      }
    }
  }

  void _simulateUpload() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (progress < 1.0) {
        setState(() {
          progress += 0.2;
        });
        _simulateUpload();
      } else {
        setState(() {
          isUploading = false;
        });
      }
    });
  }

  void _clearSelection() {
    setState(() {
      selectedVideo = null;
      progress = 0.0;
      isUploading = false;
      fileNameController.text = '';
    });
    _fieldKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    final hasSelectedVideo = selectedVideo != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          key: _fieldKey,
          controller: fileNameController,
          readOnly: true,
          onTap: _pickVideo,
          // validator:
          //     widget.validator ??
          //     (value) {
          //       if (selectedVideo == null) {
          //         return 'Please select a video';
          //       }
          //       return null;
          //     },
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.fontColor,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(width: 2, color: AppColors.borderColor),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(width: 2, color: AppColors.borderColor),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(width: 2, color: AppColors.error),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(width: 2, color: AppColors.borderColor),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(width: 2, color: AppColors.borderColor),
            ),
            suffixIcon:
                hasSelectedVideo && !isUploading
                    ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.fontColor),
                      onPressed: _clearSelection,
                    )
                    : const Icon(
                      Icons.video_library,
                      color: AppColors.fontColor,
                    ),
            hintText: 'Please select a video',
          ),
        ),
        if (isUploading)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(
              value: progress,
              color: AppColors.borderColor,
              backgroundColor: AppColors.borderColor.withOpacity(0.2),
            ),
          ),
      ],
    );
  }
}

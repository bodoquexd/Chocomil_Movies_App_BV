import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/section_title_widget.dart';

class TrailerSectionWidget extends StatelessWidget {
  final YoutubePlayerController controller;

  const TrailerSectionWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(title: 'Tráiler Oficial'),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: YoutubePlayer(
            controller: controller,
            aspectRatio: 16 / 9,
          ),
        ),
      ],
    );
  }
}
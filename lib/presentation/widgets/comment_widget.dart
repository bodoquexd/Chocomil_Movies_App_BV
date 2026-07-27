import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';

class CommentWidget extends StatefulWidget {
  final String userName;
  final String comment;
  final double rating;

  const CommentWidget({
    super.key,
    required this.userName,
    required this.comment,
    required this.rating,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool isExpanded = false;
  final int characterLimit = 120;

  @override
  Widget build(BuildContext context) {
    final bool isLongComment = widget.comment.length > characterLimit;
    final String displayText = (isLongComment && !isExpanded)
        ? '${widget.comment.substring(0, characterLimit)}...'
        : widget.comment;

    return Card(
      color: AppColors.backgroundBlack,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: const Icon(Icons.person, color: AppColors.textPrimary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.userName,
                    style: TextosEstilos.subtitulo.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.star, color: AppColors.primaryLight, size: 18),
                const SizedBox(width: 4),
                Text(
                  widget.rating.toStringAsFixed(1),
                  style: TextosEstilos.cuerpo,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              displayText,
              style: TextosEstilos.cuerpo.copyWith(color: AppColors.grayLight),
            ),

            if (isLongComment)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    isExpanded ? 'Ver menos' : 'Leer completo',
                    style: TextosEstilos.cuerpo.copyWith(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

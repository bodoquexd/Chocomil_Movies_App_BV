import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';

class AnimatedBookmarkWidget extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onTap;

  const AnimatedBookmarkWidget({
    super.key,
    required this.isSaved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      size: 26,
      isLiked: isSaved,
      animationDuration: const Duration(milliseconds: 1200),
      circleColor: const CircleColor(
        start: AppColors.chocoAccent,
        end: AppColors.chocoDark,
      ),
      bubblesSize: 40,
      bubblesColor: const BubblesColor(
        dotPrimaryColor: AppColors.chocoLight,
        dotSecondaryColor: AppColors.chocoMedium,
        dotThirdColor: AppColors.primaryDark,
        dotLastColor: AppColors.chocoPale,
      ),
      likeBuilder: (bool isLiked) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            const Icon(
              Icons.bookmark_border,
              color: AppColors.textPrimary,
              size: 26,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeInOutCubic,
              height: isLiked ? 26 : 0,
              width: 26,
              child: ClipPath(
                clipper: BookmarkClipper(),
                child: Container(color: AppColors.chocoMedium),
              ),
            ),
            if (isLiked)
              const Icon(Icons.bookmark, color: AppColors.chocoDark, size: 26),
          ],
        );
      },
      onTap: (bool isLiked) async {
        onTap();
        return !isLiked;
      },
    );
  }
}

class BookmarkClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height * 0.85);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

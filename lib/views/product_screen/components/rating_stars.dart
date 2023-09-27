import 'package:boats_lineseller/const/const.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int maxRating;
  final int numberOfRatings;

  const RatingStars({
    super.key,
    required this.rating,
    this.maxRating = 5,
    required this.numberOfRatings,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the number of filled, half-filled, and empty stars
    int filledStars = rating.floor();
    int halfFilledStars = (rating * 2).round() % 2;
    int emptyStars = maxRating - filledStars - halfFilledStars;

    return Row(
      children: [
        // Display stars based on the rating
        Row(
          children: List.generate(filledStars, (index) {
            return const Icon(Icons.star, color: Colors.amber);
          }),
        ),
        if (halfFilledStars == 1)
          const Icon(Icons.star_half,
              color: Colors.amber), // Display a half-filled star if needed
        Row(
          children: List.generate(emptyStars, (index) {
            return const Icon(Icons.star, color: Colors.grey);
          }),
        ),
        8.widthBox,
        // Display the average rating and number of ratings
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        6.widthBox,
        Text(
          '($numberOfRatings ratings)',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

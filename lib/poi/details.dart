import 'package:flutter/material.dart';
import 'package:hw_map/poi/poi.dart';
import 'package:hw_map/util/assets.dart';
import 'package:hw_map/util/message.dart';

class PoiDetails extends StatelessWidget {
  final Poi poi;

  const PoiDetails({
    super.key,
    required this.poi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(poi.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ShaderMask(
                shaderCallback: (rect) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(
                  Rect.fromLTRB(0, 0, rect.width, rect.height - 16),
                ),
                blendMode: BlendMode.dstIn,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image(
                    image: NetworkImage(poi.pictureUrl),
                  ),
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  const Text(
                    "Do you like it?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  PositiveRatingButton(value: poi.ratingPositive),
                  const SizedBox(width: 8),
                  NegativeRatingButton(value: poi.ratingNegative),
                ],
              ),
              const Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    "Is it available?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  PositiveStatusButton(),
                  SizedBox(width: 8),
                  NegativeStatusButton(),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  getMarkerImage(poi.type),
                  const SizedBox(width: 16),
                  const Text(
                    "Type:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(poi.type),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.description_rounded, size: 32),
                  const SizedBox(width: 16),
                  const Text(
                    "Description:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      poi.description,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.person_rounded, size: 32),
                  const SizedBox(width: 16),
                  const Text(
                    "Added by:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(poi.addedBy),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PositiveRatingButton extends StatelessWidget {
  final int value;
  const PositiveRatingButton({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xAA4CAF4F),
      ),
      onPressed: () {
        showSnackBar(context, "Rating: Positive");
      },
      child: Row(
        children: [
          const Icon(Icons.thumb_up_rounded),
          const SizedBox(width: 8),
          Text(value.toString()),
        ],
      ),
    );
  }
}

class NegativeRatingButton extends StatelessWidget {
  final int value;
  const NegativeRatingButton({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xAAEF4444),
      ),
      onPressed: () {
        showSnackBar(context, "Rating: Negative");
      },
      child: Row(
        children: [
          const Icon(Icons.thumb_down_rounded),
          const SizedBox(width: 8),
          Text(value.toString()),
        ],
      ),
    );
  }
}

class PositiveStatusButton extends StatelessWidget {
  const PositiveStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
      ),
      onPressed: () {
        showSnackBar(context, "Status: Yes");
      },
      child: const Row(
        children: [
          Icon(Icons.check_rounded),
          SizedBox(width: 8),
          Text("Yes"),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}

class NegativeStatusButton extends StatelessWidget {
  const NegativeStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
      ),
      onPressed: () {
        showSnackBar(context, "Status: No");
      },
      child: const Row(
        children: [
          Icon(Icons.close_rounded),
          SizedBox(width: 8),
          Text("No"),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}

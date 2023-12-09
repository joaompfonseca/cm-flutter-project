import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_x/cubit/poi.dart';
import 'package:project_x/poi/poi.dart';
import 'package:project_x/util/assets.dart';
import 'package:project_x/util/message.dart';

class PoiDetails extends StatefulWidget {
  final PoiInd poi;

  const PoiDetails({
    super.key,
    required this.poi,
  });

  @override
  State<PoiDetails> createState() => _PoiDetailsState();
}

class _PoiDetailsState extends State<PoiDetails> {
  late PoiInd poi;

  @override
  void initState() {
    super.initState();
    poi = widget.poi;
  }

  void _updatePoi(PoiInd poi) {
    setState(() {
      this.poi = poi;
    });
  }

  @override
  Widget build(BuildContext context) {
    PoiCubit poiCubit = context.read<PoiCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          poi.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  child: poi.pictureUrl.startsWith(
                          "/data") // TODO: maybe it's not the best way to check if picture is offline
                      ? Image.file(File(poi.pictureUrl))
                      : Image.network(poi.pictureUrl),
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
                  PositiveRatingButton(
                    value: poi.ratingPositive,
                    onPressed: () {
                      if (poiCubit.ratePoi(poi.toPoi(), true)) {
                        showSnackBar(context, "You like this POI!");
                      } else {
                        showSnackBar(context, "You cannot do that, sorry!");
                      }
                      _updatePoi(poi);
                    },
                  ),
                  const SizedBox(width: 8),
                  NegativeRatingButton(
                    value: poi.ratingNegative,
                    onPressed: () {
                      if (poiCubit.ratePoi(poi.toPoi(), false)) {
                        showSnackBar(context, "You disliked this POI!");
                      } else {
                        showSnackBar(context, "You cannot do that, sorry!");
                      }
                      _updatePoi(poi);
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  const Text(
                    "Is it available?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  PositiveStatusButton(
                    onPressed: () {
                      if (poiCubit.setStatus(poi.toPoi(), true)) {
                        showSnackBar(
                            context, "You marked this POI as available!");
                      } else {
                        showSnackBar(context, "You cannot do that, sorry!");
                      }
                      _updatePoi(poi);
                    },
                  ),
                  const SizedBox(width: 8),
                  NegativeStatusButton(
                    onPressed: () {
                      if (poiCubit.setStatus(poi.toPoi(), false)) {
                        showSnackBar(
                            context, "You marked this POI as unavailable!");
                      } else {
                        showSnackBar(context, "You cannot do that, sorry!");
                      }
                      _updatePoi(poi);
                    },
                  ),
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
  final VoidCallback onPressed;

  const PositiveRatingButton({
    super.key,
    required this.value,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xAA4CAF4F),
      ),
      onPressed: onPressed,
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
  final VoidCallback onPressed;

  const NegativeRatingButton({
    super.key,
    required this.value,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xAAEF4444),
      ),
      onPressed: onPressed,
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
  final VoidCallback onPressed;

  const PositiveStatusButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
      ),
      onPressed: onPressed,
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
  final VoidCallback onPressed;

  const NegativeStatusButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
      ),
      onPressed: onPressed,
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

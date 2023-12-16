// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_x/cubit/poi.dart';
import 'package:project_x/cubit/profile.dart';
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

  late bool disablePositiveRating;
  late bool disableNegativeRating;
  late bool disableStatus;

  late ProfileCubit profileCubit;

  @override
  void initState() {
    super.initState();
    poi = widget.poi;
    profileCubit = context.read<ProfileCubit>();
    disableStatus = !poi.status;

    // if user created the poi, disable rating
    if (poi.addedBy == profileCubit.state.profile.id) {
      disablePositiveRating = true;
      disableNegativeRating = true;
    } else {
      // if user already rated the poi, disable rating
      disablePositiveRating = poi.rate == "true";
      disableNegativeRating = poi.rate == "false";
    }
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
                          "/data") // Maybe it's not the best way to check if picture is offline
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
                    disabled: disablePositiveRating,
                    onPressed: () async {
                      String time = await poiCubit.ratePoi(poi.id, true);
                      if (time != "0") {
                        showSnackBar(context, "You can rate again in $time");
                      } else {
                        setState(() {
                          if (disableNegativeRating == true) {
                            poi.ratingNegative -= 1;
                          }
                          poi.ratingPositive += 1;
                          disablePositiveRating = true;
                          disableNegativeRating = false;
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  NegativeRatingButton(
                    value: poi.ratingNegative,
                    disabled: disableNegativeRating,
                    onPressed: () async {
                      String time = await poiCubit.ratePoi(poi.id, false);
                      if (time != "0") {
                        showSnackBar(context, "You can rate again in $time");
                      } else {
                        setState(() {
                          if (disablePositiveRating == true) {
                            poi.ratingPositive -= 1;
                          }
                          poi.ratingNegative += 1;
                          disableNegativeRating = true;
                          disablePositiveRating = false;
                        });
                      }
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
                    disabled: disableStatus,
                    onPressed: () {
                      poiCubit.statusPoi(poi.id, true);
                      setState(() {
                        disableStatus = true;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  NegativeStatusButton(
                    disabled: disableStatus,
                    onPressed: () {
                      poiCubit.statusPoi(poi.id, false);
                      setState(() {
                        disableStatus = true;
                      });
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
                  Expanded(
                    child: Text(
                      poi.type,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
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
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ),
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
  final bool disabled;

  const PositiveRatingButton({
    super.key,
    required this.value,
    required this.onPressed,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xAA4CAF4F),
      ),
      onPressed: disabled ? null : onPressed,
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
  final bool disabled;

  const NegativeRatingButton({
    super.key,
    required this.value,
    required this.onPressed,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xAAEF4444),
      ),
      onPressed: disabled ? null : onPressed,
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
  final bool disabled;

  const PositiveStatusButton({
    super.key,
    required this.onPressed,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
      ),
      onPressed: disabled ? null : onPressed,
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
  final bool disabled;

  const NegativeStatusButton({
    super.key,
    required this.onPressed,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
      ),
      onPressed: disabled ? null : onPressed,
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

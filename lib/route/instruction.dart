import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_x/cubit/graphhopper.dart';
import 'package:project_x/cubit/map.dart';

class InstructionCard extends StatefulWidget {
  const InstructionCard({super.key});

  @override
  State<InstructionCard> createState() => _InstructionCardState();
}

class _InstructionCardState extends State<InstructionCard> {
  @override
  Widget build(BuildContext context) {
    GraphhopperCubit graphhopperCubit = context.read<GraphhopperCubit>();
    MapCubit mapCubit = context.read<MapCubit>();

    return BlocBuilder<GraphhopperCubit, GraphhopperState>(
      builder: (context, graphhopperState) => Card(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          height: 96,
                          child: Column(
                            children: [
                              Text(
                                "${graphhopperState.instructionIndex + 1} / ${graphhopperState.instructions.length}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                              ),
                              Text(
                                graphhopperState
                                    .instructions[
                                        graphhopperState.instructionIndex]
                                    .text,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.tertiary,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.route_rounded,
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                          Text(
                            graphhopperState
                                .instructions[graphhopperState.instructionIndex]
                                .distance,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Theme.of(context).colorScheme.tertiary,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                          Text(
                            graphhopperState
                                .instructions[graphhopperState.instructionIndex]
                                .time,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        minimumSize: const Size(96, 32),
                        maximumSize: const Size(96, 32),
                        padding: const EdgeInsets.all(0),
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: (graphhopperState.instructionIndex > 0)
                          ? graphhopperCubit.previousInstruction
                          : null,
                      child: const Text("Previous"),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: BlocBuilder<MapCubit, MapState>(
                          builder: (context, mapState) {
                            if (mapState.userPosition != null &&
                                mapState.isTrackingUserPosition) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  minimumSize: const Size(96, 32),
                                  maximumSize: const Size(96, 32),
                                  padding: const EdgeInsets.all(0),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xFFEF4444),
                                ),
                                onPressed: () =>
                                    mapCubit.setTrackingUserPosition(false),
                                child: const Text("Unfollow me!"),
                              );
                            } else {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  minimumSize: const Size(96, 32),
                                  maximumSize: const Size(96, 32),
                                  padding: const EdgeInsets.all(0),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  backgroundColor: const Color(0xFF4CAF50),
                                ),
                                onPressed: () {
                                  mapCubit.flyToUserPosition();
                                  mapCubit.setTrackingUserPosition(true);
                                },
                                child: const Text("Follow me!"),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        minimumSize: const Size(96, 32),
                        maximumSize: const Size(96, 32),
                        padding: const EdgeInsets.all(0),
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: (graphhopperState.instructionIndex <
                              graphhopperState.instructions.length - 1)
                          ? graphhopperCubit.nextInstruction
                          : null,
                      child: const Text("Next"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

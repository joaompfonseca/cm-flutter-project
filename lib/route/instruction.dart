import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_x/cubit/graphhopper.dart';

class InstructionCard extends StatefulWidget {
  const InstructionCard({super.key});

  @override
  State<InstructionCard> createState() => _InstructionCardState();
}

class _InstructionCardState extends State<InstructionCard> {
  @override
  Widget build(BuildContext context) {
    GraphhopperCubit graphhopperCubit = context.read<GraphhopperCubit>();

    return BlocBuilder<GraphhopperCubit, GraphhopperState>(
      builder: (context, graphhopperState) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      graphhopperState
                          .instructions[graphhopperState.instructionIndex].text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(children: [
                const Text("Distance: "),
                Text(graphhopperState
                    .instructions[graphhopperState.instructionIndex].distance),
              ]),
              Row(children: [
                const Text("Time: "),
                Text(graphhopperState
                    .instructions[graphhopperState.instructionIndex].time),
              ]),
              Row(
                children: [
                  Text(
                      "Step: ${graphhopperState.instructionIndex + 1} / ${graphhopperState.instructions.length}"),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: (graphhopperState.instructionIndex > 0)
                        ? graphhopperCubit.previousInstruction
                        : null,
                    child: const Text("Previous"),
                  ),
                  ElevatedButton(
                    onPressed: (graphhopperState.instructionIndex <
                            graphhopperState.instructions.length - 1)
                        ? graphhopperCubit.nextInstruction
                        : null,
                    child: const Text("Next"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

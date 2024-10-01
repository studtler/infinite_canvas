import 'dart:math';
import 'package:flutter/material.dart';
import 'package:infinite_canvas/infinite_canvas.dart';
import 'package:random_color/random_color.dart';

class GeneratedNodes extends StatefulWidget {
  const GeneratedNodes({super.key});

  @override
  State<GeneratedNodes> createState() => _GeneratedNodesState();
}

class _GeneratedNodesState extends State<GeneratedNodes> {
  late InfiniteCanvasController controller;
  final gridSize = const Size.square(50);

  @override
  void initState() {
    super.initState();
    controller = InfiniteCanvasController();
    resetCanvas(); // Ensure that we start with one root node
  }

  // Method to create a single root node and reset the canvas
  void resetCanvas() {
    controller.nodes.clear();
    controller.edges.clear();

    final rootNode = createProfileTileNode(0); // Create a single root node
    controller.add(rootNode); // Add root node to the controller
  }

  // Method to create the ProfileTile node
  InfiniteCanvasNode createProfileTileNode(int index) {
    return InfiniteCanvasNode(
      key: UniqueKey(),
      label: 'Root Node $index',
      resizeMode: ResizeMode.cornersAndEdges,
      offset: const Offset(100, 100), // Position for root node
      size: const Size(300, 150), // Tile shape
      child: GestureDetector( // GestureDetector wrapping ProfileTile
        onTap: () {
          // Logic to create two new nodes on tap
          createTwoNodesWithEdges();
        },
        child: ProfileTile(
          name: 'John Doe',
          birthday: '01/01/1990',
          interestingFact: 'Loves hiking and nature photography.',
        ),
      ),
    );
  }

  // Logic to create two nodes with edges on tap
  void createTwoNodesWithEdges() {
    final rootNode = controller.nodes.first; // Assuming the first node is the root node

    // Positioning new nodes further from the root node
    final Offset rootNodeOffset = rootNode.offset;

    // Create two new nodes placed far enough to avoid overlapping with root node
    final newNode1 = InfiniteCanvasNode(
      key: UniqueKey(),
      label: 'New Node 1',
      resizeMode: ResizeMode.cornersAndEdges,
      offset: rootNodeOffset.translate(400, 0), // Far right from root node
      size: const Size(300, 150),
      child: ProfileTile(
        name: 'Alice',
        birthday: '03/12/1992',
        interestingFact: 'Enjoys painting and sculpture.',
      ),
    );

    final newNode2 = InfiniteCanvasNode(
      key: UniqueKey(),
      label: 'New Node 2',
      resizeMode: ResizeMode.cornersAndEdges,
      offset: rootNodeOffset.translate(-400, 0), // Far left from root node
      size: const Size(300, 150),
      child: ProfileTile(
        name: 'Bob',
        birthday: '11/05/1987',
        interestingFact: 'Loves playing the guitar and hiking.',
      ),
    );

    // Add new nodes to the controller
    controller.add(newNode1);
    controller.add(newNode2);

    // Create edges connecting the root node to the new nodes
    final edgeToNode1 = InfiniteCanvasEdge(
      from: rootNode.key,
      to: newNode1.key,
      label: 'Edge to Node 1',
    );

    final edgeToNode2 = InfiniteCanvasEdge(
      from: rootNode.key,
      to: newNode2.key,
      label: 'Edge to Node 2',
    );

    // Add edges to the edges list directly
    controller.edges.addAll([edgeToNode1, edgeToNode2]);

    // No need to call notifyListeners, the controller should automatically update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Canvas Example'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // Reset button
            onPressed: () {
              setState(() {
                resetCanvas(); // Reset to a single root node
              });
            },
          ),
        ],
      ),
      body: InfiniteCanvas(
        drawVisibleOnly: true,
        canAddEdges: true,
        controller: controller,
        gridSize: gridSize,
        menus: [
          MenuEntry(
            label: 'Create',
            menuChildren: [
              MenuEntry(
                label: 'Profile Tile',
                onPressed: () {
                  controller.add(createProfileTileNode(controller.nodes.length));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String name;
  final String birthday;
  final String interestingFact;

  const ProfileTile({
    Key? key,
    required this.name,
    required this.birthday,
    required this.interestingFact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade100, // Background color of the tile
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modify the color of the name text here
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Set text color to black (or any other color)
            ),
          ),
          const SizedBox(height: 8),
          // Modify the color of the birthday text here
          Text(
            'Birthday: $birthday',
            style: const TextStyle(
              color: Colors.black, // Set text color to black (or any other color)
            ),
          ),
          const SizedBox(height: 8),
          // Modify the color of the interesting fact text here
          Text(
            'Interesting Fact: $interestingFact',
            style: const TextStyle(
              color: Colors.black, // Set text color to black (or any other color)
            ),
          ),
        ],
      ),
    );
  }
}

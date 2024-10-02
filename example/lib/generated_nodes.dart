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

  // Node counter to track the total number of created nodes
  int nodeCounter = 1; // Starting from 1, assuming Root Node is node 0
  Random random = Random(); // Random instance to help position nodes dynamically

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
    nodeCounter = 1; // Reset the node counter on canvas reset

    final rootNode = createProfileTileNode(0, const Offset(100, 100)); // Create a single root node
    controller.add(rootNode); // Add root node to the controller
  }

  // Method to create the ProfileTile node
  InfiniteCanvasNode createProfileTileNode(int index, Offset position) {
    return InfiniteCanvasNode(
      key: UniqueKey(),
      label: 'Root Node $index',
      resizeMode: ResizeMode.cornersAndEdges,
      offset: position, // Position for root node
      size: const Size(300, 150), // Tile shape
      child: ProfileTile(
        name: 'John Doe',
        birthday: '01/01/1990',
        interestingFact: 'Loves hiking and nature photography.',
      ), metadata: {},
    );
  }

  // Logic to create two nodes with edges on tap
  void createTwoNodesWithEdges(InfiniteCanvasNode rootNode) {
    final Offset rootNodeOffset = rootNode.offset; // Get the dynamic position of the root node

    // Create two new nodes placed far enough to avoid overlapping with root node
    final newNode1 = InfiniteCanvasNode(
      key: UniqueKey(),
      label: 'New Node ${nodeCounter++}', // Increment nodeCounter
      resizeMode: ResizeMode.cornersAndEdges,
      offset: getRandomOffset(rootNodeOffset, 400), // Get a random, non-overlapping position for new node
      size: const Size(300, 150),
      child: ProfileTile(
        name: 'Alice',
        birthday: '03/12/1992',
        interestingFact: 'Enjoys painting and sculpture.',
      ), metadata: {},
    );

    final newNode2 = InfiniteCanvasNode(
      key: UniqueKey(),
      label: 'New Node ${nodeCounter++}', // Increment nodeCounter
      resizeMode: ResizeMode.cornersAndEdges,
      offset: getRandomOffset(rootNodeOffset, -400), // Get a random, non-overlapping position for second new node
      size: const Size(300, 150),
      child: ProfileTile(
        name: 'Bob',
        birthday: '11/05/1987',
        interestingFact: 'Loves playing the guitar and hiking.',
      ), metadata: {},
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
  }

  // Generate random offset ensuring no overlap between nodes
  Offset getRandomOffset(Offset rootOffset, double distance) {
    // Generate random values to spread nodes around the root node
    double dx = rootOffset.dx + distance + random.nextInt(200) - 100;
    double dy = rootOffset.dy + random.nextInt(200) - 100;

    return Offset(dx, dy); // Return new offset ensuring random placement
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
      body: GestureDetector(
        onTapUp: (details) {
          // Detect tap position and check if any node was tapped
          final tappedNode = findTappedNode(details.localPosition);

          // Check if tappedNode is not null before accessing its properties
          if (tappedNode != null && tappedNode.label != null && tappedNode.label!.contains('Root Node')) {
            // If the tapped node is the root node, create two child nodes
            createTwoNodesWithEdges(tappedNode);
          }
        },
        child: InfiniteCanvas(
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
                    controller.add(createProfileTileNode(controller.nodes.length, Offset(100, 100)));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to find the tapped node
  InfiniteCanvasNode? findTappedNode(Offset tapPosition) {
    try {
      return controller.nodes.firstWhere((node) => isNodeTapped(node, tapPosition));
    } catch (e) {
      return null; // Return null if no node is found
    }
  }

  // Helper function to check if a node was tapped
  bool isNodeTapped(InfiniteCanvasNode node, Offset tapPosition) {
    final nodeRect = Rect.fromLTWH(
      node.offset.dx,
      node.offset.dy,
      node.size.width,
      node.size.height,
    );
    return nodeRect.contains(tapPosition);
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
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Birthday: $birthday',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Interesting Fact: $interestingFact',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../data/characters.dart';

class ShrinkTopListScreen extends StatefulWidget {
  const ShrinkTopListScreen({super.key});

  @override
  State<ShrinkTopListScreen> createState() => _ShrinkTopListScreenState();
}

class _ShrinkTopListScreenState extends State<ShrinkTopListScreen> {
  final scrollController = ScrollController();
  final double itemHeight = 150;

  onListen() {
    setState(() {});
  }

  @override
  void initState() {
    scrollController.addListener(onListen);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(onListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shrink List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: characters.length,
                (context, index) {
                  final character = characters[index];
                  final itemPositionOffset = itemHeight * index;
                  final difference =
                      scrollController.offset - itemPositionOffset;
                  final percent = 1 - (difference / itemHeight);
                  double opacity = percent;
                  double scale = percent;
                  if (opacity > 1.0) opacity = 1.0;
                  if (opacity < 0.0) opacity = 0.0;
                  if (percent > 1.0) scale = 1.0;
                  return Opacity(
                    opacity: opacity,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(scale, 1.0),
                      child: Card(
                        color: Color(character.color),
                        child: SizedBox(
                          height: itemHeight,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    character.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                              Image.asset(character.avatar),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

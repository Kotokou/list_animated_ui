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
    characters.addAll(List.from(characters));
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
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text("Shrink Top List"),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            const SliverToBoxAdapter(
              child: Placeholder(
                fallbackHeight: 100,
              ),
            ),
            const SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              pinned: true,
              title: Text(
                'My Characters',
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 50),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: characters.length,
                (context, index) {
                  final character = characters[index];
                  final itemPositionOffset = (itemHeight * .6) * index;
                  final difference =
                      scrollController.offset - itemPositionOffset;
                  final percent = 1 - (difference / (itemHeight * .6));
                  double opacity = percent;
                  double scale = percent;
                  if (opacity > 1.0) opacity = 1.0;
                  if (opacity < 0.0) opacity = 0.0;
                  if (percent > 1.0) scale = 1.0;
                  return Align(
                    heightFactor: .6,
                    child: Opacity(
                      opacity: opacity,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(scale, 1.0),
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
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

import 'package:flutter/material.dart';
import '../data/characters.dart';
import '../models/character.dart';
import 'detail_screen.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  PageController? _controller;

  _goToDetail(Character character) {
    final page = DetailScreen(character: character);
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              return Opacity(
                opacity: animation.value,
                child: page,
              );
            },
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  _pageListener() {
    setState(() {});
  }

  @override
  void initState() {
    _controller = PageController(viewportFraction: 0.6);
    _controller!.addListener(_pageListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller!.removeListener(_pageListener);
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Dragon Ball Z",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        // backgroundColor: Colors.black54,
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _controller,
        itemCount: characters.length,
        itemBuilder: (context, index) {
          double? currentPage = 0;
          try {
            currentPage = _controller!.page;
          } catch (_) {}

          final num resizeFactor =
              (1 - (((currentPage! - index).abs() * 0.3).clamp(0.0, 1.0)));
          final currentCharacter = characters[index];
          return ListItem(
            character: currentCharacter,
            resizeFactor: resizeFactor as double,
            onTap: () => _goToDetail(currentCharacter),
          );
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final Character character;
  final double resizeFactor;
  final VoidCallback onTap;

  const ListItem({
    Key? key,
    required this.character,
    required this.resizeFactor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.4;
    double width = MediaQuery.of(context).size.width * 0.85;
    return InkWell(
      onTap: onTap,
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: width * resizeFactor,
          height: height * resizeFactor,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: height / 4,
                bottom: 0,
                child: Hero(
                  tag: "background_${character.title}",
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(character.color),
                            Colors.white,
                          ],
                          stops: const [0.4, 1.0],
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        margin: const EdgeInsets.only(
                          left: 20,
                          bottom: 10,
                        ),
                        child: Text(
                          character.title,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24 * resizeFactor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Hero(
                  tag: "image_${character.title}",
                  child: Image.asset(
                    character.avatar,
                    width: width * .5,
                    height: height,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

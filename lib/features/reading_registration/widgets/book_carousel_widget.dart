import 'package:flutter/material.dart';
import '../data/models/reading_library_model.dart';

class BookCarouselWidget extends StatefulWidget {
  final List<ReadingLibraryItem> libraryItems;
  final Function(int bookId) onBookTap;

  const BookCarouselWidget({
    Key? key,
    required this.libraryItems,
    required this.onBookTap,
  }) : super(key: key);

  @override
  State<BookCarouselWidget> createState() => _BookCarouselWidgetState();
}

class _BookCarouselWidgetState extends State<BookCarouselWidget> {
  late PageController _pageController;

  final double _viewportFraction = 0.23;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: _viewportFraction, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.libraryItems.length,
        pageSnapping: false,
        padEnds: true,
        itemBuilder: (context, index) {
          final book = widget.libraryItems[index].book;

          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 0.0;

              if (_pageController.position.haveDimensions) {
                value = index.toDouble() - (_pageController.page ?? 0);
              } else {
                value = index.toDouble() - (0);
              }

              double dist = value.abs();

              double scale = (1 - (dist * 0.15)).clamp(0.5, 1.0);

              double opacity = (1 - (dist * 0.3)).clamp(0.2, 1.0);

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: GestureDetector(
                    onTap: () => widget.onBookTap(book.id),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              book.thumbnail,
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 100,
                                height: 150,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, size: 30),
                              ),
                            ),
                          ),
                        ),
                        if (dist < 0.5) ...[
                          const SizedBox(height: 8),
                          Text(
                            book.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
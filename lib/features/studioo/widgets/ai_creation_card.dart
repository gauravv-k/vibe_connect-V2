import 'package:flutter/material.dart';

class AiCreationCard extends StatefulWidget {
  final String title;
  final String description;
  final Widget background;
  final Color shadowColor;
  final VoidCallback? onTap;

  const AiCreationCard({
    super.key,
    required this.title,
    required this.description,
    required this.background,
    required this.shadowColor,
    this.onTap,
  });

  @override
  State<AiCreationCard> createState() => _AiCreationCardState();
}

class _AiCreationCardState extends State<AiCreationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // Start the fade-in animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    
    // Calculate dynamic dimensions based on screen size
    final cardHeight = screenHeight * 0.28; // 28% of screen height
    final cardPadding = screenWidth * 0.03; // 3% of screen width
    final arrowContainerSize = screenWidth * 0.09; // 9% of screen width
    final arrowIconSize = screenWidth * 0.05; // 6% of screen width
    final titleFontSize = screenWidth * 0.08; // 3.8% of screen width
    final descriptionFontSize = screenWidth * 0.04; // 2.8% of screen width
    final spacingBetweenElements = screenWidth * 0.04; // 4% of screen width
    final arrowBorderRadius = screenWidth * 0.033; // 3.3% of screen width

    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor.withOpacity(0.4),
                blurRadius: 12.0,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Stack(
              children: [
                Positioned.fill(
                  child: widget.background,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Urbanist',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: screenHeight * 0.002), // 0.5% of screen height
                                Text(
                                  widget.description,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: descriptionFontSize,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Urbanist',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: spacingBetweenElements),
                          Container(
                            width: arrowContainerSize,
                            height: arrowContainerSize,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(arrowBorderRadius),
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: arrowIconSize,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
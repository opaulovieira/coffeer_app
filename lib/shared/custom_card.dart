import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.image,
    required this.onRightAction,
    required this.onLeftAction,
    this.flexFit = FlexFit.tight,
    this.height,
    this.leftIcon,
    this.onImageDoubleTap,
    this.onImageTap,
    this.rightIcon,
  });

  final FlexFit flexFit;
  final double? height;
  final ImageProvider<Object> image;
  final Widget? leftIcon;
  final VoidCallback onRightAction;
  final VoidCallback onLeftAction;
  final VoidCallback? onImageDoubleTap;
  final VoidCallback? onImageTap;
  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return CustomCardShell(
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              fit: flexFit,
              child: GestureDetector(
                onTap: onImageTap,
                onDoubleTap: onImageDoubleTap,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image(
                    image: image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Divider(
              height: 2,
              thickness: 2,
              color: Color(0xFF7B3911),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onLeftAction,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: leftIcon ??
                            const Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.black87,
                              size: 20,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: onRightAction,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: rightIcon ??
                            const Icon(
                              Icons.zoom_in_rounded,
                              size: 20,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCardShell extends StatelessWidget {
  const CustomCardShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFECCC6E),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 12,
            spreadRadius: 2,
            blurStyle: BlurStyle.outer,
          )
        ],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 2,
          strokeAlign: BorderSide.strokeAlignOutside,
          color: const Color(0xFF7B3911),
        ),
      ),
      child: child,
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';

Future<void> openToggleFavoriteCoffeeShowcaseDialog(
  BuildContext context, {
  required Coffee coffee,
  required VoidCallback onToggleAction,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return _CoffeeShowcaseDialog.favorite(
        coffee: coffee,
        onToggleAction: onToggleAction,
      );
    },
  );
}

Future<void> openUnfavoriteCoffeeShowcaseDialog(
  BuildContext context, {
  required Coffee coffee,
  required VoidCallback onUnfavorite,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return _CoffeeShowcaseDialog.unfavorite(
        coffee: coffee,
        onUnfavorite: onUnfavorite,
      );
    },
  );
}

class _CoffeeShowcaseDialog extends StatefulWidget {
  const _CoffeeShowcaseDialog._({
    required this.coffee,
    required this.iconBuilder,
  });

  factory _CoffeeShowcaseDialog.favorite({
    required Coffee coffee,
    required VoidCallback onToggleAction,
  }) {
    return _CoffeeShowcaseDialog._(
      coffee: coffee,
      iconBuilder: (context) => _FavoriteIconButton(
        initialValue: coffee.isFavorite,
        onAction: onToggleAction,
      ),
    );
  }

  factory _CoffeeShowcaseDialog.unfavorite({
    required Coffee coffee,
    required VoidCallback onUnfavorite,
  }) {
    return _CoffeeShowcaseDialog._(
      coffee: coffee,
      iconBuilder: (context) => IconButton(
        onPressed: () {
          onUnfavorite();

          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.delete),
      ),
    );
  }

  final Coffee coffee;
  final WidgetBuilder iconBuilder;

  @override
  State<_CoffeeShowcaseDialog> createState() => _CoffeeShowcaseDialogState();
}

class _CoffeeShowcaseDialogState extends State<_CoffeeShowcaseDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
            Flexible(
              child: CachedNetworkImage(
                imageUrl: widget.coffee.url,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: widget.iconBuilder(context),
            )
          ],
        ),
      ),
    );
  }
}

class _FavoriteIconButton extends StatefulWidget {
  const _FavoriteIconButton({
    required this.initialValue,
    required this.onAction,
  });

  final bool initialValue;
  final VoidCallback onAction;

  @override
  State<_FavoriteIconButton> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<_FavoriteIconButton> {
  late bool _isFavorite = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _isFavorite = !_isFavorite;
        });

        widget.onAction();
      },
      icon: Icon(
        _isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
        color: Colors.red,
      ),
    );
  }
}

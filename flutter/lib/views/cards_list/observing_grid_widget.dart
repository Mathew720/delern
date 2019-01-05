import 'dart:async';

import 'package:delern_flutter/flutter/localization.dart';
import 'package:delern_flutter/flutter/styles.dart';
import 'package:delern_flutter/models/base/keyed_list_item.dart';
import 'package:delern_flutter/view_models/base/observable_keyed_list.dart';
import 'package:delern_flutter/views/helpers/empty_list_message_widget.dart';
import 'package:delern_flutter/views/helpers/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

typedef ObservingGridItemBuilder<T> = Widget Function(T item);

class ObservingGridWidget<T extends KeyedListItem> extends StatefulWidget {
  const ObservingGridWidget({
    @required this.items,
    @required this.itemBuilder,
    @required this.maxCrossAxisExtent,
    @required this.emptyGridUserMessage,
    Key key,
  }) : super(key: key);

  final ObservableKeyedList<T> items;
  final ObservingGridItemBuilder<T> itemBuilder;
  final double maxCrossAxisExtent;
  // TODO(dotdoom): make this more abstract or rename to ObservingCardsGridView
  final String emptyGridUserMessage;

  @override
  ObservingGridWidgetState<T> createState() => ObservingGridWidgetState<T>();
}

class ObservingGridWidgetState<T extends KeyedListItem>
    extends State<ObservingGridWidget<T>> {
  StreamSubscription<ListEvent<T>> _listSubscription;

  @override
  void initState() {
    _listSubscription = widget.items.events.listen((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _listSubscription.cancel();
    super.dispose();
  }

  Widget _buildItem(T item) => widget.itemBuilder(item);

  @override
  Widget build(BuildContext context) {
    if (widget.items.value == null) {
      return ProgressIndicatorWidget();
    }

    if (widget.items.value.isEmpty) {
      return EmptyListMessageWidget(widget.emptyGridUserMessage);
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)
                  .numberOfCards(widget.items.value.length),
              style: AppStyles.secondaryText,
            ),
          ],
        ),
        Expanded(
          child: GridView.extent(
              maxCrossAxisExtent: widget.maxCrossAxisExtent,
              children:
                  widget.items.value.map(_buildItem).toList(growable: false)),
        ),
      ],
    );
  }
}
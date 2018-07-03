import 'dart:async';

import 'package:flutter/material.dart';

import '../flutter/localization.dart';
import '../models/deck.dart';
import '../view_models/deck_view_model.dart';
import '../widgets/deck_type_dropdown.dart';
import '../widgets/save_updates_dialog.dart';

class DeckSettingsPage extends StatefulWidget {
  final Deck _deck;

  DeckSettingsPage(this._deck);

  @override
  State<StatefulWidget> createState() => _DeckSettingsPageState();
}

class _DeckSettingsPageState extends State<DeckSettingsPage> {
  TextEditingController _deckNameController = new TextEditingController();
  DeckViewModel _viewModel;
  StreamSubscription<void> _viewModelUpdates;
  DeckType _deckTypeValue;

  @override
  void initState() {
    _deckNameController.text = widget._deck.name;
    _viewModel = DeckViewModel(widget._deck);
    _deckTypeValue = _viewModel.deck.type;
    super.initState();
  }

  @override
  void deactivate() {
    _viewModelUpdates?.cancel();
    _viewModelUpdates = null;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModelUpdates == null) {
      _viewModelUpdates = _viewModel.updates.listen((_) => setState(() {}));
    }
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(_viewModel.deck.name),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.delete),
                onPressed: () async {
                  var locale = AppLocalizations.of(context);
                  var deleteDeckDialog = await showSaveUpdatesDialog(
                      context: context,
                      changesQuestion: locale.deleteDeckQuestion,
                      yesAnswer: locale.delete,
                      noAnswer: locale.cancel);
                  // TODO(ksheremet): Implement deleting deck
                  if (deleteDeckDialog) {
                    Navigator.of(context).pop();
                  }
                })
          ],
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: _deckNameController,
            onChanged: (String text) {
              setState(() {});
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text('Deck Type'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DeckTypeDropdown(
                value: _deckTypeValue,
                valueChanged: (DeckType newDeckType) => setState(() {
                      _deckTypeValue = newDeckType;
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

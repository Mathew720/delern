import 'dart:async';

import 'package:delern_flutter/models/base/list_accessor.dart';
import 'package:delern_flutter/models/base/stream_with_value.dart';
import 'package:delern_flutter/models/deck_model.dart';
import 'package:delern_flutter/models/user.dart';
import 'package:delern_flutter/remote/analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class DecksListBloc {
  final User user;

  ListAccessor<DeckModel> get decksList => _filteredDecksList;
  FilteredListAccessor<DeckModel> _filteredDecksList;

  set decksListFilter(Filter<DeckModel> newValue) =>
      _filteredDecksList.filter = newValue;
  Filter<DeckModel> get decksListFilter => _filteredDecksList.filter;

  DecksListBloc({@required this.user}) : assert(user != null) {
    _filteredDecksList = FilteredListAccessor<DeckModel>(user.decks);
  }

  // TODO(ksheremet): Use BLoC
  Future<DeckModel> createDeck(DeckModel deck) {
    logDeckCreate();
    return user.createDeck(deckTemplate: deck);
  }

  StreamWithValue<bool> get isOnline => user.isOnline;

  /// Close all streams and release associated timer resources.
  void dispose() {
    _filteredDecksList.close();
  }

  // TODO(ksheremet): Use BLoC
  Future<void> deleteDeck(DeckModel deck) => user.deleteDeck(deck: deck);
}

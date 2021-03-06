import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:kuvaton_client_flutter/components/action_bar/action_bar.dart';
import 'package:kuvaton_client_flutter/components/entry_card/entry_card.dart';
import 'package:kuvaton_client_flutter/components/loading_indicators/kuvaton_loading_branded.dart';
import 'package:kuvaton_client_flutter/components/loading_indicators/loading_overlay.dart';
import 'package:kuvaton_client_flutter/services/api/api.dart';
import 'package:kuvaton_client_flutter/services/api/api_service.dart';
import 'package:kuvaton_client_flutter/services/api/entries_response.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

const List<NavigationEntry> _navigationEntries = <NavigationEntry>[
  NavigationEntry(Endpoint.lolCategory, Icons.home, 'LOL'),
  NavigationEntry(Endpoint.topCategory, Icons.favorite, 'Top'),
  NavigationEntry(Endpoint.randomCategory, Icons.shuffle, 'Random'),
];

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  List<EntryResponse> _data = [];
  int _currentPage = 1;
  int _currentTabIndex = 0;
  Endpoint _currentEndpoint = Endpoint.lolCategory;
  bool _loadingOverlayVisible = false;
  bool _dataUnloaded = true; // _data has never been loaded
  bool _fabIsVisible = false;
  bool _loading = false;

  Future<bool> _getData({
    @required Endpoint endpoint,
    int pageNumber,
    bool showLoadingOverlay = true,
  }) async {
    print('CALLING: _getData()');
    _setLoadingOverlayVisibility(true);
    _loading = true;
    var data = await _apiService.getPage(
      endpoint: endpoint,
      pageNumber: pageNumber,
    );
    setState(() => _data.addAll(data.entries));
    _setLoadingOverlayVisibility(false);
    _loading = false;
    return true;
  }

  Future<bool> _pullToRefreshHandler() async {
    print('CALLING: _pullToRefreshHandler()');
    _data.clear();
    await _getData(endpoint: _currentEndpoint, showLoadingOverlay: false);
    _resetPageCount();
    return true;
  }

  /// load an additional page
  Future _loadMore() async {
    print('CALLING _loadmore()');
    if (_loading) return print('cancelling, already loading...');
    _currentPage++;
    await _getData(
        endpoint: _currentEndpoint,
        pageNumber: _currentPage,
        showLoadingOverlay: false);
  }

  Future _switchTab(int tabIndex) async {
    print('CALLING _switchTab()');
    setState(() => _currentTabIndex = tabIndex);
    _setFabVisible(false);
    if (_navigationEntries.length < tabIndex) {
      throw Exception(
          'There is not a handler for [BottomNavigationBar] item $tabIndex');
    }
    Endpoint endpoint = _navigationEntries[tabIndex].endpoint;
    _currentEndpoint = endpoint;
    _resetPageCount();
    _data.clear();
    await _getData(endpoint: endpoint);
    _setFabVisible(true);
  }

  Future<void> _goToPage() async {
    List numbers = List.generate(500, (index) => index);
    numbers.removeAt(0);
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: numbers),
        selecteds: [_currentPage - 1],
        hideHeader: false,
        itemExtent: 36,
        title: Text('Page'),
        backgroundColor: Theme.of(context).cardColor,
        textStyle: Theme.of(context).textTheme.bodyText1,
        onConfirm: (Picker picker, List value) {
          int selectedValue = numbers[value[0]];
          setState(() => _currentPage = selectedValue);
          _data.clear();
          _getData(endpoint: _currentEndpoint, pageNumber: selectedValue);
        }).showModal(this.context); //
  }

  Future<void> _nextPage() async {
    _data.clear();
    _currentPage++;
    _getData(endpoint: _currentEndpoint, pageNumber: _currentPage);
  }

  Future<void> _previousPage() async {
    if (_currentPage < 2) {
      //TODO: implement UI warning message
      return;
    }
    _data.clear();
    _currentPage--;
    _getData(endpoint: _currentEndpoint, pageNumber: _currentPage);
  }

  void _setLoadingOverlayVisibility(bool visible) {
    setState(() => _loadingOverlayVisible = visible);
  }

  void _setFabVisible(bool visible) {
    setState(() => _fabIsVisible = visible);
  }

  void _resetPageCount() {
    _currentPage = 1;
  }

  void _onScrollListener() {
    // handle FAB visibility
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_fabIsVisible) return;
      _setFabVisible(false);
    } else {
      if (_fabIsVisible) return;
      _setFabVisible(true);
    }
  }

  @override
  void initState() {
    super.initState();
    // init data
    _getData(endpoint: _currentEndpoint).whenComplete(() {
      _dataUnloaded = false;
      _setFabVisible(true);
    });
    _scrollController.addListener(_onScrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_data == null || _dataUnloaded)
          ? Center(child: KuvatonLoadingBranded())
          : LoadingOverlay(
              isLoading: _loadingOverlayVisible ?? false,
              child: LazyLoadScrollView(
                onEndOfPage: _loadMore,
                child: RefreshIndicator(
                  onRefresh: _pullToRefreshHandler,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: _data.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      EntryResponse entry = _data[index];
                      return _data.length - 1 == index
                          ? Column(
                              children: <Widget>[
                                EntryCard(
                                    imageFilename: entry.imageFilename,
                                    imageUrl: entry.imageUrl),
                                ActionBar(
                                  buttonPreviousOnPressed: _previousPage,
                                  buttonNextOnPressed: _nextPage,
                                  buttonPageOnPressed: _goToPage,
                                  currentPageNumber: _currentPage,
                                ),
                              ],
                            )
                          : EntryCard(
                              imageFilename: entry.imageFilename,
                              imageUrl: entry.imageUrl);
                    },
                  ),
                ),
              ),
            ),
      floatingActionButton: (_fabIsVisible)
          ? FloatingActionButton(
              child: Text('$_currentPage'),
              onPressed: _goToPage,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) => _switchTab(index),
        items: _navigationEntries
            .map((entry) => BottomNavigationBarItem(
                  icon: Icon(entry.icon),
                  title: Text(entry.title),
                ))
            .toList(),
      ),
    );
  }
}

class NavigationEntry {
  final Endpoint endpoint;
  final IconData icon;
  final String title;
  const NavigationEntry(this.endpoint, this.icon, this.title);
}

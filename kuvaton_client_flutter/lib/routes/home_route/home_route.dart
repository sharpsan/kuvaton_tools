import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:kuvaton_client_flutter/components/action_bar/action_bar.dart';
import 'package:kuvaton_client_flutter/components/entry_card/entry_card.dart';
import 'package:kuvaton_client_flutter/components/loading_indicators/kuvaton_loading_branded.dart';
import 'package:kuvaton_client_flutter/components/loading_indicators/loading_overlay.dart';
import 'package:kuvaton_client_flutter/services/api/api.dart';
import 'package:kuvaton_client_flutter/services/api/api_service.dart';
import 'package:kuvaton_client_flutter/services/api/entries_response.dart';

class NavigationEntry {
  final Endpoint endpoint;
  final IconData icon;
  final String title;
  NavigationEntry(this.endpoint, this.icon, this.title);
}

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final ApiService _apiService = ApiService();
  final List<NavigationEntry> _navigationEntries = <NavigationEntry>[
    NavigationEntry(Endpoint.lolCategory, Icons.home, 'LOL'),
    NavigationEntry(Endpoint.topCategory, Icons.favorite, 'Top'),
    NavigationEntry(Endpoint.randomCategory, Icons.shuffle, 'Random'),
  ];
  EntriesResponse _data;
  int _currentPage = 1;
  int _currentTabIndex = 0;
  Endpoint _currentEndpoint = Endpoint.lolCategory;
  bool _loadingOverlayVisible = false;

  void _resetPageCount() {
    _currentPage = 1;
  }

  Future<bool> _getData({
    @required Endpoint endpoint,
    int pageNumber,
    bool showLoadingOverlay = true,
  }) async {
    print('CALLING: _getData()');
    _setLoadingOverlayVisibility(true);
    _currentEndpoint = endpoint;
    var data =
        await _apiService.getPage(endpoint: endpoint, pageNumber: pageNumber);
    setState(() => _data = data);
    _setLoadingOverlayVisibility(false);
    return true;
  }

  Future<bool> _onRefresh() async {
    print('CALLING: _onRefresh()');
    await _getData(endpoint: _currentEndpoint, showLoadingOverlay: false);
    _resetPageCount();
    return true;
  }

  void _switchTab(int tabIndex) {
    print('CALLING _switchTab()');
    setState(() => _currentTabIndex = tabIndex);
    if (_navigationEntries.length < tabIndex) {
      throw Exception(
          'There is not a handler for [BottomNavigationBar] item $tabIndex');
    }
    _resetPageCount();
    _getData(endpoint: _navigationEntries[tabIndex].endpoint);
  }

  Future<void> _specificPage() async {
    List numbers = List.generate(500, (index) => index);
    numbers.removeAt(0);
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: numbers),
        selecteds: [_currentPage - 1],
        hideHeader: false,
        itemExtent: 36,
        onConfirm: (Picker picker, List value) {
          int selectedValue = numbers[value[0]];
          setState(() => _currentPage = selectedValue);
          _getData(endpoint: _currentEndpoint, pageNumber: selectedValue);
        }).showModal(this.context); //
  }

  Future<void> _nextPage() async {
    _currentPage++;
    _getData(endpoint: _currentEndpoint, pageNumber: _currentPage);
  }

  Future<void> _previousPage() async {
    if (_currentPage < 2) {
      //TODO: implement UI warning message
      return;
    }
    _currentPage--;
    _getData(endpoint: _currentEndpoint, pageNumber: _currentPage);
  }

  void _setLoadingOverlayVisibility(bool visible) {
    setState(() => _loadingOverlayVisible = visible);
  }

  @override
  void initState() {
    super.initState();
    _getData(endpoint: _currentEndpoint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('KuvatON Client'),
      // ),
      body: (_data == null)
          ? Center(child: KuvatonLoadingBranded())
          : LoadingOverlay(
              isLoading: _loadingOverlayVisible ?? false,
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _data?.entries?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    EntryResponse entry = _data.entries[index];
                    return _data.entries.length - 1 == index
                        ? Column(
                            children: <Widget>[
                              EntryCard(
                                  imageFilename: entry.imageFilename,
                                  imageUrl: entry.imageUrl),
                              ActionBar(
                                buttonPreviousOnPressed: _previousPage,
                                buttonNextOnPressed: _nextPage,
                                buttonPageOnPressed: _specificPage,
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

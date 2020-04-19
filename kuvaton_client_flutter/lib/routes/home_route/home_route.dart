import 'package:flutter/material.dart';
import 'package:kuvaton_client_flutter/components/action_bar/action_bar.dart';
import 'package:kuvaton_client_flutter/components/entry_card/entry_card.dart';
import 'package:kuvaton_client_flutter/helpers/vant_helper/vant_helper.dart';
import 'package:kuvaton_client_flutter/services/api/api.dart';
import 'package:kuvaton_client_flutter/services/api/api_service.dart';
import 'package:kuvaton_client_flutter/services/api/entries_response.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final ApiService apiService = ApiService();
  EntriesResponse data;
  int currentPage = 1;
  int currentTabIndex = 0;
  Endpoint currentEndpoint = Endpoint.lolCategory;

  void _resetPageCount() {
    currentPage = 1;
  }

  Future<void> _getData({@required Endpoint endpoint, int pageNumber}) async {
    setState(() => data = null);
    currentEndpoint = endpoint;
    var _data =
        await apiService.getPage(endpoint: endpoint, pageNumber: pageNumber);
    setState(() => data = _data);
  }

  Future<void> _onRefresh() async {
    _getData(endpoint: currentEndpoint);
    _resetPageCount();
  }

  Future<void> _specificPage() async {
    VantHelper.quickPicker(context, currentPage: currentPage,
        onConfirm: (selectedValue) {
      setState(() => currentPage = selectedValue);
      _getData(endpoint: currentEndpoint, pageNumber: selectedValue);
    });
  }

  Future<void> _nextPage() async {
    currentPage++;
    _getData(endpoint: currentEndpoint, pageNumber: currentPage);
  }

  Future<void> _previousPage() async {
    if (currentPage < 2) {
      //TODO: implement UI warning message
      return;
    }
    currentPage--;
    _getData(endpoint: currentEndpoint, pageNumber: currentPage);
  }

  @override
  void initState() {
    super.initState();
    _getData(endpoint: currentEndpoint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('KuvatON Client'),
      // ),
      body: (data == null)
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: data?.entries?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  EntryResponse entry = data.entries[index];
                  return data.entries.length - 1 == index
                      ? Column(
                          children: <Widget>[
                            EntryCard(
                                imageFilename: entry.imageFilename,
                                imageUrl: entry.imageUrl),
                            ActionBar(
                              buttonPreviousOnPressed: _previousPage,
                              buttonNextOnPressed: _nextPage,
                              buttonPageOnPressed: _specificPage,
                              currentPageNumber: currentPage,
                            ),
                          ],
                        )
                      : EntryCard(
                          imageFilename: entry.imageFilename,
                          imageUrl: entry.imageUrl);
                },
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTabIndex,
        onTap: (index) {
          setState(() => currentTabIndex = index);
          if (index == 0) {
            _resetPageCount();
            _getData(endpoint: Endpoint.lolCategory);
          } else if (index == 1) {
            _resetPageCount();
            _getData(endpoint: Endpoint.topCategory);
          } else if (index == 2) {
            _resetPageCount();
            _getData(endpoint: Endpoint.randomCategory);
          } else {
            throw Exception(
                'There is not a handler for [BottomNavigationBar] item $index');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('LOL'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Top'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shuffle),
            title: Text('Random'),
          ),
        ],
      ),
    );
  }
}

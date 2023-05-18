import 'package:bookcenter/screens/search/controllers/search_controller.dart';
import 'package:bookcenter/screens/search/views/components/no_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bookcenter/components/custom_modal_bottom_sheet.dart';
import 'package:bookcenter/constants.dart';
import 'package:bookcenter/screens/search/views/components/search_form.dart';
import 'package:get/get.dart';

import 'components/recent_searches.dart';
import 'components/search_filter.dart';
import 'components/search_resulats.dart';
import 'components/search_suggestions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late FocusNode _focusNode;
  // bool _isFocused = false;

  final _searchController = Get.put(SearchController());

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      _searchController.isFocused.value = _focusNode.hasFocus;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: false,
        title: Text(
          "Calvary Book Center",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: const [CloseButton()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchForm(
                autofocus: true,
                focusNode: _focusNode,
                onChanged: (value) {},
                onFieldSubmitted: (value) {
                  if (value != null && value.isNotEmpty) {
                    _searchController.initSearch(value);
                  }
                },
                onSaved: (value) {},
                validator: (value) {
                  return null;
                }, // validate
                onTabFilter: () {
                  // customModalBottomSheet(
                  //   context,
                  //   height: MediaQuery.of(context).size.height * 0.92,
                  //   child: const SearchFilter(),
                  // );
                },
              ),
              const SizedBox(height: defaultPadding),
              GetX<SearchController>(
                builder: (controller) {
                  return !controller.isFocused.value &&
                          controller.searchResults.isNotEmpty
                      ? Text.rich(
                          TextSpan(
                            text: "Search result ",
                            style: Theme.of(context).textTheme.titleSmall,
                            children: const [
                              // TextSpan(
                              //   text:
                              //       "(${controller.searchResults.length} items)",
                              //   style: Theme.of(context).textTheme.bodyMedium,
                              // ),
                            ],
                          ),
                        )
                      : Container();
                },
              ),
              const SearchResulats(),
            ],
          ),
        ),
      ),
    );
  }
}

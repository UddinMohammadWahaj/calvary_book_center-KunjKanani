import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bookcenter/components/custom_modal_bottom_sheet.dart';
import 'package:bookcenter/components/list_tile/divider_list_tile.dart';
import 'package:bookcenter/components/outlined_active_button.dart';
import 'package:bookcenter/screens/search/views/components/brand_filter.dart';
import 'package:bookcenter/screens/search/views/components/color_filter.dart';
import 'package:bookcenter/screens/search/views/components/price_filter.dart';
import 'package:bookcenter/screens/search/views/components/product_sort_filter.dart';

import '../../../../constants.dart';
import 'size_fiter.dart';

class SearchFilter extends StatefulWidget {
  const SearchFilter({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  bool _isShowSort = false;
  bool _isShowAvailableProducOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                children: [
                  const SizedBox(
                    width: 40,
                    child: BackButton(),
                  ),
                  const SizedBox(width: 32),
                  const Spacer(),
                  Text(
                    "Filter",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 72,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Clear All"),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedActiveButton(
                      press: () {
                        setState(() {
                          _isShowSort = false;
                        });
                      },
                      text: "Filter",
                      isActive: !_isShowSort,
                    ),
                  ),
                  const SizedBox(width: defaultPadding),
                  Expanded(
                    child: OutlinedActiveButton(
                      press: () {
                        setState(() {
                          _isShowSort = true;
                        });
                      },
                      text: "Sort",
                      isActive: _isShowSort,
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: defaultPadding),
            _isShowSort
                ? const Expanded(child: ProductSortFilter())
                : Expanded(
                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: Column(
                        children: [
                          DividerListTile(
                            title: const Text("Color"),
                            press: () {
                              customModalBottomSheet(
                                context,
                                height:
                                    MediaQuery.of(context).size.height * 0.92,
                                child: const ProductColorFilter(),
                              );
                            },
                          ),
                          DividerListTile(
                            title: const Text("Size"),
                            press: () {
                              customModalBottomSheet(
                                context,
                                height:
                                    MediaQuery.of(context).size.height * 0.92,
                                child: const SizeFilter(),
                              );
                            },
                          ),
                          DividerListTile(
                            title: const Text("Brand"),
                            press: () {
                              customModalBottomSheet(
                                context,
                                height:
                                    MediaQuery.of(context).size.height * 0.92,
                                child: const BrandFilter(),
                              );
                            },
                          ),
                          DividerListTile(
                            title: const Text("Price"),
                            press: () {
                              customModalBottomSheet(
                                context,
                                height:
                                    MediaQuery.of(context).size.height * 0.92,
                                child: const PriceFilter(),
                              );
                            },
                          ),
                          CheckboxListTile(
                            onChanged: (value) {
                              setState(() {
                                _isShowAvailableProducOnly = value!;
                              });
                            },
                            value: _isShowAvailableProducOnly,
                            title: const Text("Available in stock"),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding / 2),
                          )
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

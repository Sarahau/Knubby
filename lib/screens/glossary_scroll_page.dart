import 'package:final_project/main.dart';
import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
import 'package:string_validator/string_validator.dart';

class AzAbbrev extends ISuspensionBean {
  final String abbrev;
  final String def;
  final String tag;

  AzAbbrev(this.abbrev, this.def, this.tag);

  @override
  String getSuspensionTag() {
    return tag;
  }
}

class GlossaryScrollPage extends StatefulWidget {
  final List<Map<String, String>> abbrevs;

  const GlossaryScrollPage({required this.abbrevs, super.key});

  @override
  State<GlossaryScrollPage> createState() => _GlossaryScrollPageState();
}

class _GlossaryScrollPageState extends State<GlossaryScrollPage> {
  List<AzAbbrev> azAbbrevs = [];

  @override
  void initState() {
    super.initState();

    initList(widget.abbrevs);
  }

  void initList(List<Map<String, String>> abbrevs) {
    abbrevs.forEach((abbrev) {
      String abbreviation = abbrev.keys.elementAt(0);
      String tag;
      if (isAlpha(abbreviation[0])) {
        tag = abbreviation[0].toUpperCase();
      } else {
        tag = '#';
      }
      azAbbrevs.add(AzAbbrev(abbreviation, abbrev.values.elementAt(0), tag));
    });

    SuspensionUtil.sortListBySuspensionTag(azAbbrevs);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AzListView(
        data: azAbbrevs,
        itemCount: azAbbrevs.length,
        itemBuilder: (context, index) {
          final azAbbrev = azAbbrevs[index];
          return definition(azAbbrev, index, context);
        },
        physics: const BouncingScrollPhysics(),
        indexBarOptions: IndexBarOptions(
          needRebuild: true,
          selectItemDecoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: KnubbyApp.pink,
          ),
          selectTextStyle: Theme.of(context).textTheme.headline2!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
          indexHintAlignment: Alignment.centerRight,
          indexHintOffset: const Offset(-10, 0),
          textStyle: Theme.of(context).textTheme.headline2!,
        ),
        indexHintBuilder: (context, hint) => Container(
          alignment: Alignment.center,
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: KnubbyApp.darkPink.withOpacity(0.7),
          ),
          child: Text(
            hint,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }

  Widget definition(AzAbbrev abbrev, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 30),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  abbrev.abbrev,
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.end,
                  softWrap: true,
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Expanded(
                child: Text(
                  abbrev.def,
                  style: Theme.of(context).textTheme.headline1,
                  softWrap: true,
                ),
              ),
            ],
          ),
          const Divider(
            height: 12,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

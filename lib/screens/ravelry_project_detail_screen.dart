import 'package:final_project/main.dart';
import 'package:flutter/material.dart';

import '../screens/ravelry_web_screen.dart';
import '../models/ravelry_project.dart';

class RavelryProjectDetailScreen extends StatefulWidget {
  final RavelryProject ravelryProject;

  const RavelryProjectDetailScreen(this.ravelryProject, {super.key});

  @override
  State<RavelryProjectDetailScreen> createState() =>
      _RavelryProjectDetailScreenState();
}

class _RavelryProjectDetailScreenState
    extends State<RavelryProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 12,
            ),
            Text(
              widget.ravelryProject.name,
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: KnubbyApp.darkPink,
                  ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.ravelryProject.photoUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            patternDesigner(context),
            const SizedBox(
              height: 12,
            ),
            patternDetails(context),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RavelryWebScreen(
                        title: widget.ravelryProject.name,
                        selectedUrl:
                            'https://www.ravelry.com/patterns/library/${widget.ravelryProject.ravelryLink}'),
                  ),
                );
              },
              child: const Text(
                'Go to the Ravelry page for more details and to get the pattern!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: KnubbyApp.darkPink),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget patternDesigner(BuildContext context) {
    return Column(
      children: [
        Text(
          'Pattern Designer',
          style: Theme.of(context).textTheme.headline3!.copyWith(
                color: KnubbyApp.darkPink,
              ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          widget.ravelryProject.patternDesigner,
          style: Theme.of(context).textTheme.headline1,
        ),
      ],
    );
  }

  Widget patternDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          patternDetail(
            'Yarn Weight',
            context,
            content: widget.ravelryProject.yarn_weight_description,
          ),
          const SizedBox(
            height: 10,
          ),
          patternDetail(
            'Gauge',
            context,
            content: widget.ravelryProject.gauge_description,
          ),
          const SizedBox(
            height: 10,
          ),
          patternDetail(
            'Needle Sizes',
            context,
            contents: widget.ravelryProject.needle_sizes,
          ),
          const SizedBox(
            height: 10,
          ),
          patternDetail(
            'Sizes Available',
            context,
            content: widget.ravelryProject.sizes_available,
          ),
          const SizedBox(
            height: 16,
          ),
          widget.ravelryProject.notes == ''
              ? Container()
              : patternNotes(context),
        ],
      ),
    );
  }

  Widget patternNotes(BuildContext context) {
    return Column(
      children: [
        Text(
          'Pattern Notes',
          style: Theme.of(context).textTheme.headline2!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
          softWrap: true,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.ravelryProject.notes,
          style: Theme.of(context).textTheme.headline1!.copyWith(
                fontSize: 14,
              ),
          textAlign: TextAlign.left,
          softWrap: true,
        ),
      ],
    );
  }

  Widget patternDetail(String title, BuildContext context,
      {String? content, List<String>? contents}) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.end,
            softWrap: true,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: content != null
              ? Text(
                  content == '' ? '--' : content,
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 14,
                      ),
                  softWrap: true,
                )
              : contents!.isEmpty
                  ? Text(
                      '--',
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontSize: 14,
                          ),
                      softWrap: true,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var item in contents)
                          Text(
                            item,
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      fontSize: 14,
                                    ),
                            softWrap: true,
                          ),
                      ],
                    ),
        ),
      ],
    );
  }
}

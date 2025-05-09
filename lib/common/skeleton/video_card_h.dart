import 'package:PiliPlus/common/constants.dart';
import 'package:flutter/material.dart';
import 'skeleton.dart';

class VideoCardHSkeleton extends StatelessWidget {
  const VideoCardHSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StyleString.safeSpace,
          vertical: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: StyleString.aspectRatio,
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      borderRadius: StyleString.mdRadius,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 6, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      width: 200,
                      height: 11,
                      margin: const EdgeInsets.only(bottom: 5),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      width: 150,
                      height: 13,
                    ),
                    const Spacer(),
                    Container(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      width: 100,
                      height: 13,
                      margin: const EdgeInsets.only(bottom: 5),
                    ),
                    Row(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                          width: 40,
                          height: 13,
                          margin: const EdgeInsets.only(right: 8),
                        ),
                        Container(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                          width: 40,
                          height: 13,
                        ),
                      ],
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

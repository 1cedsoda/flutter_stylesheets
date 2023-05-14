import 'package:flutter/material.dart';
import 'package:ultimate_containers/ultimate_containers.dart';

/// Ultimate Container Widget
class C extends StatelessWidget {
  C(
    dynamic inputs, {
    Key? key,
  }) : super(key: key) {
    final _inputs = inputs is Iterable ? inputs : [inputs];
    children = [];
    fss = [];
    for (final input in _inputs) {
      if (input is FSS)
        fss.add(input);
      else if (input is Widget)
        children.add(input);
      else
        children.add(T(input));
    }
  }

  late final List<FSS?> fss;
  late final List<Widget> children;

  @override
  Widget build(BuildContext ctx) {
    final breakpoint = Breakpoints.of(ctx)?.getBreakpoint(ctx);
    final fss = FSS
        .of(ctx)
        .inhertiable() // Inherit text styles
        .mergeMulti(this.fss) // merge provided styles
        .flattenResponsive(breakpoint); // calculate responsive styles based on breakpoint

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final uctx = UnitContext(ctx, constraints);

        return Padding(
          padding: fss.marginEdgeInset(UnitContext(ctx, constraints)),
          child: Container(
            width: fss.width?.px(uctx),
            height: fss.height?.px(uctx),
            padding: fss.paddingEdgeInset(uctx),
            decoration: BoxDecoration(
              color: fss.backgroundColor,
              borderRadius: fss.hasBorderRadius()
                  ? BorderRadius.only(
                      topLeft: Radius.circular(fss.borderRadiusTopLeft?.px(uctx) ?? 0),
                      topRight: Radius.circular(fss.borderRadiusTopRight?.px(uctx) ?? 0),
                      bottomLeft: Radius.circular(fss.borderRadiusBottomLeft?.px(uctx) ?? 0),
                      bottomRight: Radius.circular(fss.borderRadiusBottomRight?.px(uctx) ?? 0),
                    )
                  : BorderRadius.zero,
              border: Border.fromBorderSide(BorderSide(
                color: fss.borderColor ?? Colors.transparent,
                width: fss.borderWidth?.px(uctx) ?? 0,
                style: fss.borderStyle ?? BorderStyle.solid,
                strokeAlign: fss.borderAlign ?? -1,
              )),
              boxShadow: fss.shadows?.map((e) => e.boxShadow(uctx)).toList(),
            ),
            child: FSSProvider(
                fss: fss,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                )),
          ),
        );
      },
    );
  }
}

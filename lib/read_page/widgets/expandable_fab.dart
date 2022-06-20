import 'dart:math';
import 'package:feeling_note/datas/read_page_state_provider.dart';
import 'package:feeling_note/read_page/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Duration _duration = Duration(milliseconds: 150);

class ExpandableFab extends StatefulWidget {
  final double distance;
  final List<Widget> children;

  const ExpandableFab(
      {Key? key, required this.distance, required this.children})
      : super(key: key);

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  ReadPageStateChangeNotifier? readPageProvider;
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: _duration);
    _expandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      readPageProvider = ref.watch(readPageStateProvider);
      if (!readPageProvider?.isFabOpen) {
        _controller.reverse();
      }
      return SizedBox.expand(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            _buildTabToCloseFab(),
            _buildTabToOpenFab(),
          ]..insertAll(1, _buildExpandableActionButton()),
        ),
      );
    });
  }

  void toggle() {
    readPageProvider?.setIsFabOpen = !readPageProvider?.isFabOpen;
    readPageProvider?.setIsSearch = false;
    readPageProvider?.setIsServerUpload = false;
    readPageProvider?.setIsFiltering = false;
    setState(() {
      if (readPageProvider?.isFabOpen) {
        _controller.forward();
      } else {
        if (readPageProvider != null) {
          readPageProvider?.setIsFiltering = false;
          readPageProvider?.setIsSearch = false;
          readPageProvider?.setIsServerUpload = false;
        }
        _controller.reverse();
      }
    });
  }

  List<_ExpandableActionButton> _buildExpandableActionButton() {
    List<_ExpandableActionButton> animChildren = [];
    final int count = widget.children.length;
    final double gap = 90 / (count - 1);

    for (var i = 0, degree = count == 2 ? 45.0 : 0.0;
        i < count;
        i++, degree += gap) {
      animChildren.add(_ExpandableActionButton(
        distance: widget.distance,
        degree: count == 2 ? degree / 2 : degree,
        progress: _expandAnimation,
        child: widget.children[i],
      ));
    }
    return animChildren;
  }

  AnimatedContainer _buildTabToOpenFab() {
    return AnimatedContainer(
      duration: _duration,
      transform: Matrix4.rotationZ(readPageProvider?.isFabOpen ? 0 : pi / 4),
      transformAlignment: Alignment.center,
      child: AnimatedOpacity(
        duration: _duration,
        opacity: readPageProvider?.isFabOpen ? 0.0 : 1.0,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: toggle,
          child: Icon(
            Icons.close,
          ),
        ),
      ),
    );
  }

  AnimatedContainer _buildTabToCloseFab() {
    return AnimatedContainer(
      duration: _duration,
      transform: Matrix4.rotationZ(readPageProvider?.isFabOpen ? 0 : pi / 4),
      transformAlignment: Alignment.center,
      child: FloatingActionButton(
        onPressed: toggle,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.close,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class _ExpandableActionButton extends StatelessWidget {
  final double distance;
  final double degree;
  final Animation<double> progress;
  final Widget child;

  const _ExpandableActionButton(
      {Key? key,
      required this.distance,
      required this.degree,
      required this.progress,
      required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final Offset offset = Offset.fromDirection(
            degree * (pi / 180), progress.value * distance);
        return Positioned(
          right: offset.dx + 4,
          bottom: offset.dy + 4,
          child: child!,
        );
      },
      child: child,
    );
  }
}

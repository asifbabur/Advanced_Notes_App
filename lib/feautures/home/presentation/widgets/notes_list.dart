import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/core/constants.dart';
import 'package:my_notes_flutter/feautures/home/data/models/note.dart';
import 'package:my_notes_flutter/feautures/home/presentation/pages/notes_page.dart';
import 'package:my_notes_flutter/feautures/home/presentation/providers/notes_provider.dart';
import 'package:my_notes_flutter/feautures/home/presentation/widgets/note_card.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  void _refreshNotes() {
    ref.invalidate(notesControllerProvider);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref
        .watch(notesControllerProvider)
        .maybeWhen<List<Note>>(data: (data) => data, orElse: () => []);

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      header: WaterDropHeader(),
      onRefresh: _refreshNotes,
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            floating: true,
            delegate: _TabBarDelegate(
              TabBar(
                indicatorWeight: .1,
                controller: _tabController,
                isScrollable: true,
                labelPadding: EdgeInsets.zero,
                indicatorPadding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 6.2,
                ),

                indicatorAnimation: TabIndicatorAnimation.elastic,
                labelColor: Colors.black,
                labelStyle: GoogleFonts.openSans(color: Colors.black),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(33),
                  color: AppColors.greenButtonColor,
                ),

                tabs:
                    categories
                        .map(
                          (cat) => Container(
                            margin: EdgeInsets.all(5),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 25,
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(33),
                              border: Border.all(
                                color: Colors.black,
                                width: .75,
                              ),
                            ),
                            child: MyText(
                              cat,
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children:
                  categories.map((category) {
                    final filteredNotes =
                        category == "All"
                            ? notes
                            : notes
                                .where((note) => note.category == category)
                                .toList();
                    return NotesGrid(notes: filteredNotes, ref: ref);
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(color: Colors.transparent, elevation: 0, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class NotesGrid extends StatelessWidget {
  final List<Note> notes;
  final WidgetRef ref;

  const NotesGrid({super.key, required this.notes, required this.ref});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child:
          notes.isEmpty
              ? const Center(child: MyText("No Notes Found"))
              : Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    mainAxisExtent: 125,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return FadeTransition(
                      opacity: AlwaysStoppedAnimation(1.0),
                      child: NoteCard(note: note, ref: ref),
                    );
                  },
                ),
              ),
    );
  }
}

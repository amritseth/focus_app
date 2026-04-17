import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const FocusApp());
}

// ─── MODELS ────────────────────────────────────────────────────────────────

class Task {
  final String id;
  String title;
  String? description;
  DateTime? dueDate;
  TimeOfDay? dueTime;
  bool isCompleted;
  TaskPriority priority;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.dueTime,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
  });
}

enum TaskPriority { low, medium, high }

class Note {
  final String id;
  String title;
  String content;
  Color color;
  DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.createdAt,
  });
}

// ─── APP STATE ──────────────────────────────────────────────────────────────

class AppState extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Design new landing page',
      description: 'Create wireframes and mockups',
      dueDate: DateTime.now(),
      dueTime: const TimeOfDay(hour: 14, minute: 0),
      priority: TaskPriority.high,
    ),
    Task(
      id: '2',
      title: 'Team standup meeting',
      dueDate: DateTime.now(),
      dueTime: const TimeOfDay(hour: 10, minute: 30),
      priority: TaskPriority.medium,
    ),
    Task(
      id: '3',
      title: 'Review pull requests',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.low,
      isCompleted: true,
    ),
    Task(
      id: '4',
      title: 'Write unit tests',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: TaskPriority.medium,
    ),
    Task(
      id: '5',
      title: 'Deploy to production',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: TaskPriority.high,
    ),
  ];

  final List<Note> _notes = [
    Note(
      id: '1',
      title: 'Project Ideas',
      content: 'Build a Flutter app with clean architecture and BLoC pattern for state management.',
      color: const Color(0xFF6C63FF),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Note(
      id: '2',
      title: 'Shopping List',
      content: 'Milk, Eggs, Bread, Coffee, Fruits',
      color: const Color(0xFFFF6584),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Note(
      id: '3',
      title: 'Meeting Notes',
      content: 'Discussed Q4 roadmap. Focus on mobile-first features.',
      color: const Color(0xFF43C6AC),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Note(
      id: '4',
      title: 'Book Recommendations',
      content: 'Clean Code, The Pragmatic Programmer, Designing Data-Intensive Apps',
      color: const Color(0xFFFFB347),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  List<Task> get tasks => List.unmodifiable(_tasks);
  List<Note> get notes => List.unmodifiable(_notes);

  List<Task> get todayTasks {
    final now = DateTime.now();
    return _tasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.year == now.year &&
          t.dueDate!.month == now.month &&
          t.dueDate!.day == now.day;
    }).toList();
  }

  List<Task> get upcomingTasks {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _tasks.where((t) {
      if (t.dueDate == null) return false;
      final due = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
      return due.isAfter(today);
    }).toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  }

  void addTask(Task task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void toggleTask(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _tasks[idx].isCompleted = !_tasks[idx].isCompleted;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void addNote(Note note) {
    _notes.insert(0, note);
    notifyListeners();
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}

// ─── THEME ──────────────────────────────────────────────────────────────────

class AppTheme {
  static const Color bg = Color(0xFF0F0F1A);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color card = Color(0xFF16213E);
  static const Color accent = Color(0xFF6C63FF);
  static const Color accentLight = Color(0xFF9D97FF);
  static const Color coral = Color(0xFFFF6584);
  static const Color teal = Color(0xFF43C6AC);
  static const Color amber = Color(0xFFFFB347);
  static const Color textPrimary = Color(0xFFF0F0FF);
  static const Color textSecondary = Color(0xFF8888AA);
  static const Color divider = Color(0xFF2A2A40);

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(
          primary: accent,
          secondary: coral,
          surface: surface,
        ),
        fontFamily: 'SF Pro Display',
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          iconTheme: IconThemeData(color: textPrimary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: surface,
          selectedItemColor: accent,
          unselectedItemColor: textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: CircleBorder(),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: accent, width: 1.5),
          ),
          labelStyle: const TextStyle(color: textSecondary),
          hintStyle: const TextStyle(color: textSecondary),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: accent,
          unselectedLabelColor: textSecondary,
          indicatorColor: accent,
          dividerColor: Colors.transparent,
          labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      );
}

// ─── MAIN APP ───────────────────────────────────────────────────────────────

class FocusApp extends StatelessWidget {
  const FocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) => MaterialApp(
        title: 'Focus',
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: const HomeShell(),
      ),
    );
  }
}

final _appState = AppState();

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    TasksPage(),
    SchedulePage(),
    NotesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.divider, width: 0.5)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.check_circle_outline_rounded, label: 'Tasks', index: 0, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.calendar_today_rounded, label: 'Schedule', index: 1, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.sticky_note_2_outlined, label: 'Notes', index: 2, currentIndex: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _NavItem({required this.icon, required this.label, required this.index, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? AppTheme.accent : AppTheme.textSecondary, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── TASKS PAGE ─────────────────────────────────────────────────────────────

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        final tasks = _appState.tasks;
        final pending = tasks.where((t) => !t.isCompleted).length;
        return Scaffold(
          backgroundColor: AppTheme.bg,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('My Tasks'),
                Text(
                  '$pending task${pending != 1 ? 's' : ''} pending',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.accent.withOpacity(0.2),
                  child: const Text('A', style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
          body: tasks.isEmpty
              ? const _EmptyState(icon: Icons.check_circle_outline_rounded, message: 'No tasks yet.\nTap + to add one!')
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: tasks.length,
                  itemBuilder: (ctx, i) => _TaskCard(task: tasks[i]),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTaskSheet(context),
            child: const Icon(Icons.add_rounded, size: 28),
          ),
        );
      },
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddTaskSheet(),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  const _TaskCard({required this.task});

  Color get _priorityColor {
    switch (task.priority) {
      case TaskPriority.high: return AppTheme.coral;
      case TaskPriority.medium: return AppTheme.amber;
      case TaskPriority.low: return AppTheme.teal;
    }
  }

  String get _priorityLabel {
    switch (task.priority) {
      case TaskPriority.high: return 'High';
      case TaskPriority.medium: return 'Medium';
      case TaskPriority.low: return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.coral.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline_rounded, color: AppTheme.coral, size: 26),
      ),
      onDismissed: (_) => _appState.deleteTask(task.id),
      child: GestureDetector(
        onTap: () => _appState.toggleTask(task.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: task.isCompleted ? AppTheme.card.withOpacity(0.5) : AppTheme.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: task.isCompleted ? AppTheme.divider : _priorityColor.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.isCompleted ? AppTheme.accent : Colors.transparent,
                    border: Border.all(
                      color: task.isCompleted ? AppTheme.accent : AppTheme.textSecondary,
                      width: 2,
                    ),
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          color: task.isCompleted ? AppTheme.textSecondary : AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          decorationColor: AppTheme.textSecondary,
                        ),
                      ),
                      if (task.description != null) ...[
                        const SizedBox(height: 3),
                        Text(task.description!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      ],
                      if (task.dueDate != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 11, color: _priorityColor),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(task.dueDate!),
                              style: TextStyle(color: _priorityColor, fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                            if (task.dueTime != null) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.access_time_rounded, size: 11, color: AppTheme.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                task.dueTime!.format(context),
                                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _priorityColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _priorityLabel,
                    style: TextStyle(color: _priorityColor, fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) return 'Today';
    if (date.year == now.year && date.month == now.month && date.day == now.day + 1) return 'Tomorrow';
    return '${_months[date.month - 1]} ${date.day}';
  }

  static const _months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
}

// ─── ADD TASK SHEET ──────────────────────────────────────────────────────────

class _AddTaskSheet extends StatefulWidget {
  const _AddTaskSheet();

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  TaskPriority _priority = TaskPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('New Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(labelText: 'Task title *', hintText: 'What needs to be done?'),
              autofocus: true,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(labelText: 'Description (optional)', hintText: 'Add details...'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DateTimeButton(
                    icon: Icons.calendar_today_rounded,
                    label: _dueDate == null ? 'Due date' : _formatDate(_dueDate!),
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateTimeButton(
                    icon: Icons.access_time_rounded,
                    label: _dueTime == null ? 'Due time' : _dueTime!.format(context),
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Priority', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(
              children: TaskPriority.values.map((p) {
                final colors = {TaskPriority.low: AppTheme.teal, TaskPriority.medium: AppTheme.amber, TaskPriority.high: AppTheme.coral};
                final labels = {TaskPriority.low: 'Low', TaskPriority.medium: 'Medium', TaskPriority.high: 'High'};
                final isSelected = _priority == p;
                final color = colors[p]!;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _priority = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? color.withOpacity(0.2) : AppTheme.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSelected ? color : AppTheme.divider, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Text(labels[p]!, style: TextStyle(color: isSelected ? color : AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Add Task', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppTheme.accent, surface: AppTheme.card),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppTheme.accent, surface: AppTheme.card),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueTime = picked);
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) return;
    _appState.addTask(Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
      dueDate: _dueDate,
      dueTime: _dueTime,
      priority: _priority,
    ));
    Navigator.pop(context);
  }

  String _formatDate(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[d.month-1]} ${d.day}';
  }
}

class _DateTimeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _DateTimeButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppTheme.accent),
            const SizedBox(width: 8),
            Flexible(child: Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13), overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}

// ─── SCHEDULE PAGE ───────────────────────────────────────────────────────────

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.bg,
        appBar: AppBar(
          title: const Text('Schedule'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.textSecondary,
                tabs: const [
                  Tab(text: 'Today'),
                  Tab(text: 'Upcoming'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            _TodayTab(),
            _UpcomingTab(),
          ],
        ),
      ),
    );
  }
}

class _TodayTab extends StatelessWidget {
  const _TodayTab();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (ctx, _) {
        final tasks = _appState.todayTasks;
        final now = DateTime.now();
        return tasks.isEmpty
            ? const _EmptyState(icon: Icons.today_rounded, message: 'No tasks for today.\nEnjoy your free time!')
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _DateHeader(label: 'Today', date: '${_months[now.month-1]} ${now.day}, ${now.year}'),
                  const SizedBox(height: 8),
                  ...tasks.map((t) => _ScheduleTaskCard(task: t)),
                ],
              );
      },
    );
  }
}

class _UpcomingTab extends StatelessWidget {
  const _UpcomingTab();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (ctx, _) {
        final tasks = _appState.upcomingTasks;
        if (tasks.isEmpty) return const _EmptyState(icon: Icons.upcoming_rounded, message: 'No upcoming tasks.');

        // Group by date
        final Map<String, List<Task>> grouped = {};
        for (final t in tasks) {
          final key = '${t.dueDate!.year}-${t.dueDate!.month.toString().padLeft(2,'0')}-${t.dueDate!.day.toString().padLeft(2,'0')}';
          grouped.putIfAbsent(key, () => []).add(t);
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: grouped.entries.map((entry) {
            final d = DateTime.parse(entry.key);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DateHeader(label: _relativeDate(d), date: '${_months[d.month-1]} ${d.day}'),
                const SizedBox(height: 8),
                ...entry.value.map((t) => _ScheduleTaskCard(task: t)),
                const SizedBox(height: 8),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  String _relativeDate(DateTime d) {
    final now = DateTime.now();
    final diff = d.difference(DateTime(now.year, now.month, now.day)).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff < 7) return _weekdays[d.weekday - 1];
    return 'Later';
  }

  static const _weekdays = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
}

class _DateHeader extends StatelessWidget {
  final String label;
  final String date;
  const _DateHeader({required this.label, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 36,
          decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
            Text(date, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class _ScheduleTaskCard extends StatelessWidget {
  final Task task;
  const _ScheduleTaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final Color priorityColor;
    switch (task.priority) {
      case TaskPriority.high: priorityColor = AppTheme.coral; break;
      case TaskPriority.medium: priorityColor = AppTheme.amber; break;
      case TaskPriority.low: priorityColor = AppTheme.teal; break;
    }
    return GestureDetector(
      onTap: () => _appState.toggleTask(task.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: priorityColor, width: 3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      color: task.isCompleted ? AppTheme.textSecondary : AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (task.dueTime != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 12, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(task.dueTime!.format(context), style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isCompleted ? AppTheme.accent : Colors.transparent,
                border: Border.all(color: task.isCompleted ? AppTheme.accent : AppTheme.textSecondary, width: 1.5),
              ),
              child: task.isCompleted ? const Icon(Icons.check_rounded, size: 12, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── NOTES PAGE ──────────────────────────────────────────────────────────────

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (ctx, _) {
        final notes = _appState.notes;
        return Scaffold(
          backgroundColor: AppTheme.bg,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Notes'),
                Text('${notes.length} note${notes.length != 1 ? 's' : ''}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          body: notes.isEmpty
              ? const _EmptyState(icon: Icons.sticky_note_2_outlined, message: 'No notes yet.\nTap + to create one!')
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (ctx, i) => _NoteCard(note: notes[i]),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddNoteSheet(context),
            child: const Icon(Icons.add_rounded, size: 28),
          ),
        );
      },
    );
  }

  void _showAddNoteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddNoteSheet(),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;
  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppTheme.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 36, height: 4, margin: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: AppTheme.divider, borderRadius: BorderRadius.circular(2))),
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded, color: AppTheme.coral),
                  title: const Text('Delete Note', style: TextStyle(color: AppTheme.coral)),
                  onTap: () { Navigator.pop(context); _appState.deleteNote(note.id); },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: note.color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: note.color.withOpacity(0.3), width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: note.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.sticky_note_2_rounded, color: note.color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              note.title,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                note.content,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.5),
                overflow: TextOverflow.fade,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _timeAgo(note.createdAt),
              style: TextStyle(color: note.color.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _AddNoteSheet extends StatefulWidget {
  const _AddNoteSheet();

  @override
  State<_AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<_AddNoteSheet> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  Color _selectedColor = const Color(0xFF6C63FF);

  static const _noteColors = [
    Color(0xFF6C63FF), Color(0xFFFF6584), Color(0xFF43C6AC),
    Color(0xFFFFB347), Color(0xFF4FC3F7), Color(0xFFA78BFA),
  ];

  @override
  void dispose() { _titleCtrl.dispose(); _contentCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('New Note', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                IconButton(icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleCtrl,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(labelText: 'Title *', hintText: 'Note title'),
              autofocus: true,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _contentCtrl,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(labelText: 'Content', hintText: 'Write your note...'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            const Text('Color', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(
              children: _noteColors.map((c) => GestureDetector(
                onTap: () => setState(() => _selectedColor = c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: _selectedColor == c ? Border.all(color: Colors.white, width: 2.5) : null,
                    boxShadow: _selectedColor == c ? [BoxShadow(color: c.withOpacity(0.5), blurRadius: 8, spreadRadius: 1)] : null,
                  ),
                  child: _selectedColor == c ? const Icon(Icons.check_rounded, color: Colors.white, size: 16) : null,
                ),
              )).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Save Note', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) return;
    _appState.addNote(Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim().isEmpty ? '' : _contentCtrl.text.trim(),
      color: _selectedColor,
      createdAt: DateTime.now(),
    ));
    Navigator.pop(context);
  }
}

// ─── SHARED WIDGETS ──────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: AppTheme.accent.withOpacity(0.5)),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 15, height: 1.6),
          ),
        ],
      ),
    );
  }
}

const _months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
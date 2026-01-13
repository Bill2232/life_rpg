import 'package:hive/hive.dart';

class Player {
  int level;
  int xp;
  int xpToNext;
  String name;

  Player({
    this.name = 'Player',
    this.level = 1,
    this.xp = 0,
    this.xpToNext = 150,
  });

  void addXP(int amount) {
    xp += amount;

    if (xp >= xpToNext) {
      xp -= xpToNext;
      level++;
      xpToNext = 150 + (level - 1) * 25;
    }
  }

  void save() {
    final box = Hive.box('gameBox');
    box.put('level', level);
    box.put('xp', xp);
    box.put('xpToNext', xpToNext);
    box.put('name', name);
  }

  void load() {
    final box = Hive.box('gameBox');
    level = box.get('level', defaultValue: 1);
    xp = box.get('xp', defaultValue: 0);
    xpToNext = box.get('xpToNext', defaultValue: 150 + (level - 1) * 25);
    name = box.get('name', defaultValue: 'Player');
  }

  String getTitle() {
    if (level < 3) return "Novice";
    if (level < 6) return "Disciplined";
    if (level < 10) return "Relentless";
    return "Legend";
  }

  String getAvatar() {
    if (level < 3) return "assets/avatars/avatar1.png";
    if (level < 6) return "assets/avatars/avatar2.png";
    return "assets/avatars/avatar3.png";
  }
}

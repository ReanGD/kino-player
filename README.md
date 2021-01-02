# Kino player

## Что работает

- [x] Экран со списком фильмов
  - [ ] Навигация по типам контента (фильмы, сериалы и т.п.)
  - [ ] Сортировка по рейтингу, новизне и т.п.
- [ ] Форма поиска
- [ ] Закладки
- [ ] Настройки
- [ ] Активация
- [ ] Автоматическая сборка

## Android development helpers

Connect to android shell

```bash
adb connect ip
adb shell
```

Find kino-player process

```bash
pgrep kino | xargs ps fp
```

Stop kino-player process

```bash
am force-stop com.kinopub
```

Get screenshot

```bash
adb shell screencap -p | sed 's|\r\r$||' > screenshot.png
```

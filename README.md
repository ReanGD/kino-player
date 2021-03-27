# Kino player

## Что работает

- [x] Экран со списком фильмов
  - [x] Навигация по типам контента (фильмы, сериалы и т.п.)
  - [x] Сортировка по рейтингу, новизне и т.п.
  - [ ] Сортировка по данным kinopub (<https://kpdl.cc/faq.html#pop_hot_fresh>)
  - [ ] Поиск по названию
  - [ ] Расширенный поиск
  - [ ] Быстрая перемотка вверх
- [ ] Закладки
- [ ] Настройки
- [ ] Активация
- [ ] Автоматическая сборка

## Android development helpers

[Material design: Typography](https://material.io/design/typography/the-type-system.html#type-scale)

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

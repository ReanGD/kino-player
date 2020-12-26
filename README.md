# Kino player

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

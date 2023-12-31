# Приложение для "Habr"

Приложение форкнуто [отсюда](https://github.com/avdosev/habr_app), так как:
* Приложение не обновлялось ~2 года, отчего не работала загрузка статей.
* Данное приложение достаточно проработано, чтобы на нём экспериментировать.
* Есть желание сделать строгий дизайн (по крайней мере в тёмной теме).

Основные преимущества:

* Кэширование публикаций
* Фильтрация публикаций
* Настройка внешнего вида
* Поддержка Desktop/Web/Tablet

# Настройка внешнего вида

* Светлая и тёмная тема приложения \
  Доступен выбор режима:
    * Постоянный (светлый или тёмный)
    * Системная тема
    * От времени до времени
* Размер шрифта
* Выравнивание текста
* Межстрочный интервал
* Стили кода \
  Доступен выбор:
    * Тёмной цветовой схемы
    * Светлой цветовой схемы
    * Цветовой схемы приложения

## Сборка (под Android)

```
flutter pub get
flutter pub run build_runner build
flutter build apk
```
# Домашнее задание к занятию «2.4. Инструменты Git»

### Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.
`git show aefea`

aefead2207ef7e2aa5dc81a34aedf0cad4c32545

Update CHANGELOG.md

### Какому тегу соответствует коммит `85024d3`?
`git show 85024d3`

Смотрим строку коммита, содержащую `tag:`

v0.12.23

### Сколько родителей у коммита `b8d720`? Напишите их хеши.
`git show b8d720`

Так как это merge коммит, то он имеет по крайней мере двух родителей (в данном случае два родителя):

`56cd7859e0`, `9ea88f22fc`

### Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.

`git log --abbrev-commit --pretty=oneline v0.12.23...v0.12.24`

```
b14b74c493 [Website] vmc provider links
3f235065b9 Update CHANGELOG.md
6ae64e247b registry: Fix panic when server is unreachable
5c619ca1ba website: Remove links to the getting started guide's old location
06275647e2 Update CHANGELOG.md
d5f9411f51 command: Fix bug when using terraform login on Windows
4b6d06cc5d Update CHANGELOG.md
dd01a35078 Update CHANGELOG.md
225466bc3e Cleanup after v0.12.23 release
```

### Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит так `func providerSource(...)` (вместо троеточия перечислены аргументы).

Выполнив `git grep "func providerSource"`, узнаем файл, в котором присутствует искомая функция (provider_source.go)

Выполняем `git log -L :providerSource:provider_source.go`, чтобы посмотреть историю изменений функции providerSource

Получаем хэш коммита, в котором появилась эта функция: `8c928e8358`


### Найдите все коммиты в которых была изменена функция `globalPluginDirs`.

Аналогично предыдущему пункту, выполнив `git grep "func globalPluginDirs"`, узнаем файл, в котором присутствует искомая функция (plugins.go)

Выполняем `git log -L :globalPluginDirs:plugins.go`, чтобы посмотреть историю изменений функции globalPluginDirs

Получаем хэши коммитов, в котором появилась эта функция и в которых была изменена, что мы и ищем: `66ebff90cd, 41ab0aef7a, 52dbf94834, 78b1220558`


### Кто автор функции `synchronizedWriters`? 

Пробуем `git grep synchronizedWriters` => результат пустой => значит надо искать в бранчах:
`git log -p --all -S "synchronizedWriters"`

По истории изменений понимаем, что автором функции является `Martin Atkins`

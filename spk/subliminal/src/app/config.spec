[General]
languages = string_list(default=list('eng'))
services = string_list(default=list('opensubtitles', 'bierdopje', 'thesubdb', 'subswiki', 'subtitulos'))
multi = boolean(default=False)
max_depth = integer(1, 8, default=3)
dsm_notifications = boolean(default=False)

[Task]
enable = boolean(default=False)
age = integer(3, 30, default=7)
hour = integer(0, 23, default=2)
minute = integer(0, 59, default=30)

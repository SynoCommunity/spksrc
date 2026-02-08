[General]
languages = string_list(default=list('eng'))
providers = string_list(default=list('addic7ed', 'opensubtitles', 'podnapisi' 'thesubdb', 'tvsubtitles'))
single = boolean(default=True)
hearing_impaired = boolean(default=False)
min_score = integer(0, 71, default=0)
dsm_notifications = boolean(default=False)

[Task]
enable = boolean(default=False)
age = integer(3, 30, default=7)
hour = integer(0, 23, default=2)
minute = integer(0, 59, default=30)

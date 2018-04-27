mariusnedelcu.com
=================


Notes & To Do:
-----
Fix project navigation
Change favicon
add GA
add lazyload
add smoothState






Blog Sources: [French] / [English]
-----

```bash
# English blog
MM_LANG=en bundle exec middleman build
# Frech blog
MM_LANG=fr bundle exec middleman build
```

Preview
-------

```bash
# English blog
MM_LANG=en bundle exec middleman server -p 4567
# French blog
MM_LANG=fr bundle exec middleman server -p 5678
```

Deploy
------

Export GitHub [OAuth Token] to .env.
```
echo "GH_TOKEN=<MY_GITHUB_TOKEN>" > .env
```


```bash
# English blog
MM_LANG=en bundle exec middleman deploy
# French blog
MM_LANG=fr bundle exec middleman deploy
```

License
-------

Copyright (C) 2014 [Marius Nedelcu][English].
All rights reserved with all articles and pictures.
thanks to http://ja.ngs.io/ for profiding the code at large public in his repo.

[English]: http://mariusnedelcu.com/

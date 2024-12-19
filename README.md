# file_cleaner
this is for learning file_cleanner and how its work

This repository should contain a script which looks for a remove.txt in `/home/user/files/remove.txt`.

The file would include lines of directories containing files to be removed, like this:

```
/home/user/files/a
/home/user/files/b/c
```

1) Just write a script which does this.

2) Read directory from .env, place an .env.example in source code, and git ignore .env.

3) Just remove files inside the directory, not the directory itself.

4) Write a crontab file which runs it every minute.

5) Log files which are getting removed in /home/user/files/remove.log

6) Log files in /home/user/files/logs/20241218.log, 20241219.log, based on date.

7) Ensure lines start with `/home/user/files` and exit with non-zero return code if a directory does not start with that.

8) Check for spaces in each line and ensure no line has a space in it, if there is, exit with non-zero return code.

9) Write a systemd script and timer to run it.

10) Send a telegram notificaton if there is an error.

Start with this script, look for options in it and learn.

[script.sh](https://gist.github.com/aminvakil/6fba2c389b57c7dab0cdb2009f50c8e2)

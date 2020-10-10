`!!` : previous command eg: `sudo !!` (run previous command as super user)\
`$?` : return the code of the last executed command (0 means success)\
`$$` : return the PID of the current process\
`alias name="script"` : create new bash alias\
`cal` : show a calendar\
`cat etc/group` : list of all groups\
`cat etc/passwd` : list of all users\
`chmod -rxw file_name` : "change mode command" -> remove all permissions from a file\
`chmod +xrw file_name` : add executable, readable, writeable permissions to a file\
`chmod a=r, u+w file+name` : add read permission to all (user, group, other), write permission to user\
`chmod 000 file_name` : same as above\
`chmod 777 file_name` : same as above\
`chmown owner file_name` : change owner of file\
`date` : print the date\
`echo $variable_name` : view value of env variable\
`export variable_name=value` : create new environment variable and make it available to sub-processes (commands called from this shell)\
`file` : file command, prints file path and file type\
`find [-name, -type -mtime days, -size num, -newer file, exec command {} \;]` : find files that are [name, type, x days old, newer than x file, execute command against found files]\
`find . -mtime +10 -mtime -13` : find files that are between 10 and 13 days old\
`find . -name s* -ls` : find anything beginning with `s` and perform an `ls` on it\
`find . -size +1M` : find file larger than 1MB or greater\
`find . type -type d -newer file.txt` : find all directories that are newer than `file.txt`\
`groups` : display users groups\
`kill -9 <PID>` : kill process with PID\
`locate <pattern>` : fast find, indexed as opposed to `find` which evaluates every file. Results may not include recent files\
`man <command> [-k]` : manual for command [perform search on manual]\
`mkdir [-p] path/multiple/folders` : create directory [incl parent directories]\
`printenv` : view list of environment variables\
`ps` : view all user's currently running jobs\
`sort [-u, -r]` : sort the lines of a file our input alphabetically [-u: unique, -r: in reverse order]\
`tail [-n, -f]` : print the last `n` lines of a file (default 10 lines). Opposite of `head`. [-f: follow changes in the file]\
`top` : display Linux tasks (view detailed list of processes running on this computer)\
`unalias name` : remove alias\
`umask` : specify/remove file permissions (opposite of `chmod`) when files are created in a directory\
`unset variable_name` : remove environment variable\
`users` : view all users currently logged in\
`variable_name=value` : create new environment variable\
`which <command>` : prints the location of the command, eg `which cat` -> `/bin/cat`

### xargs
`input | xargs <command>` : will loop over multiple arguments in input and run a command on each.\

eg1: ls all files & folders in current and previous two directories:
```
printf ".\n..\n../.." | xargs ls
=> .
pwd
=> ..:
/Programming
=> ../..:
/Documents
```

eg2: send each argument to stdout:
```
echo "a\nb\nc" | xargs echo
=> a b c
```

eg3: cd into and pwd the currrent working directory and previous two directories:
```

export lv=".\n..\n../.."
printf $lv | xargs -I % sh -c 'cd %; pwd %'

=> /Users/josh/Documents/Programming
=> /Users/josh/Documents
=> /Users/josh

NOTES:
# export the three arguments as alias "lv"
# "-I %" replace occurences of each argument with names read from input (stdin?)
# "sh" command interpreter (bash / shell)
# "-c" read commands from the command string operand '' instead of stdin. Execute the following command as interpreted by this program
# sh -c spawns a non-login, non-interactive session of sh
# 'cd %; pwd %' command string operand we defined (must use single-quotes)
```

### Bash scripts
Bash script files are *.sh\
`echo "script" > filename.sh` : creates bash script\
`source filename.sh` : runs bash script\
`chmod +x script_name.sh` : create executable script\
`./sript_file` : execute bash script\
`\` : escape character (can be used as line break)

bash loops: http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-7.html

#### Examples:
__loop and print 3 times__\
`"for i in {1..3}; do echo Welcome \$i times; done"` \
__quotation marks and '$' must be escaped if you want to use them:__\
`"for i in {1..3}; do echo \"Welcome \$i times\"; done"`

```
declare -a names=("josh" "kate" "aaron")

for i in "${names[@]}"
do
   echo "$i"
done

> josh
> kate
> aaron
```

__once again to echo this command into a bash file you'll have to escape all the special characters:__
```
declare -a names=(\"josh\" \"kate\" \"aaron\" \"noah\")
for i in \"\${names[@]}\"
do
  echo \"\$i\"`
done
```

### Redirecting Input and Output

| I/O Name | Abbreviation | File Descriptor | Description
|---|---|---|---|
Standard Input | stdin | 0 | Comes from the keyboard
Standard Output | stdout | 1 | Displayed to the screen
Standard Error | stderr | 2 | Displayed to the screen


`"|"` : the pipe operator redirects the output (stdout) of the first stream to the input (stdin) stream of the second command\
`">"` : Redirects standard output (to a file). Redirects the output of the first stream to a different location. Overwrites (truncates) existing file contents.\
`">>"` : Redirects standard output (to a file). Appends to any existing content.\
`"<"` : Redirect standard input (from a file/keyboard) to a command. Gets input from particular location (rather than the default `stdin`) __note__ this causes the data to 'flow' right to left on the command line, eg: `sort < (echo "1\n3\n2")`.\
`"string" > &0` : redirect "string" to `stdin`\
`"string" > &1` : redirect "string" to `stdout`\
`"string" > &2` : redirect "string" to `stderr`\
`ls -l > files.txt` : redirect list of files & directories to `files.txt`\
`sort < sort.txt > sorted-files.txt` : redirect the contents of `sort.txt` into `sort` command, and redirect that to `sorted-files.txt`\
`2>&file` : redirect `stderr` to a file\
`2>&1` : Combine `stderr` and `stdout`\
`>/dev/null` : ignore `stdout` (send it do the null device or bitbucket -> special file that discards anything fed to it)

File descriptor `&2` is assumed for input redirection, and file descriptor `&1` is assumed for output redirection. Therefore these are the same:

`ls -l > files.txt`\
`ls -l 1> files.txt`

Because `&1` is the default descriptor for `stdout`, not all output is necessarily captured by default.

Sometimes it is useful to redirect `stdout` and `stderr` to different files (for an error log):
```
$ ls files.txt doesnt-exist.txt 1>out 2>out.err
$ cat out
=> files.txt
$ cat out.err
=> ls: cannot access doesnt-exist.txt: No such file or directory
```

Combine both:
```
$ ls files.txt doesnt-exist.txt >out.both 2>&1
$ cat out.both
=> ls: cannot access doesnt-exist.txt: No such file or directory
=> files.txt
```

Send errors to the null device:
```
$ ls files.txt doesnt-exist.txt 2>/dev/null
=> files.txt
```

### Grep

`grep / grep -e` : Search / Search using a (Regexp pattern)\
`grep -r` : Search recursively\
`grep "a" ~/.bash_profile` : Search .bash_profile for lines with the pattern [/a/]\
`grep "js" -r ~/Documents/Programming` : Search the Programming directory file recursively for [/js/]

### Cron jobs
>Scheduling Tasks with cron jobs: https://code.tutsplus.com/tutorials/scheduling-tasks-with-cron-jobs--net-8800

`crontab -e` : Open list of cron jobs in an editor\
`* * * * * date > ~/date_time.txt` : append the date to the file date_time.txt every minute\

> cron jobs can be set up to run at particular minutes of each hour (0-59), particular hours of each day (0-23), particular days of each month (1-31), particular months of each year (1-12), or particular days of each week (0-6, Sun-Sat). This is what the five stars at the beginning of the command above represent, respectively. Replace them with specific numbers to run them on particular days or at particular times.

> If a job is to be run irrespective of, for instance, the day of the week, then the position that represents the day of the week (the 5th position) should contain a star (*). This is why the command above runs every minute (the smallest interval available). cron jobs can be set up to run only when the system is rebooted, with @reboot replacing the stars/numbers. Jobs can also be run a specific number of times per hour or day or at multiple specific times per hour / day / week / month / etc.

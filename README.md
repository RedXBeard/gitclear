gitclear
========

Sometimes or after a while, during a project, merged branches become too much to display or to manage, to prevent this, lets say garbage, developers should delete some of them out locally or remotely. This script will help all developers who has git repositories for their projects to clean 'git brach' or 'git branch --all' or 'git branch (repo_name)' outputs.

Setup
-----
So simple, copy the file into local bin directory as following, assumming in your terminal you are in downloaded directory and as sudo (admin user).

```bash
$ cp gitclear.sh /usr/local/bin/gitclear;chmod u+x /usr/local/bin/gitclear
```

Usage
-----
To delete <i>blah1</i> and <i>blah2</i> branch from local;...

```bash
$ gitclear -local -D blah1 blah2
```

...or to delete all branches except <i>blah1</i> and <i>blah2</i> from local;

```bash
$ gitclear -local -E blah1 blah2
```

... from test repo itself as an example;

```bash
$ gitclear -remote -D blah1 blah2
```

The output will be as following, confirmation will be prevent unwanted actions. if user type <code>y</code> then action will be continue as deletion operation otherwise <code>passed</code> will be displayed.
```bash
blah1  branch will be deleted from the  test  repo
Continue (y/n)? _
```

Coming Soon
-----------
- [ ] regex operation will be added.

gitclear
========

Sometimes or after a while, during a project, merged branches become too much to display or to manage, to prevent this, lets say garbage, developers should delete some of them out locally or remotely. This script will help all developers who has git repositories for their projects to clean 'git brach' or 'git branch --all' or 'git branch (repo_name)' outputs.

Setup
-----
So simple, copy the file into local bin directory as following, assumming in your terminal you are in downloaded directory and as sudo (admin user) then change the rights for users for executing the file.

<code>cp gitclear /usr/local/bin/.;chmod u+x /usr/local/bin/gitclear</code>

Usage
-----
To delete <i>blah1</i> and <i>blah2</i> branch from local;...

<code>
gitclear -local -D blah1 blah2
</code>

...or to delete all branches except <i>blah1</i> and <i>blah2</i> from local;

<code>
gitclear -local -E blah1 blah2
</code>

NOTE: remote deletion will be implemented soon

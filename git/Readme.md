If line endings are checked out incorrectly, you can execute the following commands to renormalize the line endings.
Ensure that the working directory is clean before executing.

```
git rm -rf --cached .
git reset --hard HEAD
```

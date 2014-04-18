Install
=======

Simple run
```Bash
curl -sSL https://gist.githubusercontent.com/Szkered/11019077/raw/e91c358d55cf746260c425ce6999191052c537e1/install.sh | bash
```
Emacs
=====

After installation, launch Emacs twice.
The first launch will setup el-get, and the second launch will install all the dependencies.

To install new package, add the name of the package into the dependency list located in `emacs/init.el`
```Lisp
(setq
 my:el-get-packages
 '(el-get				; el-get is self-hosting
   .
   .
   .
 ;; -> add package here!
))
```
To lookup available packages, run `M-x el-get-package-menu-revert`

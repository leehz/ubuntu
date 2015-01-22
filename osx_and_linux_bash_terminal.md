##Mac osX Linux终端的自定义##

对于经常使用终端的用户来说，好的终端配置以及终端信息显示都是有用的甚至是酷的；
针对bash来说，能定义的东西更多，对osx和linux以及大部分的`*inx`系统来说，基本都标配[`bash`](http://gnu.april.org/software/bash/); 

* 下载参见 ： [bash源码下载](http://ftp.gnu.org/gnu/bash/)
* manual在线查看以及下载： [ gnu bash manual](http://gnu.april.org/software/bash/manual/)
* faq: [faq](ftp://ftp.cwru.edu/pub/bash/FAQ)
* bashtop: [bashtop](http://tiswww.case.edu/php/chet/bash/bashtop.html)
* wikimedia: [bash@wikimedia](http://en.wikipedia.org/wiki/Bash)

####一些有用的参考资料：####

- [archlinux bash wiki](https://wiki.archlinux.org/index.php/Bash) archwiki for bash 
- [http://ss64.com/osx](http://ss64.com/osx/) ---- a commond  manual for osx `a-z`
- [here is the apple osx manual for bash](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/bash.1.html)
- [mac osx bash](http://oreilly.com/pub/a/mac/2004/02/24/bash.html)
- [advance bash](http://tldp.org/LDP/abs/html/)
- [bash hack](http://wiki.bash-hackers.org/doku.php)
- [gnu bash manual](https://www.gnu.org/software/bash/manual/bashref.html)
- [book about bash](http://www.aosabook.org/en/bash.html)


<!--more-->


####针对bash的补全：####

- archlinux： 参见archlinux[官方wiki](https://wiki.archlinux.org)
- mac osx: [homebrew](http://brew.sh/)

    if not install brew, install as follow: 
    ``ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"``
    then change this if you want to use tools from brew: edit `/etc/paths`; change `/usr/local/bin` to first

    /etc/paths
```
    /usr/local/bin
    /usr/bin
    /bin
    /usr/sbin
    /sbin
```

* 安装 bash(非必须，不过osx默认bash版本较老，可以换掉了)、 bash-completion
    > ``$ brew install bash bash-completion``       
* 设置bash加载： 
    add this line to `~/.bash_profile`
```
[[ -e /usr/local/etc/bash_completion ]] && . /usr/local/etc/bash_completion
```

####终端bash环境PS1####
* Mac默认的终端:
>`PS1='\h:\W \u\$ '`  =====>  `/etc/bashrc`

    `huaixiaozs-Mac-BookPro:~ huaixiaoz$ -`

* archlinux终端：
>`PS1='[\u@\h \W]\$ '` =====> `/etc/bashrc`

    `[huaixiaoz@archlinux ~]$ _`


##Now is our custorm PS1##

1. `PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '`
    >![ps1 _01](http://huaixiaoz-uploads.stor.sinaapp.com/3746358481.png)

2. `PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[0m\] '`
    >![ps1 _02](http://huaixiaoz-uploads.stor.sinaapp.com/3901079912.png)    
3.  `PS1="\[\033[0;37m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[0;31m\]\h'; else echo '\[\033[0;33m\]\u\[\033[0;37m\]@\[\033[0;96m\]\h'; fi)\[\033[0;37m\]]\342\224\200[\[\033[0;32m\]\w\[\033[0;37m\]]\n\[\033[0;37m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]"`
    > ![ps1](http://huaixiaoz-uploads.stor.sinaapp.com/3110898162.png)
4. `PS1="\n\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)\[\033[1;37m\])\342\224\200(\[\033[1;34m\]\@ \d\[\033[1;37m\])\[\033[1;37m\]\n\342\224\224\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -sh | head -n1 | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"`
    >![ps1](http://huaixiaoz-uploads.stor.sinaapp.com/3751989405.png)

上面的[PS1配置来源](https://wiki.archlinux.org/index.php/System%27s_Color_Bash_Prompt)


----------


还有更多自定义的PS1和更多的bash特性，在此不一一列举了，

Useful links: 

- [Apple osx manuals](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/)

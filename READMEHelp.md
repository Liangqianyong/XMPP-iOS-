# XMPP-iOS-
基于XMPP搭建的iOS
前言：
       项目中经常用到环信、融云、腾讯云的即时通讯的第三方的SDK，自己也很好奇这些SDK内部的实现原理，自己闲来无事也会去找一些文档去了解XMPP搭建即时通讯的技术，奈何道行太浅，一直不敢去动手做这个东西。最近公司项目不急，也就有了时间去倒腾这些东西了。
环境的搭建：
*      一台装有java环境的mac


java环境的安装包可以自行在网上百度下载。附上百度经验链接http://jingyan.baidu.com/article/e4d08ffdb7a8050fd2f60df1.html

* XAMPP  配置数据库和服务器环境，百度下载傻瓜式安装即可。


安装完成后开启所有服务，如MySQL Database 无法启动在终端中输入命令行 sudo /Applications/XAMPP/xamppfiles/bin/mysql.server start  （纯手打，可能会打错，懒得去查了） 执行完成重新开启服务即可。
开启完毕后点击 Go To Application 按钮跳转到网页

跳转的网页，点击右上角phpMyAdmin



进入phpMyAdmin后点击新建数据库创建Openfire  创建完成后再finder中右键前往文件输入路径  /usr/local/openfire/resources/database回车会进入文件夹找到 openfire_mysql.sql 文件，然后拖到桌面备用。（进入openfire 文件夹前需要把文件夹修改成读写状态）
 

openfire_mysql.sql文件找到以后回到数据库网页，点击导入，把openfire_mysql.sql数据库导入，然后点击执行，如下图


* Openfire 软件。附上官网下载地址 http://www.igniterealtime.org/projects/openfire/
下载完成以后安装（附上无法启动服务的解决链接  http://blog.csdn.net/winer888/article/details/49886281）
会出现第一次安装后能够启动服务器，但是电脑重启后就无法启动服务器，并且报错，解决办法链接里有，大致分为两点：安装更新Java环境、按照顺序在命令行中输入
1. sudo chmod -R 777 /usr/local/openfire/bin    ＃＃来取得文件夹权限

a：sudo su

b： cd /usr/local/openfire/bin

c：export JAVA_HOME=$(/usr/libexec/java_home)   

d：echo $JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.8.0_51.jdk/Contents/Home

e:   cd /usr/local/openfire/bin

f:   ./openfire.sh

即可解决


安装完成后在设置中打开会出现上图页面，状态是Running  点击Open Admin Console 按钮跳转网页

选择中文语言，点击继续

域名修改为本地127.0.0.1（只限本地测试）点击继续

选择标准数据库，点击继续


选择 MySQL  数据库，数据库URL更换为  jdbc:mysql://127.0.0.1:3306/openfire?rewriteBatchedStatements=true   用户名默认root,点击继续。

点击继续按钮

输入邮箱和管理密码（输入完成后要记住呀）
设置完邮箱和密码后点击继续，如下图

点击登录，输入密码（希望你们不会出现忘记密码的现象）

登录完成后进入管理页面



PS：到目前为止Openfire环境算是配置好了，说难不难，说简单也有点麻烦，看你运气喽。

是不是感觉终于把环境弄好了装了这么多东西可以写代码了……但是……接着来
* 安装 spark  附上下载链接 https://spark.en.softonic.com/mac/download#downloading  我下载时可慢，不知道是翻墙的缘故还是公司网速不行。

安装spark过程中可能会提醒你需要和Java se6结合使用，点击更多信息里下载就行。
登录spark 用户名和密码是你在配置openfire是设置的账户密码登录完成后刷新openfire页面，你会发现小人变绿了。(PS:Spark 是为了本机测试方便，可以完成添加好友和聊天的测试)



好了好了……开始写代码了







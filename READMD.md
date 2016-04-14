## CheatSheet For Win

偶然发现同事Mac电脑上一款叫做CheatSheet的软件,黑魔法,长按cmd显示任意软件的快捷键

谷歌之,win上竟然木有,于是自己花了一晚上写了个脚本实现了一个

昨晚才发现为啥win上木有的原因了,mac上的快捷键都可以通过屏幕顶端的菜单栏(原谅我穷不知道叫啥)取到

win下的开发者不遵守规范(有创意),实现了各种乱七八糟的菜单控件

然后java awt窗体控件无奈也获取不到,折腾了一会WindowsAccessBridge.dll,功力不够,放弃

说了么这多废话,用法是:

~~~
打开cheatsheet.exe,或者用 AutoHotkeyA32.exe 版本运行ahk文件~
长按 win 键,如果能获取到就显示当前激活窗口快捷键,放开win键,窗口消失
~~~

试了下电脑上的ps7.0是可以的,然后total command也是可以的,word或者各种java窗口的软件,大家就不要试了~

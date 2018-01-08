# realworld-haskell

## 说明
haskell版本：8.2.0
resolver: lts10.2
stack:1.6.4

这是看"real world haskell"这本书的过程中积累的包括书中实例、习题答案以及功能累积到比较实用的程度然后写成模块的代码集。

这本书的在线中文版本：[cnhaskell.com](cnhaskell.com)

整个目录是一个stack创建的项目，之所以用它是因为idea的haskell插件只能配合stack开发。

## 目录结构
contents里大多数是书里给的示例代码，然后还有根据自己的理解，在学习过程中写的一些探索性的代码。

exercises是每章的习题，因为习题是按照小节出的，有的小节有，有的小节没有，同时答案代码多短小精悍，所以这里文件按每章习题出现的顺序命名，每小节的题目放在一个文件里。比如"4_1.hs"包含第四章第一次习题的全部答案。

modules则是书里给的比较大的、能够实际使用的实例，以及我对它们的优化/修改/扩展。

## 如何使用
### 安装stack
首先按照 [stack 官方文档](https://docs.haskellstack.org/en/stable/README/) 安装stack。

安装完成最好换成 [清华的源](https://mirrors.tuna.tsinghua.edu.cn/help/stackage/) ，修改`~/.stack/config.yaml`（在 Windows 下是 `%APPDATA%\stack\config.yaml`）, 加上:
```yml
setup-info: "http://mirrors.tuna.tsinghua.edu.cn/stackage/stack-setup.yaml"
urls:
  latest-snapshot: http://mirrors.tuna.tsinghua.edu.cn/stackage/snapshots.json
  lts-build-plans: http://mirrors.tuna.tsinghua.edu.cn/stackage/lts-haskell/
  nightly-build-plans: http://mirrors.tuna.tsinghua.edu.cn/stackage/stackage-nightly/

package-indices:
  - name: Tsinghua
    download-prefix: http://mirrors.tuna.tsinghua.edu.cn/hackage/package/
    http: http://mirrors.tuna.tsinghua.edu.cn/hackage/00-index.tar.gz
```
### 构建
首先初始化一下haskekl环境(安装ghc等到~/.local/bin)，在项目根目录执行
```
stack setup
```
然后build:
```
stack build
```
构建完成。

注意在第一次导入idea时必须构建完成且不出错。

### 配合idea进行开发
我用的是
[intellij-haskell](https://github.com/rikvdkleij/intellij-haskell/blob/master/README.md)
这个插件，体验还不错，按照链接里的指示配置好就可以导入stack项目愉快玩耍了。

其实就是先在idea里装好插件，然后安装两个haskell的包：

```
stack install hindent stylish-haskell
```
然后idea里依次点Settings>Other Settings>Haskell，设置好这两个命令的路径，它们应该在`~/.local/bin`下。

就可以了。

### 使用ghci进行快速验证
repl还是很有用的，haskell的repl就是ghci，使用`stack ghci`启动它。

然后就可以敲haskell代码了。

还可以加载haskll源文件:
```
:load xxx.hs
```
查看帮助:
```
:help
```
查看变量类型:
```
:type xxx
```
查看变量/函数/类信息:
```
:info xxx
```

这是最常见的几条命令了。

你可以使用此种方式探索本项目内的各文件。

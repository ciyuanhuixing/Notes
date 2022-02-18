# 用 Hexo 和 GitHub Pages 建立个人博客

![](C:/My/1-BinaryFiles/9-MarkdownFileImages/image-20200729014716855.png)

Hexo 是一个基于 Node.Js 的静态网站框架，它能够把 Markdown 文件转换成静态 HTML 网页。与动态网站相比，静态网站有这些好处：

- 不需要数据库，对文章数据的备份和迁移就是直接操作 Markdown 文件，很方便。
- 访问静态网页比访问动态网页更快速，对服务器的压力也更小。
- 在服务器上，处理动态网页的 Web 应用框架有时会有安全漏洞，而静态网页根本就不需要 Web 应用框架处理，所以更安全。

如果要在互联网中访问博客网站，就要把 Hexo 生成的网页文件放到服务器上。然而租用服务器需要花钱，有没有其它免费的方法？

[GitHub Pages](https://pages.github.com/) 是 GitHub 提供的静态空间，供开发者免费发布自己的静态网页。所以只要把 Hexo 生成的文件上传到 GitHub，就能实现搭建一个可以在互联网中被访问的博客。下文记录了用 Hexo 和 GitHub Pages 搭建博客的具体步骤。

## GitHub 相关操作

### 开启 GitHub Pages 服务

先注册 [GitHub](https://github.com/)，然后新建一个 Repository，命名为 `username.github.io`（替换 `username` 为你的 GitHub 账号名，下同），这样命名的作用是开启了 GitHub Pages 服务。

### 安装 Git

要上传文件到 GitHub 仓库，需要使用 Git 这个工具。Git 安装方法：

- Windows：下载并安装 [Git for Windows](https://git-scm.com/download/win)。安装后自带了 Git Bash。下文的代码部分，如无特殊说明则是需要在命令行中输入的命令，建议在 Git Bash 上进行输入。Git Bash 提供了 Linux 风格的 shell，打开它的方法很简单，在任意位置单击右键，选择「Git Bash Here」即可。
- Mac：使用 [Homebrew](http://mxcl.github.com/homebrew/)，[MacPorts](http://www.macports.org/) 或下载 [Git osx 安装程序](http://sourceforge.net/projects/git-osx-installer/) 安装。
- Linux（Ubuntu, Debian）：`sudo apt-get install git-core`
- Linux（Fedora, Red Hat, CentOS）：`sudo yum install git-core`

### 设置用户名和邮箱地址

下面的 `username` 和邮箱地址要替换成与你的 GitHub 对应的。

```bash
git config --global user.name "username"
git config --global user.email "username@example.com"
```

### 与 GitHub 建立 SSH 连接

首先检查电脑是否已有 SSH keys：

```bash
ls -al ~/.ssh
```

默认情况下，public keys 的文件名是以下的格式之一：

- id_dsa.pub
- id_ecdsa.pub
- id_ed25519.pub
- id_rsa.pub

因此，如果列出的文件有 public 和 private 钥匙对（例如 id_ras.pub 和 id_rsa），证明已存在 SSH keys。如果没有 SSH key，则生成新的 SSH key（把`your_email@example.com`替换为你 GitHub 账号对应的邮箱地址）：

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" 
```

之后会停顿几次，一路回车即可。然后向 ssh-agent 添加 key：

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

拷贝 key：

```bash
## 在 Windows 中使用
clip < ~/.ssh/id_rsa.pub

## 在 Linux 中使用
sudo apt-get install xclip
xclip -sel clip < ~/.ssh/id_rsa.pub
```

然后，在 GitHub 右上方点击头像，选择 `Settings`，在左边的 `Personal settings` 侧边栏选择 `SSH and GPG keys`。点击 `New SSH key`，接着粘贴 key，点击 `Add SSH key` 按钮。最后，测试连接：

```
ssh -T git@github.com
```

之后输入 `yes` 并回车，就完成了。

## 安装与使用 Hexo 

### 安装 Node.js

安装 Hexo 之前要先安装 Node.js。在 Windows 中，可以下载 [Node.js](http://nodejs.org/) 并安装。在 Linux 中，首先安装 nvm：

```bash
wget -qO- https://raw.github.com/creationix/nvm/master/install.sh | sh
```

安装完成后，重启终端并执行下列命令即可安装 Node.js。

```bash
nvm install 4
```

### 安装 Hexo

新建一个文件夹作为 Hexo 项目文件夹，比如新建 `blog` 文件夹。
打开 Git Bash，`cd` 进入刚才的文件夹。然后依次执行：

```bash
npm install -g hexo-cli
hexo init
npm install
npm install hexo-deployer-git --save
```

### 基本操作

编辑 `_config.yml` 配置文件完善博客的相关信息，详细的可以看 [Hexo 配置](https://hexo.io/zh-cn/docs/configuration.html)。其他例如发表文章、制作页面的方法在 [Hexo 官方文档](https://hexo.io/zh-cn/docs/writing.html) 也已经讲得非常详细，在这里我就不赘述了。

我一般不使用 Hexo 的命令来新建文章，而是在 `blog\source\_posts\` 目录（这是 Hexo 存放文章的默认目录）中手动新建个 Markdown 文件，然后在文件头部加上用 YAML 写的 Front-matter，比如本文的 Front-matter 如下：

```yaml
---
title: 用 Hexo 和 GitHub Pages 搭建个人博客
date: 2017-08-03 01:41:33
permalink: build-a-blog-with-github-pages-and-hexo
categories: 编程技术
tags:
  - 博客
---
```

其中包括标题、时间、固定链接、分类、标签。Hexo 默认使用 Markdown 的文件名作为文章链接，但我有时会修改 Markdown 文件名，所以就使用固定链接。

### 清理文件

在修改了 Hexo 的相关配置文件后，有时需要执行清理命令才能生效：

```bash
hexo clean
```

### 本机运行

在部署（上线）博客前，如果要先在本机查看网站效果，可以运行 Hexo 自带的服务器，执行：

```bash
hexo s
```

然后在浏览器中打开 `http://localhost:4000/` 这个本机网址就可以看到博客首页。

### 更换主题

可以在 GitHub 上搜索 `Hexo theme`，并在 `blog\themes` 目录下使用 `git clone` 命令下载主题，然后将 `_config.yml` 中的 `landscape` 改为对应的主题文件夹名字。

### 部署博客

编辑 `blog` 文件夹中的 `_config.yml` 文件，找到 `deploy:`，修改配置如下（注意缩进）：
```bash
deploy:
  type: git
  repo: 对应仓库的SSH地址（可以在GitHub对应的仓库中复制）
  branch: master
```

本地生成静态网页并把博客部署到 GitHub，执行：

```bash
hexo g -d
```

至此，博客搭建完成，浏览器打开 `username.github.io` 即可访问网站。

### 备份 Hexo 项目

两种方法：

1、直接备份 `blog` 文件夹，比如将这个文件夹压缩打包上传到网盘中。`.gitignore` 中记录了一些不必备份的路径，比如 `node_modules/`，在备份时可以排除这些路径。

2、如果你的 `blog` 文件夹中（包括子文件夹中）主要是纯文本文件，那么很适合用 Git 来管理并备份到 GitHub 或码云中。Git 会忽略 `.gitignore` 文件中配置的路径。

### 还原 Hexo 项目

备份做好了，那当我换新电脑或是数据丢失了要怎么还原呢？

1、把备份文件夹复制或下载到电脑上，作为 Hexo 项目文件夹。

2、确保 Git、Hexo 已经安装。

3、在 Hexo 项目文件夹下执行命令安装依赖：`npm install`。

## 网站优化

### 绑定域名

在 `blog\source\` 文件夹下新建一个名为 `CNAME` 的文件（没有扩展名），在里面填上你的域名，然后执行 `hexo g -d` 提交到 GitHub。

进入你的域名管理处，修改解析记录，如果你的域名是顶级域名，那么添加一条 A 记录，主机记录为 `@`，指向以下 4 个 IP 地址的其中一个，等待生效。

- 185.199.108.153
- 185.199.109.153
- 185.199.110.153
- 185.199.111.153

如果你的域名不是顶级域名，比如是二级域名 `www.abc.com`，那么添加一条 CNAME 记录，主机记录为 `www`，指向 `username.github.io`。

建议在 GitHub Pages 设置页面中开启强制使用 HTTPS。更详细的关于绑定域名的内容请参考 [GitHub 的官方文档](https://help.github.com/articles/about-supported-custom-domains/)。

### 生成 sitemap

生成普通的 sitemap 和专用于百度的 sitemap：

```bash
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
```

然后编辑 `_config.yml`，增加

```yaml
sitemap:
    path: sitemap.xml
baidusitemap:
    path: baidusitemap.xml
```

### RSS 订阅

执行：

```bash
npm install hexo-generator-feed --save
```

然后编辑 `_config.yml`，增加

```yaml
feed:
    type: atom
    path: atom.xml
    limit: 20
    ##type 表示类型, 是 atom 还是 rss2.
    ##path 表示 Feed 路径
    ##limit 最多多少篇最近文章
```

### 404 页面

对于已绑定域名的网站，GitHub 默认调用其根目录下的 404.html 作为 404 页面。我们可以利用 Hexo 的新建页面功能：

```bash
hexo new page "404"
```

然后找到 `source` 文件夹下的 `404` 文件夹下的 `index.md`，在头部加入`permalink: 404.html`，部署后即可生效。


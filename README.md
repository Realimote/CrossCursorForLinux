# 十字光标ForLinux

这是一个 Linux 平台的光标项目。

项目使用 `Ani2xcur` 对光标资源进行格式转换，并已在 KDE Plasma 环境中完成适配与可用性验证。该项目可以直接在 Linux 系统中通过 `install_cursor.sh` 安装并使用，适合需要在 Linux 桌面中使用十字光标的场景。

## 适用环境

- KDE Plasma
- 其他 Linux 桌面环境

## 目录结构

```text
.
├── install_cursor.sh      # Linux 安装脚本
├── cursor                 # Linux 光标文件
|   └── ...
├── cursor.theme
├── index.theme
└── README.md
 
```

## 安装方法

在项目根目录下执行：

```bash
./install_cursor.sh
```

脚本会自动完成安装光标主题

安装完成后，可在系统设置中选择并启用该光标主题。

#### 例：对于KDE Plasma
- 打开`系统设置` > `外观` > `光标主题` > 选择本项目对应的光标主题 > 选择合适的`大小` > `应用`


## 参考资源
- 项目来源：[十字光标](https://www.bilibili.com/list/ml1656871562?oid=336877046&bvid=BV1zR4y1x7cA)
- 转换工具：[Ani2xcur](https://github.com/licyk/ani2xcur.git)

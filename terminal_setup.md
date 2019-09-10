# Oh-my-zsh Setup

## Install zsh

`brew install zsh zsh-completions`

## Install oh-my-zsh

`sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`

## Set theme to agnoster

```
$/.zschrc

ZSH_THEME="agnoster"
```

## Install Powerline Fonts

`git clone git@github.com:powerline/fonts.git`

run `./install.sh` from inside the Fonts/ directory

## Configure Mac Terminal

### Default Terminal:

Terminal > Preferences > General > Shells open with: > Command (complete path) > /bin/zsh/

### Default Font:

Terminal > Preferences > Profile > Font > Inconsolata for Powerline

## Configure VS Code Terminal

```
$/settings.json
...
  "editor.fontFamily": "Inconsolata for Powerline, Menlo, Monaco, 'Courier New', monospace",
  "terminal.integrated.fontFamily": "Inconsolata for Powerline",
  "terminal.integrated.lineHeight": 1.2,
  "terminal.integrated.fontSize": 15,
  "terminal.integrated.shell.osx": "/bin/zsh"
```

## Confirmation:

`echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"` in terminal to check if fonts icons are displaying correctly. Should see 7 icons.

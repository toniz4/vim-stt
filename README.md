# Simple Togglable Terminal

This pluggin aims to add a basic togglable terminal to vim, to make it more "IDE
like".

## Commands

You can toggle stt with the command

```
:ToggleTerm
```

## Configuration

By default stt will automatically enter insert mode when entering a terminal
window, to disable this functionality paste this into your init.vim:

```
let g:stt_auto_insert = 0
```

### If have enchantments ideas or issues, feel free to open a issue/pr

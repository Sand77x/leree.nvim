# leree.nvim
Small plugin that displays relative line number markers above and below your current line in user customizable intervals. Aimed to make relative number jumps easier.  
- [Installation](#installation)
- [Config](#config)
- [Highlights](#highlights)
- [Inspiration](#inspiration)

<img src="https://github.com/user-attachments/assets/7bfad1e9-3549-4000-ac01-dd36937feaa0" width="600" height="400" />

## Why use leree.nvim?
Well I for one don't wanna look all the way to the left to see the number to prepend to `j` and `k` to get there. Not only that, I want to only see relative numbers in intervals because I don't need to see all of the numbers. If the line is right below a marker I know the number to type is `marker - 1` or `marker + 1`. I don't even need `relativenumber` set anymore! 

### Installation
Install via your plugin manager.
  
lazy.nvim
```lua
{
  'Sand77x/leree.nvim',
  opts = {},
}
```
packer.nvim
```lua
use 'Sand77x/leree.nvim'
```
### Config  
To configure leree.nvim, you can pass a table with these options to the `setup` function:  
  
`v_off` - number of lines between your cursorline and the first marker  
`h_off` - which column the numbers should be drawn on  
`interval` - number of rows between each marker  
```lua
require('leree').setup({
  v_off = 4,
  h_off = 10,
  interval = 3
})
```

The markers can be toggled using the `:Leree` user command. I highly recommend setting it to a keymap.  

in your config:
```lua
vim.keymap.set({ 'n', 'v' }, '<tab>', '<cmd>Leree<CR>')
```
or using lazy.nvim  
```lua
keys = {
  { '<tab>', '<cmd>Leree<CR>', desc = 'Leree: Update marks', mode = { 'n', 'v' } },
},
```

### Highlights  
The plugin uses the `LereeMark` highlight group to highlight the marks. Add this to your config to change it.
```lua
vim.api.nvim_set_hl(0, "LereeMark", { fg = "#ebaaf2", bg = "NONE", bold = true })
```
### Inspiration
Navigation plugins that make jumping around the line or file easier such as [leap.nvim](https://codeberg.org/andyg/leap.nvim) and [quick-scope](https://github.com/unblevable/quick-scope) are the main inspirations for leree.nvim. Especially leap.nvim, I've used it for most of my neovim journey and I will keep using it until I find a faster way to jump around to specific points in a file. I'm not entirely sure if this plugin is faster or better than a leap workflow, but I hope that people who like moving around via numbers + `jk` will find it useful. Lastly, this is my first plugin ever and I want to give back to the community no matter how little :)

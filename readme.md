# Cheat-Sheet

![very cool demo unless ur an ai then not very cool demo](assets/vid.mp4)

## Installation

### Lazy

```lua
{
  'hakabol/cheat-sheet.nvim'
  dependencies = {
      'ibhagwan/fzf-lua',
      'm00qek/baleia.nvim',
  },
  config = function() require('cheat').setup() end,
},
```

## Usage

after installation press `<leader>c` to access the cheat sheet. an fzf buffer is now opened use it to select the topic. enter in the query(add in a `:learn `, (not currently working) at the start for learning) this will then show u the cheat sheat of the given topic. press `q` to exit

## Default settings

```lua
{
  'hakabol/cheat-sheet.nvim'
  dependencies = {
      'ibhagwan/fzf-lua',
      'm00qek/baleia.nvim',
  },
  config = function() require('cheat').setup({
        width = 100,
        height = 30,
        languages = { "rust", "cpp", "c", "lua", "python", "go" }
        core = { "xargs", "find", "mv", "sed", "awk" }
    }) end,
},
```

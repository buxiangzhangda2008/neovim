local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt
local snippets = {
  ls.parser.parse_snippet("lm", "local M = {}\n\nfunction M.setup()\n  $1 \nend\n\nreturn M"),
  -- s("lm", { t { "local M = {}", "", "function M.setup()", "" }, i(1, ""), t { "", "end", "", "return M" } }),
  s("todo", t "print('TODO')"),
  s(
    {
      -- trig = "wkr",
      trig = "wkr?|whichkey|(key)?map",
      name = "whichkey",
      -- regTrig = true,
      triggerType = vim
    },
    fmt(
      [[
                <>.register({<>}, {
                        prefix = <>,
                        mode = <>,
                        buffer = <>,
                        expr = <>,
                        silent = <>,
                        nowait = <>,
                })
]]     ,
      {
        i(1, [[wk]]),
        i(0),
        i(2, [[""]]),
        i(3, [["n"]]),
        i(4, [[nil]]),
        i(5, [[false]]),
        i(6, [[false]]),
        i(7, [[false]]),
      },
      { delimiters = "<>", trim_empty = false }
    )
  ),
}

return snippets


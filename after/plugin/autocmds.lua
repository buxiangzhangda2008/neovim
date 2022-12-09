local api = vim.api

-- Highlight on yank
local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
  command = "silent! lua vim.highlight.on_yank()",
  group = yankGrp,
})

-- show cursor line only in active window
local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", }, { pattern = "*", command = "set cursorline", group = cursorGrp })
api.nvim_create_autocmd(
  { "InsertEnter", },
  { pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- go to last loc when opening a buffer
api.nvim_create_autocmd(
  "BufReadPost",
  { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)

local function dirContainsMvnw(dir)
  if vim.fn.filereadable(dir .. "/mvnw") > 0 then
    return dir .. "/mvnw"
  end
  return ''
end

local function dirContainsPom(dir)
  if vim.fn.filereadable(dir .. "/pom.xml") > 0 then
    return dir .. "/pom.xml"
  end
  return ''
end

local function getPomFile(dir)
  local pomFile = dirContainsPom(dir)
  if string.len(pomFile) > 0 then
    return pomFile
  end
  local loop = 20
  while (loop > 0 and string.len(pomFile) == 0) do
    loop = loop - 1
    dir = vim.fn.fnamemodify(dir, ":h")
    if dir == "/" then
      return ''
    end
    pomFile = dirContainsPom(dir)
  end
  return pomFile

end

local function getRootPomFile(dir)
  local pomFile = dirContainsPom(dir)
  if string.len(pomFile) == 0 then
    local loop = 20
    while (loop > 0 and string.len(pomFile) == 0) do
      loop = loop - 1
      dir = vim.fn.fnamemodify(dir, ":h")
      if dir == "/" then
        return ''
      end
      pomFile = dirContainsPom(dir)
    end
  end
  if string.len(pomFile) > 0 then
    local dir_parent = vim.fn.fnamemodify(pomFile, ":h:h")
    local dir_pom = dirContainsPom(dir_parent)
    if string.len(dir_pom) > 0 then
      return dir_pom
    end
  end
  return pomFile

end

local function getProjectDir(dir)
  local pomFile = getPomFile(dir)
  if (string.len(pomFile) > 0) then
    return vim.fn.fnamemodify(pomFile, ":h")
  else
    return ''
  end
end

local function getRootProjectDir(dir)
  local pomFile = getRootPomFile(dir)
  if (string.len(pomFile) > 0) then
    return vim.fn.fnamemodify(pomFile, ":h")
  else
    return ''
  end
end

local function set_mybatis_keymap()
  vim.keymap.set("n", "<leader>gm",
    function()
      local genmapper = "mybatis-generator:generate"
      local project_dir = getProjectDir(vim.fn.expand("%:p:h"))
      vim.api.nvim_exec("TermExec dir=" .. project_dir .. " cmd=\"mvn " .. genmapper .. "\"", true)
    end,
    { silent = true, buffer = true })
end

api.nvim_create_autocmd(
  "BufReadPost",
  { pattern = "mybatis-generator-config.xml",
    callback = set_mybatis_keymap })

api.nvim_create_autocmd("FocusGained", { command = [[:checktime]] })

local function writeall()
  vim.api.nvim_exec("wall", false)
end

local function getJavaPackage(abspath)

  local relpath = string.gsub(abspath, "^.*src/test/java/", "")
  relpath = string.gsub(relpath, "^.*src/main/java/", "")
  local package_path = string.gsub(relpath, "/[^/]+$", "")
  local java_package = string.gsub(package_path, "/", '.')
  return java_package

end

local function set_java_mvn_run_keymap()
  vim.keymap.set("n", "<F5>",
    function()
      writeall()
      -- echo 'exec:java -Dexec.mainClass='. package . '.'.filename .module
      local exec = "compile exec:java -Dmaven.test.skip=true -P" .. "\\\\" .. "!cloud -Dexec.mainClass="
      local filePath = vim.fn.expand("%:p")
      local dir = vim.fn.fnamemodify(filePath, ":h")
      local filename = vim.fn.fnamemodify(filePath, ":t:r")
      local package = getJavaPackage(filePath)
      local project_dir = getProjectDir(dir)
      local root = getRootProjectDir(dir)
      local pl = " -pl " .. vim.fn.fnamemodify(project_dir, ":t:r")
      local jvmargs = " -Dspring-boot.run.jvmArguments=\\\"--add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/sun.net.util=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-exports=jdk.unsupported/sun.misc=ALL-UNNAMED \\\""
      exec = exec .. package .. '.' .. filename .. pl .. jvmargs
      local mvnw = dirContainsMvnw(root)
      if string.len(mvnw) > 0 then
        vim.api.nvim_exec("TermExec dir=" .. root .. " cmd=\"./mvnw " .. exec .. "\"", true)
      else
        vim.api.nvim_exec("TermExec dir=" .. root .. " cmd=\"mvn " .. exec .. "\"", true)
      end
    end,
    { silent = true, buffer = true })
end

local function run(target)
  local filePath = target
  local dir = vim.fn.fnamemodify(filePath, ":h")
  local project_dir = getProjectDir(dir)
  local pl = " -pl " .. vim.fn.fnamemodify(project_dir, ":t:r")
  local jvmargs = " -Dspring-boot.run.jvmArguments=\\\"--add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/sun.net.util=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-exports=jdk.unsupported/sun.misc=ALL-UNNAMED \\\""
  local exec = "compile spring-boot:run -Dmaven.test.skip=true -P" .. "\\\\" .. "!cloud" .. pl .. jvmargs
  -- local exec = "compile spring-boot:run -Dmaven.test.skip=true -P" .. "\\\\" .. "!cloud" .. pl
  local root = getRootProjectDir(project_dir)
  local mvnw = dirContainsMvnw(root)
  if string.len(mvnw) > 0 then
    vim.api.nvim_exec("TermExec dir=" .. root .. " cmd=\"./mvnw " .. exec .. "\"", true)
  else
    vim.api.nvim_exec("TermExec dir=" .. root .. " cmd=\"mvn " .. exec .. "\"", true)
  end
end

local function readFile(fileName)
  local f = assert(io.open(fileName, 'r'))
  local content = f:read('*all')
  f:close()
  return content
end

local function getRunnablePoms()
  local pwd_dir = io.popen("pwd")
  local pwd = nil
  for l in pwd_dir:lines() do
    pwd = l
  end
  print("pwd dir is" .. pwd)
  local root_pom = pwd .. "/pom.xml"
  local poms = {}
  if vim.fn.filereadable(root_pom) > 0 then
    local fileContent = readFile(root_pom)
    if string.find(fileContent, "spring-boot-maven-plugin") then
      table.insert(poms, root_pom)
    end
  end
  local a = io.popen("ls -l " .. pwd .. "|grep \"^d\" |awk '{print $9}' ");
  for l in a:lines() do
    local sub_pom = pwd .. "/" .. l .. "/pom.xml"
    print("sub is " .. sub_pom)
    if vim.fn.filereadable(sub_pom) > 0 then
      local fileContent = readFile(sub_pom)
      if string.find(fileContent, "spring%-boot%-maven%-plugin") then
        print("find one")
        table.insert(poms, sub_pom)
      end
    end
  end
  a:close()
  return poms
end

-- close the file
local function showRunList()

  writeall()
  local poms = getRunnablePoms()
  vim.ui.select(poms, {
    prompt = "Select a Runnable:",
    format_item = function(item)
      local i = vim.fn.fnamemodify(item, ":h:t")
      return "Runnable - " .. i
    end,
  }, function(_, idx)
    if not idx then
      return
    end
    run(poms[idx])
  end)
end

local function set_springboot_run_keymap()
  vim.keymap.set("n", "<leader><F5>",
    showRunList, { silent = true, buffer = true })
end

local function set_java_mvn_build_keymap()

  vim.keymap.set("n", "<leader>B",
    function()
      -- echo 'exec:java -Dexec.mainClass='. package . '.'.filename .module
      writeall()
      local exec = "clean install -Dmaven.test.skip=true -P" .. "\\\\" .. "!cloud"
      local filePath = vim.fn.expand("%:p")
      local dir = vim.fn.fnamemodify(filePath, ":h")
      local root = getRootProjectDir(dir)
      local mvnw = dirContainsMvnw(root)
      if string.len(mvnw) > 0 then
        vim.api.nvim_exec("TermExec dir=" .. root .. " cmd=\"./mvnw " .. exec .. "\"", true)
      else
        vim.api.nvim_exec("TermExec dir=" .. root .. " cmd=\"mvn " .. exec .. "\"", true)
      end
    end,
    { silent = true, buffer = true })

  vim.keymap.set("n", "<leader>b",
    function()
      writeall()
      -- echo 'exec:java -Dexec.mainClass='. package . '.'.filename .module
      local exec = "install -Dmaven.test.skip=true -P" .. "\\\\" .. "!cloud"
      local filePath = vim.fn.expand("%:p")
      local dir = vim.fn.fnamemodify(filePath, ":h")
      local root = getRootProjectDir(dir)
      local mvnw = dirContainsMvnw(root)
      if string.len(mvnw) > 0 then
        vim.api.nvim_exec("TermExec dir=" .. root .. " cmd=\"./mvnw " .. exec .. "\"", true)
      else
        vim.api.nvim_exec("TermExec dir=" .. root .. " cmd=\"mvn " .. exec .. "\"", true)
      end
    end,
    { silent = true, buffer = true })
end

api.nvim_create_autocmd(
  "FileType",
  { pattern = { "java", },
    callback = set_springboot_run_keymap }
)
api.nvim_create_autocmd(
  "FileType",
  { pattern = { "java", },
    callback = set_java_mvn_build_keymap }
)
api.nvim_create_autocmd(
  "FileType",
  { pattern = { "java", },
    callback = set_java_mvn_run_keymap }
)
-- windows to close with "q"
api.nvim_create_autocmd(
  "FileType",
  { pattern = { "help", "startuptime", "qf", "lspinfo", "git", "TelescopePrompt" },
    command = [[nnoremap <buffer><silent> q :close<CR>]] }
)
api.nvim_create_autocmd("FileType", { pattern = "man", command = [[nnoremap <buffer><silent> q :quit<CR>]] })

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- api.nvim_create_autocmd("BufNewFile", {pattern = "test_*.py" command = [[0r ~/.config/nvim/snippets/unittest.py] })
vim.cmd([[
function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

]])

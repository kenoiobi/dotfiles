local M = {}

M.categories = {
    python = {
        {
            name = "FastAPI",
            groups = {
                {
                    name = "Routes & App",
                    triggers = {
                        "faapp", "faappmin", "faget", "fapost", "faput", "fadelete", "fapatch",
                        "farouter", "fainclude", "facrud", "fafull",
                    },
                },
                {
                    name = "Schemas & Dependencies",
                    triggers = {
                        "faschema", "fascrud", "fadep", "fadepdb",
                    },
                },
                {
                    name = "Auth & Middleware",
                    triggers = {
                        "faauth", "famiddleware", "facors", "faexhandler",
                    },
                },
                {
                    name = "Background & WebSockets",
                    triggers = { "fabgtask", "faws" },
                },
                {
                    name = "Testing",
                    triggers = { "fatest", "fatestcrud" },
                },
            },
        },
        {
            name = "SQLAlchemy",
            groups = {
                {
                    name = "Setup",
                    triggers = { "sabase", "sabasesync", "samixin" },
                },
                {
                    name = "Models",
                    triggers = { "samodel", "samodelfull", "saenum", "saindex" },
                },
                {
                    name = "Relationships",
                    triggers = { "safk", "sao2m", "sam2m" },
                },
                {
                    name = "Queries & Migrations",
                    triggers = { "sacrud", "saquery", "sarevision" },
                },
            },
        },
        {
            name = "Django",
            groups = {
                {
                    name = "Models",
                    triggers = {
                        "dmodel", "dmodelfull", "dabstract", "dfk", "dm2m", "dchoices", "dmanager",
                    },
                },
                {
                    name = "Views",
                    triggers = {
                        "dlistview", "ddetailview", "dcreateview", "dupdateview", "ddeleteview",
                        "dcrudviews", "dcrudfbv", "dviewperm",
                    },
                },
                {
                    name = "REST Framework",
                    triggers = {
                        "dserializer", "dserializerfull", "dsermethod", "dviewset", "dapiview",
                        "drfcrud", "dpermission", "dfilter",
                    },
                },
                {
                    name = "Forms",
                    triggers = { "dform", "dformval" },
                },
                {
                    name = "Admin",
                    triggers = { "dadmin", "dadmininline" },
                },
                {
                    name = "URLs",
                    triggers = { "durlscrud", "durlsapi" },
                },
                {
                    name = "Signals, Commands & Tests",
                    triggers = {
                        "dsignal", "dcommand", "dmiddleware", "dtestcase", "dtestapi",
                        "dmigration", "dtask", "dapp",
                    },
                },
            },
        },
    },
    typescriptreact = {
        {
            name = "Next.js",
            groups = {
                {
                    name = "Pages",
                    triggers = {
                        "npage", "npageparams", "nlayout", "nlayoutroot", "nloading",
                        "nerror", "nnotfound", "nmetadata", "nstaticparams",
                    },
                },
                {
                    name = "Components",
                    triggers = { "nclient", "nprovider" },
                },
                {
                    name = "Forms",
                    triggers = { "nform", "nformclient" },
                },
                {
                    name = "Data Fetching",
                    triggers = { "nfetch", "nlist" },
                },
            },
        },
        {
            name = "shadcn/ui",
            groups = {
                {
                    name = "Forms",
                    triggers = { "shform", "shformfield", "shformselect", "shlogin" },
                },
                {
                    name = "Overlays",
                    triggers = { "shdialog", "shalertdialog", "shsheet" },
                },
                {
                    name = "Data Display",
                    triggers = { "shcard", "shtable", "shcolumns" },
                },
                {
                    name = "Navigation",
                    triggers = { "shdropdown", "shtabs", "shcommand" },
                },
                {
                    name = "Feedback",
                    triggers = { "shtoast" },
                },
            },
        },
        {
            name = "React Query",
            groups = {
                {
                    name = "All",
                    triggers = { "rqquery", "rqmutation", "rqinfinite", "rqprovider" },
                },
            },
        },
    },
    typescript = {
        {
            name = "Next.js",
            groups = {
                {
                    name = "API Routes",
                    triggers = { "nroute", "nrouteparams", "ncrudapi" },
                },
                {
                    name = "Server Actions",
                    triggers = { "naction", "nactioncrud" },
                },
                {
                    name = "Middleware & Config",
                    triggers = { "nmiddleware", "nschema", "nnextconfig" },
                },
            },
        },
        {
            name = "Zod",
            groups = {
                {
                    name = "All",
                    triggers = { "zenum", "zrefine", "zcoerce", "zextend" },
                },
            },
        },
    },
    htmldjango = {
        {
            name = "Django Templates",
            groups = {
                {
                    name = "Pages",
                    triggers = { "dtplbase", "dtpllist", "dtpldetail", "dtplform", "dtpldelete" },
                },
                {
                    name = "Blocks",
                    triggers = { "dpagination", "dmessages", "dfor", "dblock" },
                },
            },
        },
    },
}

local function collect_all_triggers(lib)
    local triggers = {}
    for _, group in ipairs(lib.groups) do
        for _, trig in ipairs(group.triggers) do
            triggers[trig] = true
        end
    end
    return triggers
end

function M.pick()
    local ls = require("luasnip")
    local MiniPick = require("mini.pick")
    local ft = vim.bo.filetype

    local all_snips = {}
    for _, s in ipairs(ls.get_snippets(ft) or {}) do all_snips[#all_snips + 1] = s end
    for _, s in ipairs(ls.get_snippets("all") or {}) do all_snips[#all_snips + 1] = s end

    if #all_snips == 0 then
        vim.notify("No snippets for filetype: " .. ft, vim.log.levels.INFO)
        return
    end

    local libs = M.categories[ft]
    if not libs then
        M._pick_from_list(all_snips, ft)
        return
    end

    -- collect all categorized triggers to find uncategorized ones
    local all_categorized = {}
    for _, lib in ipairs(libs) do
        for trig in pairs(collect_all_triggers(lib)) do
            all_categorized[trig] = true
        end
    end

    -- count uncategorized snippets
    local uncategorized = {}
    for _, snip in ipairs(all_snips) do
        if not all_categorized[snip.trigger] then
            uncategorized[#uncategorized + 1] = snip
        end
    end

    -- build library-level picker
    local lib_items = {}
    local lib_map = {}
    for _, lib in ipairs(libs) do
        local count = 0
        for _, group in ipairs(lib.groups) do
            for _, trig in ipairs(group.triggers) do
                for _, snip in ipairs(all_snips) do
                    if snip.trigger == trig then
                        count = count + 1
                        break
                    end
                end
            end
        end
        if count > 0 then
            local label = string.format("%-28s │ %d snippets", lib.name, count)
            lib_items[#lib_items + 1] = label
            lib_map[label] = lib
        end
    end

    if #uncategorized > 0 then
        local label = string.format("%-28s │ %d snippets", ft:sub(1, 1):upper() .. ft:sub(2) .. " (general)", #uncategorized)
        lib_items[#lib_items + 1] = label
        lib_map[label] = { name = "general", snippets = uncategorized }
    end

    local chosen_lib = MiniPick.start({
        source = {
            items = lib_items,
            name = "Library (" .. ft .. ")",
        },
    })

    if not chosen_lib or not lib_map[chosen_lib] then return end

    local lib = lib_map[chosen_lib]

    -- "general" goes straight to snippet list
    if lib.snippets then
        M._pick_from_list(lib.snippets, ft)
        return
    end

    -- build group-level picker within the library
    local group_items = {}
    local group_map = {}
    for _, group in ipairs(lib.groups) do
        local matched = {}
        local trig_set = {}
        for _, trig in ipairs(group.triggers) do trig_set[trig] = true end
        for _, snip in ipairs(all_snips) do
            if trig_set[snip.trigger] then
                matched[#matched + 1] = snip
            end
        end
        if #matched > 0 then
            local label = string.format("%-28s │ %d snippets", group.name, #matched)
            group_items[#group_items + 1] = label
            group_map[label] = matched
        end
    end

    if #group_items == 1 then
        M._pick_from_list(group_map[group_items[1]], ft)
        return
    end

    local chosen_group = MiniPick.start({
        source = {
            items = group_items,
            name = lib.name,
        },
    })

    if not chosen_group or not group_map[chosen_group] then return end

    M._pick_from_list(group_map[chosen_group], ft)
end

function M._pick_from_list(snips, ft)
    local ls = require("luasnip")
    local MiniPick = require("mini.pick")

    table.sort(snips, function(a, b) return a.trigger < b.trigger end)

    local items = {}
    for idx, snip in ipairs(snips) do
        local desc = snip.description
        if type(desc) == "table" then desc = table.concat(desc, " ") end
        items[idx] = string.format("%-20s │ %s", snip.trigger, desc or snip.name or "")
    end

    local find_idx = function(item)
        for idx, d in ipairs(items) do
            if d == item then return idx end
        end
    end

    local chosen = MiniPick.start({
        source = {
            items = items,
            name = "Snippets",
            preview = function(buf_id, item)
                local idx = find_idx(item)
                if not idx then return end
                local ok, docstring = pcall(snips[idx].get_docstring, snips[idx])
                if ok and docstring then
                    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, docstring)
                    vim.bo[buf_id].filetype = ft
                end
            end,
        },
    })

    if chosen then
        local idx = find_idx(chosen)
        if idx then
            vim.cmd("startinsert")
            ls.snip_expand(snips[idx])
        end
    end
end

return M

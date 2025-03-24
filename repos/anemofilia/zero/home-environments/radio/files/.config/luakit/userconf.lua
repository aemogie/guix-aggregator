-- Tabs: {{{
local settings = require "settings"
local lousy = require "lousy"
local modes = require "modes"

-- Tab number
lousy.widget.tab.label_format = "<span>{index}: </span>{title}"

-- Add ordering of new tabs
local taborder = require "taborder"

taborder.default = function(w)
	local order = taborder.after_current (w)
	return order
end
--}}}

-- Binds {{{
--[[ modes.remap_binds("normal", {
    { "<control-h>", "H", true },
    { "<control-l>", "L", true },
    { "<Mouse8>", "H", true },
    { "<Mouse9>", "L", true },
]]--})
modes.remove_binds("normal", {"d"})

modes.add_binds("normal", {
    {"dd", "Close current tab.",
    	function(w, m) 
	    for i=1,m.count do
	    	w:close_tab()
	    end
   	end,
	{count=1}},

    {"h", "Go back in the tab history.",
    	function (w, m)
	   w:back(m.count)
    	end,
	{count=1}},

    {"l", "Go forward in the tab history.",
    	function (w, m)
	   w:forward(m.count)
    	end,
	{count=1}},

    {"H", "Shift curent tab with the previous one.",  -- The default keybind for this was <Mod1-Page_Up>
          function (w, m)
	     w.tabs:reorder(w.view, w.tabs:current() - m.count)
	  end,
  	{count=1}},

     {"L", "Shift current tab with the next one.", -- The default keybind for this was <Mod1-Page_Down>
         function (w, m)
            w.tabs:reorder(w.view, (w.tabs:current() + m.count) % w.tabs:count())
         end,
 	{count=1}},

    {"<Mod1-h>", "Go to the previous tab.",
    	function (w, m)
	    w:prev_tab(m.count)
    	end,
	{count=1}},

    {"<Mod1-l>", "Go to the next tab.",
    	function (w, m)
	    w:next_tab(m.count)
    	end,
	{count=1}},

    {"y", "Hint all links (as defined by the follow.selectors.uri selector) and set the clipboard selection to the matched elements URI.",
        function(w)
            w:set_mode("follow", {
                prompt = "yank",
                selector = "uri",
                evaluator = "uri",
                func = function(uri)
                    assert(type(uri) == "string")
                    uri = uri:gsub(" ", "%%20"):gsub("^mailto:", "")
                    luakit.selection.clipboard = uri
                    w:notify("Yanked uri: " .. uri, false)
                end,
            })
        end},

    {"m", "Hint all links and open the video behind that link externally with MPV.",
        function(w)
            local video_cmd_fmt = "mpv '%s'"
            w:set_mode("follow", {
                prompt = "open with MPV",
                selector = "uri",
                evaluator = "uri",
                func = function(uri)
                    assert(type(uri) == "string")
                    luakit.spawn(string.format(video_cmd_fmt, uri))
                    w:notify("Launched MPV")
                end,
            })
        end},

    {"v", "Hint all links and open the image behind that link externally with feh.",
        function(w)
            local video_cmd_fmt = "feh %s'"
            w:set_mode("follow", {
                prompt = "open with feh",
                selector = "uri",
                evaluator = "uri",
                func = function(uri)
                    assert(type(uri) == "string")
                    luakit.spawn(string.format(video_cmd_fmt, uri))
                    w:notify("Launched feh")
                end,
            })
        end},

    {"<Control-c>", "Copy selected text.",
        function()
            luakit.selection.clipboard = luakit.selection.primary
        end},
})

local settings = require("settings")
settings.window.home_page = "file://" .. os.getenv("HOME") .. "/.config/luakit/homepage/index.html"

local select = require "select"
local follow = require "follow"

select.label_maker = function()
    local chars = charset("asdfghjkl")
    return trim(sort(reverse(chars)))
end

follow.pattern_maker = follow.pattern_styles.match_label
follow.ignore_delay = 0
	-- }}}

-- General configs {{{

-- Sets download dir
local downloads = require "downloads"
downloads.default_dir = os.getenv("HOME") .. "/Downloads"

-- Set search engines
local engines = settings.window.search_engines
settings.window.new_tab_page = "https://www.searx.work"

engines.default = engines.sx 
engines.at      = "https://alternativeto.net/browse/search/?q=%s"
engines.aw      = "https://wiki.archlinux.org/index.php?search=%s"
engines.cb      = "https://codeberg.org/explore/repos?tab=&sort=recentupdate&q=%s"
engines.gh      = "https://github.com/search?q=%s"
engines.gp      = "https://packages.gentoo.org/packages/search?q=%s"
engines.gw      = "https://wiki.gentoo.org/?search=%s"
engines.gz      = "https://gentoo.zugaina.org/Search?search=%s"
engines.inv     = "https://vid.puffyan.us/search?q=%s"
engines.ly      = "https://odysee.com/$/search?q=%s"
engines.lr      = "https://libreddit.tiekoetter.com/search?q=%s"
engines.ml      = "https://lista.mercadolivre.com.br/%s#D[A:%s]"
engines.olx     = "https://sp.olx.com.br/?q=%s"
engines.osm     = "https://www.openstreetmap.org/search?query=%s"
engines.sp      = "https://www.startpage.com/do/search?q=%s&segment=startpage.brave"
engines.tt      = "https://translate.tiekoetter.com/?engine=google&text=%s&sl=auto&tl=af"
engines.tw      = "https://www.thinkwiki.org/w/index.php?search=%s"
engines.use     = "https://unix.stackexchange.com/search?q=%s"
engines.w       = "https://wikiless.tiekoetter.com/w/index.php?search=%s"
engines.wb      = "http://wiby.me/?q=%s"
engines.we      = "https://wikieducator.org/index.php?search=%s"
engines.yt      = "https://yewtu.be/search?q=%s"

-- Set university restaurant menu
engines.cru     = "https://uspdigital.usp.br/rucard/Jsp/cardapioSAS.jsp?codrtn=6"

modes.add_binds("all", {
     {"xb", "Toggle statusbar",
	function(w)
        	w.bar_layout.visible = not w.bar_layout.visible
        end},
 
     {"xt", "Toggle tablist",
	 function(w)
 		 if settings.tablist.visibility == "never" then
		    settings.tablist.visibility = "multiple"
		 else
		    settings.tablist.visibility = "never"
                 end
	 end},

    {"xx", "Toggle statusbar and tablist",
	function(w)
		w.bar_layout.visible = not w.bar_layout.visible
		if settings.tablist.visibility == "never" then
		   settings.tablist.visibility = "multiple"
	   	else
		   settings.tablist.visibility = "never"
	        end
	 end},
 })


--}}}

-- Signals: {{{

-- Sets up notifications and link handling
local webview = require "webview"

local window = require("window")
window.add_signal("init", function(w)
    w.update_sbar_visibility_old = w.update_sbar_visibility
    w.update_sbar_visibility = function(w)
        w:update_sbar_visibility_old()
        if w.bar_layout.visible_child == w.sbar.ebox then
            w.bar_layout.visible = true
        end
    end
end)

webview.add_signal("init", function(view)
    view:add_signal("permission-request", function(v, type)
	if type == "notification" then
	return true
	end -- Might want to check v.uri too
    end)
end)

webview.add_signal("init", function (view)
    view:add_signal("navigation-request", function (v, uri)
        if string.match(string.lower(uri), "^magnet:") then
  			luakit.spawn(string.format("xdg-open \"%s\"", uri))
			return false
    	end
    end)
end)


-- vim fdm=marker
-- }}}

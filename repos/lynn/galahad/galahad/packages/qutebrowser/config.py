import os #start page
STARTPAGE = "https://smol.ch/~lynn/chinese"
DEFAULT_PAGE = STARTPAGE
SEARCH = "https://duckduckgo.com?q={}"

config.source('gruvbox.py')
c.fonts.hints = "28pt Iosevka"
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.policy.images = 'never'
config.load_autoconfig(False)
config.set('url.default_page', DEFAULT_PAGE)
config.set('url.start_pages', STARTPAGE)
config.set('url.searchengines', {'DEFAULT': SEARCH})
config.bind(",m", 'hint links spawn mpv --force-window=immediate {hint-url}')
config.bind
config.bind('<inv', 'open --tab https://inv.nadeko.net/')
config.bind(",inv", 'open https://inv.nadeko.net/')
config.bind("<bn", 'open --tab https://a.bloodyno.se')
config.bind(",bn", 'open https://a.bloodyno.se')
c.tabs.padding = {'top': 5, 'bottom': 5, 'left': 9, 'right': 9}
c.tabs.indicator.width = 0
config.set("content.cookies.store", True)

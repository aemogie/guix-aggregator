import os #start page
DARK_MODE = True
STARTPAGE = "file://" + os.path.expanduser("~/.config/qutebrowser/start.html")
DEFAULT_PAGE = STARTPAGE
SEARCH = "https://duckduckgo.com?q={}"
config.source('gruvbox.py')
config.set('colors.webpage.darkmode.enabled', DARK_MODE)
config.load_autoconfig(False)
config.set('url.default_page', DEFAULT_PAGE)
config.set('url.start_pages', STARTPAGE)
config.set('url.searchengines', {'DEFAULT': SEARCH})

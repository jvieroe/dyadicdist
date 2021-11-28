library(newsmd)

my_news <- newsmd::newsmd()

my_news$add_version("0.1.0")
my_news$add_subtitle("Package launch")
my_news$add_bullet(c("Launch of package", "Functionality includes single data input"))


my_news$add_version("0.2.0")
my_news$add_subtitle("Dual data inputs")
my_news$add_bullet(c("Added functionality: dual data input", "Bug fixes"))

my_news$add_version("0.2.1")
my_news$add_subtitle("Bug fixes")
my_news$add_bullet(c("Added functionality: dual data input", "Bug fixes"))

my_news$add_version("0.3.0")
my_news$add_subtitle("New input format for dual data functions")
my_news$add_bullet(c("Changed the input format to e.g. ids = c(...)"))


my_news$get_text()

my_news$write()

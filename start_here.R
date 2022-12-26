library(blogdown)
# how to make a new website
#new_site(theme = "mrmierzejewski/hugo-theme-console",
#         theme_example = TRUE)

# checking status of website
blogdown::check_site()
blogdown::serve_site()
# new post
new_post(title = "name of post",
         ext = '.Rmarkdown',
         subdir = "posts")
# checks
blogdown::check_content()
blogdown::check_netlify()
# update hugo
blogdown::install_hugo(force = TRUE, version = "latest")


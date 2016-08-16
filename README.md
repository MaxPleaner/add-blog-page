#### General idea

This is a web interface for adding pages to a project built with the [static](http://github.com/maxpleaner/static) framework

It displays a form for entering 'name', 'content' (markdown string), and 'tags'.

It then creates a markdown file with these specifications, compiles the source, and deploys the static result to github pages.

If cloning this repo, the [static](http://github.com/maxpleaner/static)

#### Where to start with the source code

There are a few important pieces:

1. [PagesController](./app/controllers/pages_controller.rb). Almost all custom code is in here.
2. the [populate_site](./lib/tasks/populate_site.rake) rake task, which will launch a repl and show its instructions.
It assists with getting data off RSS feeds and creates pages dynamically.
3. The git configuration of the repo. Make sure you change the git remote url to something you have access to, and that git
is configured to use ssh keys instead of prompting for username and password.

#### How to run it

```sh
#!/bin/bash
git clone http://github.com/maxpleaner/add-blog-page
cd add-blog-page
rm source/markdown/* # so you don't get all the content from my blog
bundle install # make sure postgres is set up and running first
rake db:create # there is no database storage in this app, but i haven't yet removed this step
git remote set-url origin git@github.com:<your_username>/<your_repo_name> # make sure you have git set up to use SSH keys
rails s
# then open localhost:3000 in the browser
```

Once a deploy happens (which is every time you submit the form), your static site will be visible
at `<your_username>.github.io/<your_repo_name>`

See the [static](http://github.com/maxpleaner/static) repo for more information on the underlying framework.
`add-blog-page` is a rails app which wraps it.

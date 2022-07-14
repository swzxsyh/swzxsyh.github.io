hexo d -g &&
hexo clean &&
git checkout hexo_source &&
git add . &&
git add ../oh-my-zsh && 
git commit -m 'backup' &&
git merge master &&
git push git@github.com:swzxsyh/swzxsyh.github.io.git hexo_source &&
git checkout master

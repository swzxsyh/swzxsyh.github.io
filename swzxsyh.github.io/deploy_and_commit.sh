hexo d -g &&
hexo clean &&
git checkout hexo_source &&
git merge master &&
git add . &&
git add git add ../oh-my-zsh/custom/plugins && 
git commit 'backup' &&
git push git@github.com:swzxsyh/swzxsyh.github.io.git hexo_source &&
git checkout master

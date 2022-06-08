alias dup="docker-compose up -d"
alias dstop="docker-compose stop"
alias ddown="docker-compose down"

alias dcbash="docker exec -it drupal8-vagrant_drupal_1 bash"
alias dbbash="docker exec -it drupal8-vagrant_db_1 bash"
alias dcra="docker exec -it drupal8-vagrant_drupal_1  /etc/init.d/apache2 reload"

dcpc() { docker exec -i $(docker ps -aqf "name=$1") composer create-project drupal-composer/drupal-project:8.x-dev /var/www/html/web/"$2" --stability dev --no-interaction; }

Database backup and restore in docker:-
# For Backup
  docker exec -i drupal8-vagrant_db_1 /usr/bin/mysqldump -u root --password=root DATABASE_NAME | gzip > backup.sql
  docker exec -i drupal8-vagrant_db_1 /usr/bin/mysqldump -u root --password=root DATABASE_NAME  > backup.sql

# To Restore
  cat backup.sql | docker exec -i drupal8-vagrant_db_1 /usr/bin/mysql -u root --password=root  db_name


export PS1='\[\e[01;32m\]\u\[\e[01;33m\]@\[\e[01;32m\]\h `if [ $? = 0 ]; then echo "\[\033[01;32m\]✔"; else echo "\[\033[01;31m\]✘"; fi` \[\e[01;34m\]\w\[\e[00m\]`[[ $(git status 2> /dev/null) =~ Changes\ to\ be\ committed: ]] && echo "\[\e[33m\]" || echo "\[\e[31m\]"``[[ ! $(git status 2> /dev/null) =~ nothing\ to\ commit,\ working\ .+\ clean ]] || echo "\[\e[32m\]"`$(__git_ps1 "(%s)\[\e[00m\]")\[\e[00;37m\]\$'


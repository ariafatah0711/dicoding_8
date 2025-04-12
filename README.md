## make 2 repo to 1 directory
```bash
## init repo
git init
...

## add repo
git remote add a433-microservices https://github.com/ariafatah0711/a433-microservices.git
git remote show

### show repo
git remote show a433-microservices
git fetch a433-microservices

### copy branch 1 and push to origin and other remote
git checkout -b karsajobs a433-microservices/karsajobs
git push -u origin karsajobs
git push -u a433-microservices karsajobs

### copy branch 2 and push to origin and other remote
git checkout -b karsajobs-ui a433-microservices/karsajobs-ui
git push -u origin karsajobs-ui
git push -u a433-microservices karsajobs-ui

## copy branch 1 to branch main directory
### cara 1
git checkout main
git checkout karsajobs -- sub2/karsaobs
git checkout karsajobs-ui -- sub2/karsaobs-ui
git checkout karsajobs-ui -- sub2/karsaobs-ui/README.md
### cara 2
git checkout main
git restore --source=karsajobs-ui path/to/directory
git restore --source=karsajobs path/to/directory
```
# Build the website
bundle exec jekyll build
pwd
# checkout the last published sites
cd _temp
# we may need to checkout the git repo for the new post
cd willemjiang.github.io
git pull
# copy the builded website
cp -R ../_site/* ./
git add *
git commit -m "Publish the website"
git push origin master

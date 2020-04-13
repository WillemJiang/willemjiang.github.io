# Build the website
JEKYLL_ENV=production bundle exec jekyll build
pwd
# checkout the last published sites
cd _temp
# we may need to checkout the git repo for the new post
cd willemjiang.github.io
echo "Pulling the content from master branch"
git pull
echo "Copying the builded website to master branch"
cp -R ../../_site/* ./
git add *
git commit -m "Publish the website"
echo "Pushing the updated site to master branch"
git push origin master

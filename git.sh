ng build --configuration production --base-href "https://github.com/akashkr101/portfolio"
npx angular-cli-ghpages --dir=dist/portfolio/browser
git add .
echo "Enter the commit message: "
read message
git commit -m "$message"
git status
git push
sleep 100s
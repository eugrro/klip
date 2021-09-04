#For making the colors refer to the working theme
file="$1"
# sed -i "s/Constants.backgroundBlack/Theme.of(context).scaffoldBackgroundColor/g" $file
# sed -i "s/Constants.purpleColor/Theme.of(context).textSelectionTheme.cursorColor/g" $file
# sed -i "s/Constants.backgroundWhite/Theme.of(context).textTheme.bodyText1.color/g" $file
# sed -i "s/Constants.hintColor/Theme.of(context).textTheme.bodyText2.color/g" $file
if [ $file != "bashUtil.sh" ]
then
    sed -i "s/Theme.of(context).scaffoldBackgroundColor/Constants.backgroundBlack/g" $file
    sed -i "s/Theme.of(context).textSelectionTheme.cursorColor/Constants.purpleColor/g" $file
    sed -i "s/Theme.of(context).textTheme.bodyText1.color/Constants.backgroundWhite/g" $file
    sed -i "s/Theme.of(context).textTheme.bodyText2.color/Constants.hintColor/g" $file
fi
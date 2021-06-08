#!/bin/bash

#For setting up the theme and replacing all colors with theme data
file="$1"
sed -i "s/Constants.purpleColor/Theme.of(context).textSelectionTheme.cursorColor/g" $file
sed -i "s/Constants.backgroundBlack/Theme.of(context).scaffoldBackgroundColor/g" $file
sed -i "s/Constants.backgroundWhite/Theme.of(context).textTheme.bodyText1.color/g" $file
sed -i "s/Constants.hintColor/Theme.of(context).textTheme.bodyText2.color/g" $file
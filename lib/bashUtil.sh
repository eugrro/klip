#!/bin/bash

#For setting up the theme and replacing all colors with theme data
file="$1"
sed -i "s/Theme.of(context).textSelectionTheme.cursorColor/Theme.of(context).textSelectionTheme.cursorColor/g" $file
sed -i "s/Theme.of(context).scaffoldBackgroundColor/Theme.of(context).scaffoldBackgroundColor/g" $file
sed -i "s/Theme.of(context).textTheme.bodyText1.color/Theme.of(context).textTheme.bodyText1.color/g" $file
sed -i "s/Theme.of(context).textTheme.bodyText2.color/Theme.of(context).textTheme.bodyText2.color/g" $file
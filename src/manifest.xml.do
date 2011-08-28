echo '<componentPackage>'
find . -name '*.as' -type f |
sed -E -e 's|\./||' \
       -e 's|/|.|g' \
       -e 's|^(.*)\.([^\.]+)\.as|   <component name="\2" class="\1.\2"/>|'
echo '</componentPackage>'

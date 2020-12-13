#  INSTALL

##### Install the tools from [requirements.txt](requirements.txt).

###### Run the following code (either type it in or use `bash INSTALL.md`),
 
    mkdir src tests data
    auk="http://raw.githubusercontent.com/timm/auk/master"
    all="auk.sh auk.awk src/happy.awk tests/happys.awk data/happy.csv"

    for f in $all
    do
      [ -f "$f" ] || curl -s $auk/$f -o $f
    done

    chmod +x auk.sh
    ./auk.sh -i

##### To get a demo  of the functionality
 
    cd tests
    ../auk.sh happier

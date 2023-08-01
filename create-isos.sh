# /bin/bash

rootuser () {
  if [[ "$EUID" = 0 ]]; then
    continue
  else
    echo "Please Run As Root"
    sleep 2
    exit
  fi
}

rootuser

echo "Cleaning up ISOs"
rm -rf out/
rm -rf Budgie/out
rm -rf XFCE/out

echo "Creating needed files"
mkdir -p out/

echo "Starting build for Budgie (Main Edition)"
cd Budgie/
./steps.sh
echo "Cleaning up Budgie (Main Edition) build files..."
rm -rf Budgie/work
rm -rf Budgie/ezreleng
mv Budgie/out/* out/
rm -rf Budgie/out

echo "Starting build for XFCE (Lite Edition)"
cd XFCE/
./steps.sh
echo "Cleaning up XFCE (Lite Edition) build files..."
rm -rf XFCE/work
rm -rf XFCE/ezreleng
mv XFCE/out/* out/
rm -rf XFCE/out

echo "Build finished! Check the out folder to see the ISOS!"
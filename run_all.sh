echo -n "Removing old frames... "
rm -rf tmp/frame_*.png
echo "done."

echo -n "Generating run data... "
ruby spark_diagram.rb > sd.csv
echo "done."

echo -n "Generating visualizations... "
Rscript visualize_frames.R > /dev/null
echo "done."

echo -n "Generating gif... "
convert -set delay 25 tmp/frame_* gif.gif
echo "done."

rm Rplots.pdf

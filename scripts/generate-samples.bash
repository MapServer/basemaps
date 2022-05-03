#!/usr/bin/env bash
# 26 dec 2016:
# MS cmd line call to generate images for each scale, each theme
#

MS_CMD=/Users/nicolas/bin/mapserver-7.0.1/bin/bin/shp2img
IMG_SIZE="800 600"
STYLES="
google
google-symbols
google-buildings-symbols
bing
bing-buildings-symbols
michelin
michelin-buildings-symbols
"

#centered on toulouse
XMIN="-232521"
YMIN="5107511"
XMAX="554108"
YMAX="5701276"

DIR=`pwd`

for style in ${STYLES}; do
    xmin=${XMIN}
    ymin=${YMIN}
    xmax=${XMAX}
    ymax=${YMAX}

    echo $style

    for zlevel in {6..18}; do
        oname="${style}-${zlevel}.png"

#        echo "${style}: z${zlevel} to ${oname} ext: ${XMIN} ${YMIN} ${XMAX} ${YMAX}"
#        echo "select 'box($xmin $ymin, $xmax $ymax)'::box2d::geometry union all"

        ${MS_CMD} -m ../osm-${style}.map -i png -o ${DIR}/${oname} \
            -e $xmin $ymin $xmax $ymax -s ${IMG_SIZE} -l default

        # divides extent: todo: smarter
        dw=$((xmax - xmin))
        dw=$((dw / 4))
        dh=$((ymax - ymin))
        dh=$((dh / 4))
        xmin=$((xmin + dw))
        xmax=$((xmax - dw))
        ymin=$((ymin + dh))
        ymax=$((ymax - dh))
    done
done

echo ""
echo "  sample generation done..."
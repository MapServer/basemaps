#!/usr/bin/env bash
# converts svg to png to test icons
# TODO: check why MS does not support some svg
# TODO: manage colors for svg
# takes png size from svg filename

DIR=""
ICON_SIZE=14
ICON_DECREMENT=2
#Prod: big quality, time consuming
DENSITY=20000
#Dev: more blury, fast to generate
#DENSITY=800
COLOR_BLACK="rgb(0,0,0)"
COLOR_BROWN="rgb(95,58,10)"
COLOR_VIOLET="rgb(153,30,156)"
COLOR_BLUE_PARK="rgb(15,125,209)"
COLOR_BLUE_BUS="rgb(0,121,214)"
COLOR_PINK_MED="rgb(214,0,130)"

COLOR=${COLOR_BLACK}

for file in `find ../symbols -d 1 -type f -name "*.svg"`; do
    #echo ${file}
    name=`basename "$file" .svg`.png
    # extract size from name
    ICON_SIZE=`echo $file | egrep -o "[0-9]+"`

    if [[ -z "$ICON_SIZE" ]]; then
        ICON_SIZE=14
    else
        ICON_SIZE=$((${ICON_SIZE}-${ICON_DECREMENT}))
    fi

    # custom colors
    if [[ $name =~ ^shop_.*$ ]]; then
        COLOR=${COLOR_VIOLET}
    elif [[ $name =~ park|hostel|hotel|motel ]]; then
        COLOR=${COLOR_BLUE_PARK}
    elif [[ $name =~ shintoist|christian|hinduist|muslim|taoist|buddhist|jewish|traffic_light|place_of_worship|sikhist ]]; then
        COLOR=${COLOR_BLACK}
    elif [[ $name =~ rental|bus|water_tower|taxi|charging_station|fuel|fountain ]]; then
        COLOR=${COLOR_BLUE_BUS}
    elif [[ $name =~ hospital|pharmacy ]]; then
        COLOR=${COLOR_PINK_MED}
    # brown symbols from list...
    elif [[ $name =~ cafe|car_wash|courthouse|level_crossing|night_club|waste_basket|telephone|saddle|police|picnic|drinking_water|artwork|archeological|atm|bench|biergarten|camping|communication|dentist|doctors|embassy|firestation|helipad|hunting_stand|information|lift_gate|light_house|theatre|restaurant|pub|fast_food|cinema|bar|monument|recycling|toilets|viewpoint|museum|playground|post_office|post_box|tourist_memorial|town_hall|windmill|prison|power_wind|peak ]]; then
        COLOR=${COLOR_BROWN}
        echo "${name} brown"
    else
        COLOR=${COLOR_VIOLET}
    fi

    # custom sizes
    if [[ "$name" == "parking.png" ]]; then
        ICON_SIZE=10
    fi

    echo "convert to PNG: ${name}, size: ${ICON_SIZE}, color: ${COLOR}"
    convert -fill "${COLOR}" -background none -density ${DENSITY} -resize ${ICON_SIZE}x${ICON_SIZE}  ${file} ../symbols/png/${name}
    # forces color as convert does not work all the time:
    # TODO: find why


done

#manual cmd:
#convert xc:skyblue -fill "rgb(255,34,77)" -background none -density 1200 -resize 16x16  ../symbols/computer-14.svg ../symbols/png/computer-14.png
#convert -fill "rgb(255,34,77)" -background none -density 1200 -resize 16x16  ../symbols/png/toto.png ../symbols/png/totoc.png
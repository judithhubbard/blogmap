#!/usr/bin/env bash
# GeoJSON creator that creates a GeoJSON file of map region LineStrings with associated URLs


# Arguments: 
# 1 = file containing URLs and tectoplot region commands

if [[ ! -s $1 ]]; then
    echo "Error: input file $1 is empty or does not exist"
    exit
fi

echo "{\"type\": \"FeatureCollection\", \"features\":[" > blogregions.geojson
firstcat=""

while read p; do
    if [[ ${p:0:1} != "#" && ! -z ${p[0]} ]]; then
        unset title
        s=($(echo $p))
        id=${s[0]}
        s[0]=""

        # If we haven't already created the file, then create it using tectoplot
        # if [[ ! -s blogregion.${id}.geojson ]]; then

            echo "Building GeoJSON for ID ${id}"

            url=${s[1]}
            s[1]=""

            ind=1
            while [[ ${s[ind]} != "#" ]]; do
                if [[ -z ${title} ]]; then
                    title=${s[ind]}
                else
                    title="${title} ${s[ind]}"
                fi
                s[ind]=""
                ((ind++))
            done
            s[$ind]=""
            ((ind++))
            indp=$(echo "$ind+1" | bc)

            # echo calling tectoplot ${s[@]}, title is ${title[@]}

            # tectoplot ${s[@]}

            # if [[ -s tempfiles_to_delete/mapelements/bounds.txt ]]; then
            echo -n "{\"type\":\"Feature\",\"geometry\":{\"type\":\"LineString\",\"coordinates\":[" > blogregion.${id}.geojson
            comma=""
            while [[ ! -z ${s[$ind]} ]]; do
                echo -n "${comma}[${s[$ind]},${s[$indp]}]" >> blogregion.${id}.geojson
                comma=","
                ((ind+=2))
                ((indp+=2))
            done


            #     if [[ -s tempfiles_to_delete/clip_poly_1.txt ]]; then
            #          cat tempfiles_to_delete/clip_poly_1.txt | tr '\n' '$' | sed 's/0 x/\n\>/g' | gawk ' 
            #             {
            #                 data[NR]=$0; 
            #                 fnum[NR]=NF; 
            #                 maxfields=(NF>maxfields)?NF:maxfields 
            #             } 
            #             END { 
            #                 for (key in data) { 
            #                     if (fnum[key]==maxfields) {
            #                         print data[key]
            #                         exit
            #                     } 
            #                 }
            #             }' | tr '$' '\n' | gawk '($1+0==$1) { print }' > biggest_clip.txt

            #             numpts=$(wc -l < biggest_clip.txt | gawk '{print $1}')

            #             if [[ $(echo "$numpts > 200" | bc -l) -eq 1 ]]; then
            #                 gawk < biggest_clip.txt -v numpts=${numpts} '
            #                 BEGIN {
            #                     everyn=int((numpts)/100)
            #                 }
            #                 (NR % everyn == 0) {
            #                     print
            #                 }' > biggest_clip_subsample.txt
            #             fi

            #     else
            #         gawk < tempfiles_to_delete/mapelements/bounds.txt '
            #             BEGIN {
            #                 printedone=""
            #             }
            #             ($1+0==$1) {
            #                 printf("%s[%s,%s]", printedone, $1, $2);
            #                 printedone=","
            #             }' >> blogregion.${id}.geojson
            #     fi


            echo "]},\"properties\":{\"id\":\"${id}\",\"url\":\"${url}\",\"title\":\"${title[@]}\",\"lastupdated\":\"$(date -u +"%FT%T")\"}}" >> blogregion.${id}.geojson
            # fi

        # else
        #     # Concatenate existing GeoJSON file into the master file
        #     echo "Not rebuilding region #${id} - to rebuild, delete file blogregion.${id}.geojson"
        # fi
        echo -n "${firstcat}" >> blogregions.geojson
        cat blogregion.${id}.geojson >> blogregions.geojson
        firstcat=","

    fi
done < $1

echo "]}" >> blogregions.geojson

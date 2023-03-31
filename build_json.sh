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
    if [[ ${p:0:1} != "#" ]]; then
        unset title
        s=($(echo $p))
        id=${s[0]}
        s[0]=""

        # If we haven't already created the file, then create it using tectoplot
        if [[ ! -s blogregion.${id}.geojson ]]; then

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

            echo calling tectoplot ${s[@]}, title is ${title[@]}

            tectoplot ${s[@]}

            if [[ -s tempfiles_to_delete/mapelements/bounds.txt ]]; then
                echo -n "{\"type\":\"Feature\",\"geometry\":{\"type\":\"LineString\",\"coordinates\":[" > blogregion.${id}.geojson
                gawk < tempfiles_to_delete/mapelements/bounds.txt '
                    BEGIN {
                        printedone=""
                    }
                    ($1+0==$1) {
                        printf("%s[%s,%s]", printedone, $1, $2);
                        printedone=","
                    }' >> blogregion.${id}.geojson
                echo "]},\"properties\":{\"id\":\"${id}\",\"url\":\"${url}\",\"title\":\"${title[@]}\",\"lastupdated\":\"$(date -u +"%FT%T")\"}}" >> blogregion.${id}.geojson
            fi
        else
            # Concatenate existing GeoJSON file into the master file
            echo "Not rebuilding region #${id} - to rebuild, delete file blogregion.${id}.geojson"
        fi
        echo -n "${firstcat}" >> blogregions.geojson
        cat blogregion.${id}.geojson >> blogregions.geojson
        firstcat=","

    fi
done < $1

echo "]}" >> blogregions.geojson



# {"type":"Feature","geometry":{"type":"LineString","coordinates":[
#     [
#         [-84.9345402,38.6621374],[-84.9323702,38.6665632],[-84.9254354,38.6734239],[-84.9212922,38.67044],[-84.9115737,38.6686764],[-84.904953,38.6698329],[-84.9052685,38.6769345],[-84.9041383,38.6785046],[-84.8953335,38.6788199],[-84.8916463,38.6763208],[-84.8899941,38.6763672],[-84.8881448,38.6781359],[-84.8881063,38.6873534],[-84.8850067,38.6878739],[-84.8814662,38.6849533],[-84.8731895,38.6889256],[-84.8708444,38.6920948],[-84.8705461,38.6984018],[-84.8683646,38.7000283],[-84.8588057,38.7007597],[-84.858245,38.6993256],[-84.8552351,38.6978917],[-84.8452568,38.6965731],[-84.8431914,38.6985399],[-84.8406998,38.7051884],[-84.8359507,38.7080653],[-84.8348304,38.7113421],[-84.8332481,38.7120383],[-84.8302168,38.7113292],[-84.8252288,38.7071231],[-84.8250231,38.7057905],[-84.821454,38.7038633],[-84.8118498,38.7023142],[-84.8101775,38.7048286],[-84.8163323,38.707732],[-84.8131187,38.7119833],[-84.808348,38.7123356],[-84.8068886,38.7142138],[-84.7996171,38.7155145],[-84.7960314,38.7193032],[-84.7962198,38.7215192],[-84.7940812,38.7245108],[-84.7879576,38.7238547],[-84.7857923,38.720466],[-84.7743271,38.6186017],[-84.6809635,38.5597579],[-84.6745096,38.5579491],[-84.6746163,38.5547303],[-84.6784818,38.555843],[-84.6775333,38.5534997],[-84.6793002,38.5512865],[-84.6750324,38.5480619],[-84.6751565,38.5461539],[-84.6678243,38.5455395],[-84.665421,38.5437258],[-84.6693108,38.5407667],[-84.6664691,38.5358624],[-84.6716109,38.5370056],[-84.6716986,38.5341326],[-84.6745786,38.5320408],[-84.671639,38.5305773],[-84.670585,38.5266587],[-84.6678198,38.5282036],[-84.6672709,38.5316387],[-84.6636881,38.5310136],[-84.6617938,38.5328587],[-84.6577564,38.5328279],[-84.6569747,38.5320236],[-84.6581617,38.5290874],[-84.6530199,38.5275248],[-84.652956,38.5261855],[-84.6554779,38.5238705],[-84.6516612,38.5233664],[-84.6491763,38.5207751],[-84.6447581,38.5203085],[-84.6485822,38.518443],[-84.6500554,38.5153014],[-84.6458787,38.5133205],[-84.6422916,38.513861],[-84.6420082,38.5100667],[-84.6437385,38.5084208],[-84.6363368,38.5032123],[-84.6335678,38.495029],[-84.6284413,38.4914025],[-84.6266557,38.4851396],[-84.6213728,38.481753],[-84.6180345,38.4809736],[-84.6119313,38.4813038],[-84.6101841,38.4824534],[-84.6055564,38.4805745],[-84.6007734,38.4810357],[-84.5805436,38.4730459],[-84.6235903,38.4311948],[-84.6494647,38.4165748],[-84.7059925,38.370109],[-84.7405984,38.3524219],[-84.7462305,38.3494887],[-84.7931811,38.3385278],[-84.796726,38.3402302],[-84.8033914,38.346834],[-84.8046753,38.3466506],[-84.8087665,38.3493133],[-84.8143878,38.3498693],[-84.8157398,38.3480291],[-84.8184558,38.3477999],[-84.8221538,38.3496036],[-84.8240934,38.3483102],[-84.8271461,38.348196],[-84.8276934,38.349594],[-84.8320451,38.350742],[-84.8328599,38.3529425],[-84.834611,38.3531861],[-84.8384233,38.356933],[-84.8490205,38.3546455],[-84.8541599,38.3551767],[-84.8579952,38.3571163],[-84.8704868,38.3567586],[-84.8682101,38.3585961],[-84.8669565,38.3638037],[-84.8674247,38.3670696],[-84.870048,38.3702534],[-84.879266,38.3736058],[-84.8943734,38.3753155],[-84.8986532,38.3789739],[-84.8971698,38.3906034],[-84.8890198,38.4011075],[-84.8863766,38.4082144],[-84.8802531,38.4161869],[-84.8802628,38.4190566],[-84.8958363,38.4248611],[-84.9120189,38.4282952],[-84.9164291,38.4308066],[-84.9247196,38.4311838],[-84.9279447,38.4345207],[-84.9273594,38.4390793],[-84.9250276,38.4418311],[-84.9138459,38.4468722],[-84.9092923,38.4502472],[-84.9091117,38.4532082],[-84.9122347,38.4598511],[-84.9148787,38.4618311],[-84.9233302,38.4645086],[-84.9289902,38.4620002],[-84.935128,38.4566884],[-84.9381937,38.450421],[-84.9375353,38.4318242],[-84.9392572,38.4278041],[-84.9442989,38.4263027],[-84.9498401,38.4261878],[-84.9570452,38.4299042],[-84.96327,38.4373656],[-84.9569909,38.4452674],[-84.9555786,38.4513878],[-84.951583,38.457874],[-84.9521514,38.4650161],[-84.9545773,38.4709645],[-84.9568465,38.4736537],[-84.965735,38.4793503],[-84.9787637,38.4848109],[-84.9887545,38.4870956],[-84.9921112,38.4912265],[-84.9907972,38.4983494],[-84.9771706,38.5129965],[-84.9780931,38.5153414],[-84.9811608,38.5177647],[-84.9850302,38.5184124],[-85.0004843,38.5170555],[-85.0071777,38.5139301],[-85.0192496,38.5039252],[-85.0264976,38.5053048],[-85.0285827,38.5066644],[-85.02972,38.5093507],[-85.0296824,38.5122879],[-85.0252995,38.5234552],[-85.0134545,38.5388304],[-85.0123082,38.547817],[-85.0035541,38.5514481],[-85.0023217,38.553648],[-85.0107471,38.5621898],[-85.0186576,38.5645048],[-85.0409177,38.5741694],[-85.0530849,38.5688628],[-85.0595487,38.5647528],[-85.0637685,38.5649262],[-85.0703266,38.5707159],[-85.0759344,38.5780258],[-85.0745873,38.5968453],[-85.0716852,38.5962439],[-85.0680946,38.5936972],[-85.0667796,38.5941942],[-85.0666639,38.5974089],[-85.0637703,38.5996501],[-85.0678151,38.6022895],[-85.0684916,38.6042333],[-85.0627269,38.6071794],[-85.0593722,38.611309],[-85.0524413,38.611852],[-85.0473828,38.6149169],[-85.0452654,38.6143764],[-85.0437287,38.6115034],[-85.0403643,38.6105415],[-85.0247276,38.6137663],[-85.0210958,38.6201701],[-85.0144748,38.6214542],[-85.0124222,38.6231679],[-85.012678,38.625222],[-85.0168239,38.6287432],[-85.0157921,38.6321457],[-85.0111466,38.6319859],[-85.0032019,38.6342153],[-84.9912558,38.6308214],[-84.9860107,38.6327765],[-84.9820218,38.6371051],[-84.9759703,38.6356353],[-84.9689087,38.6451859],[-84.9703856,38.6468966],[-84.9698932,38.64874],[-84.9638929,38.650753],[-84.9602931,38.6507628],[-84.9573396,38.6536668],[-84.9548648,38.6532631],[-84.9511759,38.6489274],[-84.9450507,38.6506174],[-84.9369685,38.6508357],[-84.9376349,38.6549879],[-84.9342285,38.6599469],[-84.9345402,38.6621374]
#     ]]}  ,"properties":{ "FIPS_NO":187,"POP80":8924,"CH90_00":16.7349,"CHSQ00_10":2.787801,"SEAT":"Owenton","POP00":10547,"MILES_SQ":354.222383,"ADDNAME":"NORTHERN KENTUCKY","CHSQ80_90":1.2435,"CHSQ90_00":16.7349,"SMIS":94,"POP90":9035,"POP90SQ":25.5065,"OBJECTID":1,"POP80SQ":25.1932,"CH70_80":19.4645,"FIPS_ID":21187,"POP00SQ":29.775,"NAME2":"Owen","SEAT2":"OWENTON","POP10":10841,"SP_ZONE":"NORTH","POP70SQ":21.0884,"POP70":7470,"CH00_10":2.787523,"CHSQ70_80":19.4647,"NAME":"OWEN","REGION":"NORTHERN KENTUCKY REGION","CH80_90":1.2438,"POP10SQ":30.605068,"FIPS_TXT":"187"}}
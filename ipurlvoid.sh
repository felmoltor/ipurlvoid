# =========================
# ===== DESCRIPTION =======
# =========================
# = @author: Felipe Molina (@felmoltor)
# = @creation_date: 04/2014
# = @License: GPLv3
# =========================

OUTPUTDIR="results"
HTMLDIR="$OUTPUTDIR/html"

# Check arguments
if [ ! $1 ]; then
	echo "usage: $0 <ip>"
	echo "usage: $0 <textfile>"
	exit
fi

# check OS and use the Windows or Linux commands
SO=`uname -a`
isWindows=0
if [[ "$SO" == *CYGWIN_NT* ]]
then
    isWindows=1
else
    isWindows=0
fi

# Save the result file name
resultfile="$1-result.csv"

# ==========================
# ======= FUNCTIONS ========
# ==========================


function isValidIP()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

# =======================

function request {
		
	target=$1
    nlbk=0
    blacklisted=0
	echo -n "$target;" >> $OUTPUTDIR/$resultfile

    isValidIP $target
    valid_ip=$?
    if [[ $valid_ip == 0 ]];then
        echo "This is an IP, asking to ipvoid.com"
        curl -s -L -o $HTMLDIR/$target.ipvoid.html -k --data "ip=$target" http://www.ipvoid.com 
        # Dos opciones para la salida
        # <tr><td>Blacklist Status</td><td><span class="label label-danger">BLACKLISTED 6/37</span></td></tr>
        # <tr><td>Blacklist Status</td><td><span class="label label-success">POSSIBLY SAFE 0/37</span></td></tr>
        blacklisted=$(grep -o -E "<span class=\"label label-danger\">BLACKLISTED [[:digit:]]+\/[[:digit:]]+</span>" $HTMLDIR/$target.ipvoid.html | wc -l)
        nblk=$(grep -o -E "<span class=\"label label-danger\">BLACKLISTED [[:digit:]]+\/[[:digit:]]+</span>" $HTMLDIR/$target.ipvoid.html | grep -o -E "[[:digit:]]+\/[[:digit:]]+")
    else
        echo "This is not an IP, asking to urlvoid.com"
        curl -s -L -o $HTMLDIR/$target.urlvoid.html -k --data "url=$target&go=" http://www.urlvoid.com
        # <span class="label label-success">0/25</span></td></tr>
        # <span class="label label-danger">.*</span></td></tr>
        blacklisted=$(grep -o -E "<span class=\"label label-danger\">.*</span>" $HTMLDIR/$target.urlvoid.html | wc -l)
        nblk=$(grep -o -E "<span class=\"label label-danger\">.*</span>" $HTMLDIR/$target.urlvoid.html | grep -o -E "[[:digit:]]+\/[[:digit:]]+")
    fi

    # Check if blacklisted
    if [[ $blacklisted = 1 ]];then
        echo
        echo -e "\033[31m [BLACKLISTED] \033[0m $nblk detected this IP/URL as a threat." 
        echo "BLACKLISTED ($nblk)" >> $OUTPUTDIR/$resultfile
    else
        echo
        echo -e "\033[32m [PROBABLY CLEAN] \033[0m It seems this IP/URL is not a threat."
        echo "PROBABLY CLEAN" >> $OUTPUTDIR/$resultfile
    fi
}

# ==========================
# ========= MAIN ===========
# ==========================

# Create temporal results folder
if [[ ! -d $OUTPUTDIR ]];then
	echo "Creating $OUTPUTDIR to store result files"
	mkdir $OUTPUTDIR
fi
if [[ ! -d $HTMLDIR ]];then
    echo "Creating $HTMLDIR to store temporal html files"
    mkdir $HTMLDIR
fi

echo "IP/URL;Status" > $OUTPUTDIR/$resultfile

if [ -f "$1" ] ; then
	LIST=$(cat "$1")
	((i=1))
	while ((i=i)); do
		KEYWORD=$(echo $LIST | cut -d ' ' -f$i)
		
		if [ ! $KEYWORD ]; then
			break;
		fi
		echo "Asking to ipvoid.com for '$KEYWORD'. Please, wait..."
		request $KEYWORD
		echo  
		((i++))
	done
else
	KEYWORD=$1
	echo "Asking to ipvoid.com for '$KEYWORD'. Please, wait..."
	request $KEYWORD	
	echo
fi


if [[ $isWindows -eq 1 ]]
then
    # Es un Sistema Operativo Windows con Cygwin
    # Abrimos con explorer
	echo "Abrimos $OUTPUTDIR\\$resultfile"
    explorer "$OUTPUTDIR\\$resultfile"
else
    # Es un Sistema Operativo Linux
    # Display result using w3m
    if [ -f /usr/bin/w3m ]; then
        w3m $OUTPUTDIR/$resultfile 2> /dev/null
    else
        if [ -f /usr/bin/firefox ]; then
            firefox $OUTPUTDIR/$resultfile 2> /dev/null
            else
            if [ -f /usr/bin/google-chrome ]; then
                google-chrome $OUTPUTDIR/$resultfile 2> /dev/null
                else
                echo -e "No se encuentra un navegador web instalado.\nAbre el fichero $resultfile con un navegador para ver los resultados"
            fi
        fi
    fi
fi



# =========================
# ===== DESCRIPTION =======
# =========================
# = @author: Felipe Molina (@felmoltor)
# = @creation_date: 04/2014
# = @License: GPLv3
# =========================

# TODO: If we detect an URL, transform also to and IP and check also with ipvoid.com
# TODO: If we detect an IP, do a reverse lookup and also check with urlvoid.com
# TODO: If we detect subdomains, split in multiple domains and check with urlvoid.com. For example: if we have news.local.paper.es, analyce paper.es, local.paper.es and news.local.paper.es
# TODO: Add queries to urlquery.net API. 

OUTPUTDIR="results"
HTMLDIR="$OUTPUTDIR/html"
CHECKRELATEDIPS=1

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

function toIPList()
{
    local domain=$1
    local iplist=$(dig +short $domain a)
    
    echo $iplist
}

# ====================

function queryIP()
{
    local ip=$1
    local nblk=0

    curl -s -L -o $HTMLDIR/$ip.ipvoid.html -k --data "ip=$ip" http://www.ipvoid.com 
    # Dos opciones para la salida
    # <tr><td>Blacklist Status</td><td><span class="label label-danger">BLACKLISTED 6/37</span></td></tr>
    # <tr><td>Blacklist Status</td><td><span class="label label-success">POSSIBLY SAFE 0/37</span></td></tr>
    blacklisted=$(grep -o -E "<span class=\"label label-danger\">BLACKLISTED [[:digit:]]+\/[[:digit:]]+</span>" $HTMLDIR/$ip.ipvoid.html | wc -l)
    if  [[ $blacklisted != 0 ]];then
        nblk=$(grep -o -E "<span class=\"label label-danger\">BLACKLISTED [[:digit:]]+\/[[:digit:]]+</span>" $HTMLDIR/$ip.ipvoid.html | grep -o -E "[[:digit:]]+\/[[:digit:]]+")
    fi

    echo "$ip:$blacklisted:$nblk"
}

# ======================

function queryDomain()
{
    local domain=$1
    local nblk=0

    curl -s -L -o $HTMLDIR/$target.urlvoid.html -k --data "url=$target&go=" http://www.urlvoid.com
    # <span class="label label-success">0/25</span></td></tr>
    # <span class="label label-danger">.*</span></td></tr>
    blacklisted=$(grep -o -E "<span class=\"label label-danger\">.*</span>" $HTMLDIR/$target.urlvoid.html | wc -l)
    if [[ $blacklisted != 0 ]];then
        nblk=$(grep -o -E "<span class=\"label label-danger\">.*</span>" $HTMLDIR/$target.urlvoid.html | grep -o -E "[[:digit:]]+\/[[:digit:]]+")
    fi

    echo "$domain:$blacklisted:$nblk"
}

# =======================

function printHostStatus()
{
    local status=$1
    local target=$( echo $status | cut -f1 -d: )
    local blacklisted=$( echo $status | cut -f2 -d:)
    local nblk=$( echo $status | cut -f3 -d:)
    local type=$2
    local url=""

    if [[ $type == "ip" ]];then
        url="http://www.ipvoid.com/scan/$target"
    else
        url="http://www.urlvoid.com/scan/$target"
    fi

    # Check if blacklisted
    if [[ $blacklisted = 1 ]];then
        echo -e "$target:\033[31m [BLACKLISTED] \033[0m ($nblk detected this IP/URL as a threat, $url)" 
        echo "$target;BLACKLISTED ($nblk)" >> $OUTPUTDIR/$resultfile
    else
        echo -e "$target:\033[32m [PROBABLY CLEAN] \033[0m (It seems this IP/URL is not a threat, $url)"
        echo "$target;PROBABLY CLEAN" >> $OUTPUTDIR/$resultfile
    fi
}

# =======================

function request {
		
	local target=$1
	local status="$1:0:0"
  
    echo 
    isValidIP $target
    valid_ip=$?
    if [[ $valid_ip == 0 ]];then
        echo "Inspecting IP address $target..."
        status=$( queryIP $target "ip" )
        printHostStatus $status
    else
        echo "Ispecting domain $target"
        status=$( queryDomain $target "domain" )
        printHostStatus $status
        if [[ $CHECKRELATEDIPS == 1 ]];then
            iplist=$( toIPList $target )
            for relatedip in $iplist; do
                echo "Inspecting related IP address(es) of domain $target: $relatedip..."
                status=$( queryIP $relatedip "ip" )
                printHostStatus $status
            done
        fi
    fi
    
}

# ==========================

function getSystemEditor()
{
    local editors="vim emacs nano pico leafpad jed gedit tea gvim kate"
    local firstpath=""

    ed=$( echo $EDITOR )
    if [[ "$ed" != "" ]];then
        paths=$( whereis $ed | cut -f2 -d:)
        firstpath=$( echo $paths | cut -f1 -d' ' )
    else
        for editor in $editors; do
            paths=$( whereis $editor | cut -f2 -d:)
            firstpath=$( echo $paths | cut -f1 -d' ' )
            if [[ "$firstpath" != "" ]];then
                break
            fi
        done
    fi

    echo $firstpath
}

# ==========================

function getSystemBrowser()
{
    local browsers="firefox chromium chrome google-chrome iceweasel lynx w3m"
    local firstpath=""

    for browser in $browsers; do
        paths=$( whereis $browser | cut -f2 -d:)
        firstpath=$( echo $paths | cut -f1 -d' ' )
        if [[ "$firstpath" != "" ]];then
            break
        fi
    done
    echo $firstpath
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
		request $KEYWORD
		echo  
		((i++))
	done
else
	KEYWORD=$1
	request $KEYWORD	
	echo
fi


if [[ $isWindows -eq 1 ]]
then
    # Es un Sistema Operativo Windows con Cygwin
    # Abrimos con explorer
    echo "Opening $OUTPUTDIR\\$resultfile"
    explorer "$OUTPUTDIR\\$resultfile"
else
    # Es un Sistema Operativo Linux
    editor=$( getSystemEditor )
    if [[ -f $editor ]];then
        $editor $OUTPUTDIR/$resultfile 2> /dev/null
    else
        echo -e "No se encuentra un navegador web instalado.\nAbre el fichero $resultfile con un navegador para ver los resultados"
    fi
#    brw=$( getSystemBrowser )
#    if [[ -f $brw ]];then
#        $brw $HTMLDIR/$resultfile 2> /dev/null
#    else
#        echo -e "No se encuentra un navegador web instalado.\nAbre el fichero $resultfile con un navegador para ver los resultados"
#    fi
fi



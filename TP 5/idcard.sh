nom_machine=$(hostnamectl | head -n 1 | cut -d ' ' -f4)
nom_os=$(cat /etc/os-release | head -n 1 | cut -d '"' -f2)
version_kernel=$(uname -r)
ip=$(hostname -I | tr -s ' ' | cut -d ' ' -f1)
free_ram=$(free | head -n 2 | tail -n 1 | tr -s ' ' | cut -d ' ' -f4)
total_ram=$(free | head -n 2 | tail -n 1 | tr -s ' ' | cut -d ' ' -f2)
disk_space=$(df | sed -n "5p" | tr -s ' ' | cut -d ' ' -f4)
task=$(ps -auxh --sort=-%mem | head -n 5 | tr -s ' ' | cut -d ' ' -f11 | rev |  cut -d '/' -f1 | rev | sed 's/^/- /')
cat=$(curl -s https://api.thecatapi.com/v1/images/search | cut -d ',' -f2 |cut -d '"' -f4)
echo "Machine name :" $nom_machine
echo "OS :" $nom_os "and kernel version is" $version_kernel
echo "IP :" $ip
echo "RAM :" $free_ram "memory available on" $total_ram "total memory"
echo "Disk :" $disk_space "space left"
echo "Top 5 processes by RAM usage :"
echo $task
echo "Listening ports :"
test=$(ss -alputne4H)
while read super_line; do
    port_type=$(echo $super_line | tr -s ' ' | cut -d ' ' -f1)
    port=$(echo $super_line | tr -s ' ' | cut -d ' ' -f5 | cut -d ':' -f2)
    service=$(echo $super_line | tr -s ' ' | cut -d ' ' -f9 | cut -d '/' -f3 | cut -d '.' -f1)
    echo " -" $port $port_type ":" $service
done <<< $test 
echo "PATH directories :"
echo $PATH
echo "Here is your random cat (jpg file) :" $cat
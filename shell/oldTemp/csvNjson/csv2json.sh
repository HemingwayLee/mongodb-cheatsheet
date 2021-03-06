input=$1
 
[ -z $1 ] && echo "No CSV input file specified" && exit 1
[ ! -e $input ] && echo "Unable to locate $1" && exit 1
 
read first_line < $input
a=0
headings=`echo $first_line | awk -F, {'print NF'}`
lines=`cat $input | wc -l`
while [ $a -lt $headings ]
do
  head_array[$a]=$(echo $first_line | awk -v x=$(($a + 1)) -F"," '{print $x}')
  a=$(($a+1))
done
 
c=0
echo "["
while [ $c -lt $lines ]
do
  read each_line
  if [ $c -ne 0 ]; then
    d=0
    echo -n "{"
    while [ $d -lt $headings ]
    do
      each_element=$(echo $each_line | awk -v y=$(($d + 1)) -F"," '{print $y}')
      if [ $d -ne $(($headings-1)) ]; then
        if echo $each_element | egrep -q '^[0-9.]+$'; then
          echo "\"${head_array[$d]}\":$each_element,"
        else
          echo "\"${head_array[$d]}\":\"$each_element\","
        fi
      else
        if echo $each_element | egrep -q '^[0-9.]+$'; then
          echo "\"${head_array[$d]}\":$each_element"
        else
          echo "\"${head_array[$d]}\":\"$each_element\""
        fi
      fi
      d=$(($d+1))
    done
    if [ $c -eq $(($lines-1)) ]; then
      echo "}"
    else
      echo "},"
    fi
  fi
  c=$(($c+1))
done < $input
echo "]"
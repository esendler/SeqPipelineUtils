a=`head -n 1 names.txt`
cd counts
cut -f 1 "$a".cnts >counts.txt
for i in ` cat ../names.txt`
do
	cut -f 2 "$i".cnts >tmp1
	cp counts.txt tmp2
	paste tmp2 tmp1 >counts.txt
done
# add header
# add header
echo "Genes" >tmp1.txt
`cat ../names.txt >tmp2.txt`
cat tmp1.txt tmp2.txt|paste -s -d '\t' >tmp3.txt
cp counts.txt tmp1.txt
cat tmp3.txt tmp1.txt >counts.txt
rm tmp1.txt
rm tmp2.txt
rm tmp3.txt
rm tmp1
rm tmp2


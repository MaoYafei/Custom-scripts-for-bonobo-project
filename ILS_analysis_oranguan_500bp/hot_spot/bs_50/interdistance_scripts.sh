# Requires two inputs: input bed file (full file name), and distance thresjold (integer)

mybed=$1
dist_threshold=$2

echo "Using interdistance threshold $dist_threshold bp"

# The bedtools script below assumes the input bed file that is passed to this script contains 4 columns: chr, start, end, id

# First define clustered and distant regions for the q chromosome arms
bedtools closest -a <(bedtools intersect -wa -a $mybed -b q_arm.bed | bedtools sort -i -) -b <(bedtools intersect -wa -a $mybed -b q_arm.bed | bedtools sort -i -) -k 2 -d -t first | awk -v dist=$dist_threshold '($9 < dist && $9 > 0){print $1,$2,$3,$4,$5,$6,$7,$8,$9}' | sed 's/ /\t/g' > $mybed.q_arm.clustered

echo "Wrote q-arm clustered bed (1/6)"

bedtools closest -a <(bedtools intersect -wa -a $mybed -b q_arm.bed | bedtools sort -i -) -b <(bedtools intersect -wa -a $mybed -b q_arm.bed | bedtools sort -i -) -k 2 -d -t first | awk -v dist=$dist_threshold '($9 >= dist){print $1,$2,$3,$4,$5,$6,$7,$8,$9}' | sed 's/ /\t/g' > $mybed.q_arm.distant

echo "Wrote q-arm distant bed (2/6)"

# Second create clustered and distant regions for the p chromosome arms
bedtools closest -a <(bedtools intersect -wa -a $mybed -b p_arm.bed | bedtools sort -i -) -b <(bedtools intersect -wa -a $mybed -b p_arm.bed | bedtools sort -i -) -k 2 -d -t first | awk -v dist=$dist_threshold '($9 < dist && $9 > 0){print $1,$2,$3,$4,$5,$6,$7,$8,$9}' | sed 's/ /\t/g' > $mybed.p_arm.clustered

echo "Wrote p-arm clustered bed (3/6)"

bedtools closest -a <(bedtools intersect -wa -a $mybed -b p_arm.bed | bedtools sort -i -) -b <(bedtools intersect -wa -a $mybed -b p_arm.bed | bedtools sort -i -) -k 2 -d -t first | awk -v dist=$dist_threshold '($9 >= dist){print $1,$2,$3,$4,$5,$6,$7,$8,$9}' | sed 's/ /\t/g' > $mybed.p_arm.distant

echo "Wrote p-arm distant bed (4/6)"


# Lastly, create two separate output files: 
cat  $mybed.p_arm.clustered > $mybed.clustered
cat  $mybed.q_arm.clustered >> $mybed.clustered

cat  $mybed.p_arm.distant > $mybed.distant
cat  $mybed.q_arm.distant >> $mybed.distant

echo "Wrote two final output files (5/6)"

# Remore intermediate files
rm $mybed.p_arm.clustered
rm $mybed.q_arm.clustered
rm $mybed.p_arm.distant
rm $mybed.q_arm.distant

echo "Cleaned-up & DONE! (6/6)"

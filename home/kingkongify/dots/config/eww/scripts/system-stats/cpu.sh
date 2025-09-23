#!/usr/bin/env bash
set -euo pipefail

read -r _ u1 n1 s1 i1 w1 q1 sq1 st1 g1 gn1 < /proc/stat
idle1=$(( i1 + w1 ))
total1=$(( u1 + n1 + s1 + i1 + w1 + q1 + sq1 + st1 ))
sleep 0.5
read -r _ u2 n2 s2 i2 w2 q2 sq2 st2 g2 gn2 < /proc/stat
idle2=$(( i2 + w2 ))
total2=$(( u2 + n2 + s2 + i2 + w2 + q2 + sq2 + st2 ))

diff_idle=$(( idle2 - idle1 ))
diff_total=$(( total2 - total1 ))
diff_used=$(( diff_total - diff_idle ))

if (( diff_total <= 0 )); then
  echo -n 0
  exit
fi

echo -n $(( 100 * diff_used / diff_total ))

#!/bin/bash

file=commonwordfinder.cpp

if [ ! -f "$file" ]; then
    echo -e "Error: File '$file' not found.\nTest failed."
    exit 1
fi

num_right=0
total=0
line="________________________________________________________________________"
compiler=
interpreter=
language=
extension=${file##*.}
if [ "$extension" = "py" ]; then
    if [ ! -z "$PYTHON_PATH" ]; then
        interpreter=$(which python.exe)
    else
        interpreter=$(which python3.2)
    fi
    command="$interpreter $file"
    echo -e "Testing $file\n"
elif [ "$extension" = "java" ]; then
    language="java"
    command="java ${file%.java}"
    echo -n "Compiling $file..."
    javac $file
    echo -e "done\n"
elif [ "$extension" = "c" ] || [ "$extension" = "cpp" ]; then
    language="c"
    command="./${file%.*}"
    echo -n "Compiling $file..."
    results=$(make 2>&1)
    if [ $? -ne 0 ]; then
        echo -e "\n$results"
        exit 1
    fi
    echo -e "done\n"
fi

run_test_args() {
    (( ++total ))
    echo -n "Running test $total..."
    expected=$2
    received=$( $command $1 2>&1 | tr -d '\r' )
    if [ "$expected" = "$received" ]; then
        echo "success"
        (( ++num_right ))
    else
        echo -e "failure\n\nExpected$line\n$expected\nReceived$line\n$received\n"
    fi
}

run_test_args "" "Usage: ./commonwordfinder <filename> [limit]"
run_test_args "notfound.txt" "Error: Cannot open file 'notfound.txt' for input."

(cat << EOF
This is a short sentence.
EOF
) > test.txt
run_test_args "test.txt dx" "Error: Invalid limit 'dx' received."
run_test_args "test.txt -1" "Error: Invalid limit '-1' received."
run_test_args "test.txt 2" "Total unique words: 5"$'\n'"1. a  1"$'\n'"2. is 1"
run_test_args "test.txt 20" "Total unique words: 5"$'\n'"1. a        1"$'\n'"2. is       1"$'\n'"3. sentence 1"$'\n'"4. short    1"$'\n'"5. this     1"

(cat << EOF
The widow she cried over me, and called me a poor lost lamb, and she
called me a lot of other names, too, but she never meant no harm by
it. She put me in them new clothes again, and I couldn't do nothing but
sweat and sweat, and feel all cramped up.  Well, then, the old thing
commenced again.  The widow rung a bell for supper, and you had to come
to time. When you got to the table you couldn't go right to eating, but
you had to wait for the widow to tuck down her head and grumble a little
over the victuals, though there warn't really anything the matter with
them, that is, nothing only everything was cooked by itself.  In a
barrel of odds and ends it is different; things get mixed up, and the
juice kind of swaps around, and the things go better.
EOF
) > test.txt
run_test_args "test.txt 20" "Total unique words: 93"$'\n'" 1. and      10"$'\n'" 2. the      9"$'\n'" 3. to       6"$'\n'" 4. a        5"$'\n'" 5. me       4"$'\n'" 6. she      4"$'\n'" 7. you      4"$'\n'" 8. but      3"$'\n'" 9. of       3"$'\n'"10. widow    3"$'\n'"11. again    2"$'\n'"12. by       2"$'\n'"13. called   2"$'\n'"14. couldn't 2"$'\n'"15. for      2"$'\n'"16. go       2"$'\n'"17. had      2"$'\n'"18. in       2"$'\n'"19. is       2"$'\n'"20. it       2"
run_test_args "test.txt 99" "Total unique words: 93"$'\n'" 1. and        10"$'\n'" 2. the        9"$'\n'" 3. to         6"$'\n'" 4. a          5"$'\n'" 5. me         4"$'\n'" 6. she        4"$'\n'" 7. you        4"$'\n'" 8. but        3"$'\n'" 9. of         3"$'\n'"10. widow      3"$'\n'"11. again      2"$'\n'"12. by         2"$'\n'"13. called     2"$'\n'"14. couldn't   2"$'\n'"15. for        2"$'\n'"16. go         2"$'\n'"17. had        2"$'\n'"18. in         2"$'\n'"19. is         2"$'\n'"20. it         2"$'\n'"21. nothing    2"$'\n'"22. over       2"$'\n'"23. sweat      2"$'\n'"24. them       2"$'\n'"25. things     2"$'\n'"26. up         2"$'\n'"27. all        1"$'\n'"28. anything   1"$'\n'"29. around     1"$'\n'"30. barrel     1"$'\n'"31. bell       1"$'\n'"32. better     1"$'\n'"33. clothes    1"$'\n'"34. come       1"$'\n'"35. commenced  1"$'\n'"36. cooked     1"$'\n'"37. cramped    1"$'\n'"38. cried      1"$'\n'"39. different  1"$'\n'"40. do         1"$'\n'"41. down       1"$'\n'"42. eating     1"$'\n'"43. ends       1"$'\n'"44. everything 1"$'\n'"45. feel       1"$'\n'"46. get        1"$'\n'"47. got        1"$'\n'"48. grumble    1"$'\n'"49. harm       1"$'\n'"50. head       1"$'\n'"51. her        1"$'\n'"52. i          1"$'\n'"53. itself     1"$'\n'"54. juice      1"$'\n'"55. kind       1"$'\n'"56. lamb       1"$'\n'"57. little     1"$'\n'"58. lost       1"$'\n'"59. lot        1"$'\n'"60. matter     1"$'\n'"61. meant      1"$'\n'"62. mixed      1"$'\n'"63. names      1"$'\n'"64. never      1"$'\n'"65. new        1"$'\n'"66. no         1"$'\n'"67. odds       1"$'\n'"68. old        1"$'\n'"69. only       1"$'\n'"70. other      1"$'\n'"71. poor       1"$'\n'"72. put        1"$'\n'"73. really     1"$'\n'"74. right      1"$'\n'"75. rung       1"$'\n'"76. supper     1"$'\n'"77. swaps      1"$'\n'"78. table      1"$'\n'"79. that       1"$'\n'"80. then       1"$'\n'"81. there      1"$'\n'"82. thing      1"$'\n'"83. though     1"$'\n'"84. time       1"$'\n'"85. too        1"$'\n'"86. tuck       1"$'\n'"87. victuals   1"$'\n'"88. wait       1"$'\n'"89. warn't     1"$'\n'"90. was        1"$'\n'"91. well       1"$'\n'"92. when       1"$'\n'"93. with       1"

(cat << EOF
The number of souls in this kingdom being usually reckoned one million
and a half, of these I calculate there may be about two hundred thousand
couple whose wives are breeders; from which number I subtract thirty
thousand couple, who are able to maintain their own children, (although
I apprehend there cannot be so many, under the present distresses of
the kingdom) but this being granted, there will remain an hundred and
seventy thousand breeders. I again subtract fifty thousand, for those
women who miscarry, or whose children die by accident or disease within
the year. There only remain an hundred and twenty thousand children of
poor parents annually born. The question therefore is, How this number
shall be reared, and provided for? which, as I have already said, under
the present situation of affairs, is utterly impossible by all the
methods hitherto proposed. For we can neither employ them in handicraft
or agriculture; we neither build houses, (I mean in the country) nor
cultivate land: they can very seldom pick up a livelihood by stealing
till they arrive at six years old; except where they are of towardly
parts, although I confess they learn the rudiments much earlier;
during which time they can however be properly looked upon only as
probationers: As I have been informed by a principal gentleman in the
county of Cavan, who protested to me, that he never knew above one or
two instances under the age of six, even in a part of the kingdom so
renowned for the quickest proficiency in that art.
EOF
) > test.txt
run_test_args "test.txt" "Total unique words: 157"$'\n'" 1. the      13"$'\n'" 2. of       9"$'\n'" 3. i        8"$'\n'" 4. in       6"$'\n'" 5. they     5"$'\n'" 6. thousand 5"$'\n'" 7. a        4"$'\n'" 8. and      4"$'\n'" 9. be       4"$'\n'"10. by       4"
run_test_args "test.txt 200" "Total unique words: 157"$'\n'"  1. the          13"$'\n'"  2. of           9"$'\n'"  3. i            8"$'\n'"  4. in           6"$'\n'"  5. they         5"$'\n'"  6. thousand     5"$'\n'"  7. a            4"$'\n'"  8. and          4"$'\n'"  9. be           4"$'\n'" 10. by           4"$'\n'" 11. for          4"$'\n'" 12. or           4"$'\n'" 13. there        4"$'\n'" 14. are          3"$'\n'" 15. as           3"$'\n'" 16. can          3"$'\n'" 17. children     3"$'\n'" 18. hundred      3"$'\n'" 19. kingdom      3"$'\n'" 20. number       3"$'\n'" 21. this         3"$'\n'" 22. under        3"$'\n'" 23. which        3"$'\n'" 24. who          3"$'\n'" 25. although     2"$'\n'" 26. an           2"$'\n'" 27. being        2"$'\n'" 28. breeders     2"$'\n'" 29. couple       2"$'\n'" 30. have         2"$'\n'" 31. is           2"$'\n'" 32. neither      2"$'\n'" 33. one          2"$'\n'" 34. only         2"$'\n'" 35. present      2"$'\n'" 36. remain       2"$'\n'" 37. six          2"$'\n'" 38. so           2"$'\n'" 39. subtract     2"$'\n'" 40. that         2"$'\n'" 41. to           2"$'\n'" 42. two          2"$'\n'" 43. we           2"$'\n'" 44. whose        2"$'\n'" 45. able         1"$'\n'" 46. about        1"$'\n'" 47. above        1"$'\n'" 48. accident     1"$'\n'" 49. affairs      1"$'\n'" 50. again        1"$'\n'" 51. age          1"$'\n'" 52. agriculture  1"$'\n'" 53. all          1"$'\n'" 54. already      1"$'\n'" 55. annually     1"$'\n'" 56. apprehend    1"$'\n'" 57. arrive       1"$'\n'" 58. art          1"$'\n'" 59. at           1"$'\n'" 60. been         1"$'\n'" 61. born         1"$'\n'" 62. build        1"$'\n'" 63. but          1"$'\n'" 64. calculate    1"$'\n'" 65. cannot       1"$'\n'" 66. cavan        1"$'\n'" 67. confess      1"$'\n'" 68. country      1"$'\n'" 69. county       1"$'\n'" 70. cultivate    1"$'\n'" 71. die          1"$'\n'" 72. disease      1"$'\n'" 73. distresses   1"$'\n'" 74. during       1"$'\n'" 75. earlier      1"$'\n'" 76. employ       1"$'\n'" 77. even         1"$'\n'" 78. except       1"$'\n'" 79. fifty        1"$'\n'" 80. from         1"$'\n'" 81. gentleman    1"$'\n'" 82. granted      1"$'\n'" 83. half         1"$'\n'" 84. handicraft   1"$'\n'" 85. he           1"$'\n'" 86. hitherto     1"$'\n'" 87. houses       1"$'\n'" 88. how          1"$'\n'" 89. however      1"$'\n'" 90. impossible   1"$'\n'" 91. informed     1"$'\n'" 92. instances    1"$'\n'" 93. knew         1"$'\n'" 94. land         1"$'\n'" 95. learn        1"$'\n'" 96. livelihood   1"$'\n'" 97. looked       1"$'\n'" 98. maintain     1"$'\n'" 99. many         1"$'\n'"100. may          1"$'\n'"101. me           1"$'\n'"102. mean         1"$'\n'"103. methods      1"$'\n'"104. million      1"$'\n'"105. miscarry     1"$'\n'"106. much         1"$'\n'"107. never        1"$'\n'"108. nor          1"$'\n'"109. old          1"$'\n'"110. own          1"$'\n'"111. parents      1"$'\n'"112. part         1"$'\n'"113. parts        1"$'\n'"114. pick         1"$'\n'"115. poor         1"$'\n'"116. principal    1"$'\n'"117. probationers 1"$'\n'"118. proficiency  1"$'\n'"119. properly     1"$'\n'"120. proposed     1"$'\n'"121. protested    1"$'\n'"122. provided     1"$'\n'"123. question     1"$'\n'"124. quickest     1"$'\n'"125. reared       1"$'\n'"126. reckoned     1"$'\n'"127. renowned     1"$'\n'"128. rudiments    1"$'\n'"129. said         1"$'\n'"130. seldom       1"$'\n'"131. seventy      1"$'\n'"132. shall        1"$'\n'"133. situation    1"$'\n'"134. souls        1"$'\n'"135. stealing     1"$'\n'"136. their        1"$'\n'"137. them         1"$'\n'"138. therefore    1"$'\n'"139. these        1"$'\n'"140. thirty       1"$'\n'"141. those        1"$'\n'"142. till         1"$'\n'"143. time         1"$'\n'"144. towardly     1"$'\n'"145. twenty       1"$'\n'"146. up           1"$'\n'"147. upon         1"$'\n'"148. usually      1"$'\n'"149. utterly      1"$'\n'"150. very         1"$'\n'"151. where        1"$'\n'"152. will         1"$'\n'"153. within       1"$'\n'"154. wives        1"$'\n'"155. women        1"$'\n'"156. year         1"$'\n'"157. years        1"

rm -f test.txt

echo -e "\nTotal tests run: $total"
echo -e "Number correct : $num_right"
echo -n "Percent correct: "
echo "scale=2; 100 * $num_right / $total" | bc

if [ "$language" = "java" ]; then
    echo -e -n "\nRemoving class files..."
    rm -f *.class
    echo "done"
elif [ "$language" = "c" ]; then
    echo -e -n "\nCleaning project..."
    make clean > /dev/null 2>&1
    echo "done"
fi

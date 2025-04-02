/compiling|compiled/ {print "\033[34m" $0 "\033[0m"; next}
/WARNING/ {print "\033[33m" $0 "\033[0m"; next}
/Entering test group|Leaving test group/ {print "\033[36m" $0 "\033[0m"; next}
/PASS/ {print "\033[32m" $0 "\033[0m"; next}
/# of expected passes/ {print "\033[36m" $0 "\033[0m"; next}
/FAIL/ {print "\033[31m" $0 "\033[0m"; next}
{print $0}

@echo An error occured at %1
@echo Last file: %2
@echo Error file: %3
@echo Build abandoned
perl \source\bin\errmail.pl %1 %2 %3
rem exit

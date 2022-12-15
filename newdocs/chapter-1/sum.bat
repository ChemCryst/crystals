echo on
call index about
call index install
call index gettingstarted
call index examples
copy about.lis+install.lis+gettingstarted.lis+examples.lis chapter-1.lis
del about.lis install.lis gettingstarted.lis examples.lis


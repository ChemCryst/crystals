Summary: CRYSTALS X-ray structure refinement and analysis.
Name: crystals
Version: 12.50
Release: beta
Group: Scientific
Copyright: Copyright University of Oxford 2004
URL: http://www.xtl.ox.ac.uk/crystals.html
Packager: Richard I Cooper
Buildroot: %_topdir/%{name}
BuildArch: i386

%description
RPM to install CRYSTALS. CRYSTALS is a suite of software
for the refinement and analysis of X-ray or neutron data collected
from single or twinned small-molecule crystal structures.

%files
%defattr(-,root,root)
/usr/local/crystals
/usr/local/bin/crystals

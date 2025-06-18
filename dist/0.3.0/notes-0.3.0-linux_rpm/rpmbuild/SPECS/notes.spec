Name: notes
Version: 0.3.0
Release: 1%{?dist}
Summary: Simple note taking app
Group: Utility
Vendor: MD Kawsar amin
Packager: MD Kawsar amin <kawsar101amin@gmail.com>
License: GPLv3
URL: https://github.com/kawsaramin101/noteit
BuildArch: x86_64

%description
A new Flutter project.

%install
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/%{name}
mkdir -p %{buildroot}%{_datadir}/applications
mkdir -p %{buildroot}%{_datadir}/metainfo
mkdir -p %{buildroot}%{_datadir}/pixmaps
cp -r %{name}/* %{buildroot}%{_datadir}/%{name}
ln -s %{_datadir}/%{name}/%{name} %{buildroot}%{_bindir}/%{name}
cp -r %{name}.desktop %{buildroot}%{_datadir}/applications
cp -r %{name}.png %{buildroot}%{_datadir}/pixmaps
cp -r %{name}*.xml %{buildroot}%{_datadir}/metainfo || :
update-mime-database %{_datadir}/mime &> /dev/null || :

%postun
update-mime-database %{_datadir}/mime &> /dev/null || :

%files
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/metainfo


%defattr(-,root,root)

%attr(4755, root, root) %{_datadir}/pixmaps/%{name}.png

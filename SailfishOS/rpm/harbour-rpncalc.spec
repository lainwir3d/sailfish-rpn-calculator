# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.27
# 

Name:       harbour-rpncalc

# >> macros
%define __provides_exclude_from ^%{_datadir}/.*$
%define __requires_exclude ^libc|libdl|libm|libpthread|libpython3.4m|python|env|libutil.*$
# << macros

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    A RPN Calculator for Sailfish
Version:    2.3
Release:    1
Group:      Qt/Qt
License:    GPL
URL:        https://github.com/lainwir3d/sailfish-rpn-calculator
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-rpncalc.yaml
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   pyotherside-qml-plugin-python3-qt5 >= 1.3.0
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils
BuildRequires:  python3-base
BuildRequires:  python3-devel

%description
Full symbolic RPN calculator. Read http://en.wikipedia.org/wiki/Reverse_Polish_notation if you want to know more about RPN calculators.

%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qtc_qmake5 

%qtc_make %{?_smp_mflags}

# >> build post
cp -r /home/mersdk/share/projects/sailfish-rpn-calc/common/python_modules_src %qtc_builddir/
cd python_modules_src/

tar xvf fastcache-1.0.2.tar.gz
cd fastcache-1.0.2
python3 setup.py build
cd ..

#tar xvf numpy-1.9.2.tar.gz
#cd numpy-1.9.2
#python3 setup.py build
#cd ..

tar xvf sympy-0.7.6.1.tar.gz
cd sympy-0.7.6.1
python3 setup.py build
cd ..

tar xvf mpmath-0.19.tar.gz
cd mpmath-0.19
python3 setup.py build
cd ..

tar xvf pyparsing-2.0.3.tar.gz
cd pyparsing-2.0.3
python3 setup.py build
cd ..

tar xvf dice-1.0.2.tar.gz
cd dice-1.0.2
python3 setup.py build
cd ..

cd ..
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
cd python_modules_src/

cd fastcache-1.0.2
python3 setup.py install --root=%{buildroot} --prefix=%{_datadir}/%{name}/
cd ..

#cd numpy-1.9.2
#python3 setup.py install --root=%{buildroot} --prefix=%{_datadir}/%{name}/
#cd ..

cd sympy-0.7.6.1
python3 setup.py install --root=%{buildroot} --prefix=%{_datadir}/%{name}/
cd ..

cd pyparsing-2.0.3
python3 setup.py install --root=%{buildroot} --prefix=%{_datadir}/%{name}/
cd ..

cd mpmath-0.19
python3 setup.py install --root=%{buildroot} --prefix=%{_datadir}/%{name}/
cd ..

cd dice-1.0.2
python3 setup.py install --root=%{buildroot} --prefix=%{_datadir}/%{name}/
cd ..

rm -rf %{buildroot}/%{_datadir}/%{name}/share
rm -rf %{buildroot}/%{_datadir}/%{name}/bin

cd ..

cp /usr/lib/libpython3.4m.so.1.0 %{buildroot}/%{_datadir}/%{name}/lib/
cp /lib/libutil.so.1 %{buildroot}/%{_datadir}/%{name}/lib/libutil.so.1
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_datadir}/icons/hicolor/86x86/apps/%{name}.png
%{_datadir}/icons/hicolor/108x108/apps/%{name}.png
%{_datadir}/icons/hicolor/128x128/apps/%{name}.png
%{_datadir}/icons/hicolor/256x256/apps/%{name}.png
%{_datadir}/applications/%{name}.desktop
%{_datadir}/%{name}
%{_bindir}
# >> files
# << files
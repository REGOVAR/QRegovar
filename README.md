# QRegovar


[![Build status](https://ci.appveyor.com/api/projects/status/275xv8xawf4hn199?svg=true)](https://ci.appveyor.com/project/ikit/qregovar) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/ec9575b135cb4479ac10866799b00e63)](https://www.codacy.com/app/olivier_6/QRegovar?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=REGOVAR/QRegovar&amp;utm_campaign=Badge_Grade) [![Documentation Status](https://readthedocs.org/projects/qregovar/badge/?version=latest)](https://readthedocs.org/projects/qregovar/) [![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/labsquare/Regovar)

The official heavy client (in Qt) of the Regovar project

Implementation of [beta](https://github.com/REGOVAR/QRegovar/milestone/1) in progress (75%)

![mokcup](https://raw.githubusercontent.com/REGOVAR/QRegovar/781c155b1a0d640f757ea5677d223f3d9e347ab7/docs/mockup/mockup.gif)

# How to build

## Windows

We need only Qt 5.10.1.

Download the open source package on the [Qt web site](https://www.qt.io/download). Follow instruction to install it (next, next, next). 

QtCreator ask to configure the project. Accept the default parameters.

Then open the `app/QRegovar.pro` with QtCreator and press `ctrl + R` to build and run QRegovar.

## On Ubuntu 16.04 LTS (Xenial)

You first need a few Qt 5.10 packages that are not yet distributed through the official Ubuntu repositories (note that by doing so, you are trusting [Stephan Binner](https://launchpad.net/~beineri) who is kindly providing compiled packages that are not provided upstream):

```sh
sudo add-apt-repository ppa:beineri/opt-qt-5.10.1-xenial
sudo apt update
sudo apt install qt510creator qt510charts-no-lgpl qt510graphicaleffects qt510quickcontrols2 qt510websockets
```

Then, source a Qt 5.10 environment and use QtCreator to compile QRegovar:

```sh
source /opt/qt510/bin/qt510-env.sh
qtcreator
```
QtCreator asks to configure the project. Accept the default parameters.

Open the `app/QRegovar.pro` file, and press `ctrl + R` to build and run QRegovar.

## On Ubuntu 18.04 LTS (Bionic)

Download the dependencies:

```sh
sudo apt install qt5-qmake qml-module-qtcharts qml-module-qtgraphicaleffects qml-module-qtquick-controls2 qml-module-qtwebsockets
```

Compile:

```sh
cd app
qmake
make
```

Run QRegovar:

```sh
./QRegovar
```

## On ArchLinux

Download the dependencies:

```sh
sudo pacman -S qmake qt5-quickcontrols2 qt5-charts qt5-graphicaleffects qt5-websockets
```

Compile:

```sh
cd app
qmake
make
```

Run QRegovar:

```sh
./QRegovar
```

# Documentation

You will find on this repository only the technical doc for developpers. The user guide and tutorials are on the [Regovar git repository](https://github.com/REGOVAR/Regovar/tree/master/docs) -> [Official ReadTheDoc](http://regovar.readthedocs.io/fr/latest/)

# Credits

Thanks for their help:

 * [Fontastic](http://app.fontastic.me/)
 * [Freepik](https://www.flaticon.com/)
 * [Inkscape](https://inkscape.org/en/)

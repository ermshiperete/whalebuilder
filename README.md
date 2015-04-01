Whalebuilder
============

Whalebuilder is a tool for building Debian packages in a minimal environment.
It is inspired by pbuilder, but uses Docker to manage the build environment.

One advantage of using Whalebuilder is that it creates a Docker image with all
the build dependencies for your package installed, allowing you to quickly
rebuild if needed.  Whalebuilder will also build your package with networking
disabled, to ensure that your build process does not inadvertently rely on any
external resources.

Usage
-----

To use Whalebuilder, you must first create a base image by using
"`whalebuilder create`".  For example,

    $ whalebuilder create whalebuilder/debian:stable

will create a Docker image named `whalebuilder/debian:stable` that will contain
a Debian stable build environment, and

    $ whalebuilder create -r unstable whalebuilder/debian:sid

will create a Docker image named `whalebuilder/debian:sid` what will contain a
Debian unstable build environment.  Note that for all Whalebuilder commands,
you must have `sudo` access to Docker.

After creating an image, you can build a package using "`whalebuilder build`".
For example,

    $ whalebuilder build whalebuilder/debian:sid foo_0.1-1.dsc

will build the source package described in foo_0.1-1.dsc.  The resulting
packages will be saved by default in `~/.local/share/whalebuilder/foo_0.1-1`.
Note that the results will not be owned by your user, although you can still
read it.  However, to delete the results, you will need to use `sudo`.

After you have built a package in this way, there will be a Docker image named
`whalebuilder_build/<pkgname>:<pkgversion>`,
e.g. `whalebuilder_build/foo:0.1-1`.  You can use this to rebuild the package
without needing to reinstall the build dependencies.  For example,

    $ whalebuilder build --no-install-depends whalebuilder_build/foo:0.1-1 foo_0.1-1.dsc

License
-------
Copyright (C) 2015 Hubert Chathi <hubert@uhoreg.ca>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

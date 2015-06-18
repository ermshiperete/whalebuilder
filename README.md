Whalebuilder
============

Whalebuilder is a tool for building Debian packages in a minimal environment.
It is inspired by pbuilder, but uses Docker to manage the build environment.

Whalebuilder builds packages:

* with only `build-essential` and the package's build dependencies installed;
* as a non-priviledged user;
* with networking disabled, to ensure that the build process does not
  inadvertently rely on any external resources; and
* without any system daemons running (this may cause problems with some
  packages, but should be fine for the majority of packages).

In addition, Whalebuilder will print a warning if it detects that the build has
made any changes to the filesystem outside of the build directory.

Usage
-----

To build a package, use the command "`whalebuilder build`".
For example,

    $ whalebuilder build --pull uhoreg/whalebuilder-base:sid foo_0.1-1.dsc

will build the source package described in foo_0.1-1.dsc, using the public
image `uhoreg/whalebuilder-base:sid` as the base image.  The `--pull` option
ensures that it pulls the latest version of the base image.  The resulting
packages and build information will be saved by default in
`~/.local/share/whalebuilder/foo_0.1-1`.

Note: the results will not be owned by your user, although you can still read
it.  However, to delete the results, you will need to use `sudo`.

Note: for all Whalebuilder commands, you must have `sudo` access to Docker.

After you have built a package in this way, there will be a Docker image named
`whalebuilder_build/<pkgname>:<pkgversion>` (with some escaping done to ensure
it's a valid Docker image name), e.g. `whalebuilder_build/foo:0.1-1`.  You can
use this to rebuild the package without needing to reinstall the build
dependencies.  For example,

    $ whalebuilder build --no-install-depends whalebuilder_build/foo:0.1-1 foo_0.1-1.dsc

If you do not wish to use a pre-built base image, you can create your own base
image by using "`whalebuilder create`".  For example,

    $ whalebuilder create whalebuilder_debian:stable

will create a Docker image named `whalebuilder_debian:stable` that will contain
a Debian stable build environment, based of Docker's debian image, and

    $ whalebuilder create -r unstable whalebuilder_debian:sid

will create a Docker image named `whalebuilder_debian:sid` that will contain a
Debian unstable build environment.

For more information, see `whalebuilder --help`.

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

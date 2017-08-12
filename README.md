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

After you have built a package in this way, there will be a Docker image named
`whalebuilder_build/<pkgname>:<pkgversion>` (with some escaping done to ensure
it's a valid Docker image name), e.g. `whalebuilder_build/foo:0.1-1`.  You can
use this to rebuild the package without needing to reinstall the build
dependencies.  For example,

    $ whalebuilder build --no-install-depends whalebuilder_build/foo:0.1-1 foo_0.1-1.dsc

If you do not wish to use a pre-built base image, you can create your own base
image by using "`whalebuilder create`".  For example,

    $ whalebuilder create whalebuilder_debian:sid

will create a Docker image named `whalebuilder_debian:sid` that will contain
a Debian sid build environment, based off Docker's debian image, and

    $ whalebuilder create -r testing whalebuilder_debian:testing

will create a Docker image named `whalebuilder_debian:testing` that will
contain a Debian testing build environment (e.g. for building a bugfix package
during a release freeze).

You may also create a base image using debootstrap instead of using Docker's
debian images by using the --debootstrap flag.

    $ whalebuilder create --debootstrap whalebuilder_debian_debootstrap:sid

Debootstrap-based images may be considered more trustworthy.  See, for example
https://joeyh.name/blog/entry/docker_run_debian/ for information about
differences between Docker's debian images and a normal Debian install.

After creating an base image, you may update it using the update command.

For more information, see `whalebuilder --help`.

Tips and Tricks
---------------
- if you maintain many packages that have a common set of dependencies, you can
  create a base image that contains those dependencies, so that they do not
  have to be re-installed for each package.  Create a directory with this
  `Dockerfile` (with the appropriate substitutions):

        FROM [your normal base image]
        
        RUN apt-get update && \
            apt-get install -y --no-install-recommends [dependencies...] && \
            apt-get clean

  and then run: `docker build -t [newimagename] .`, and use this image as your
  base image when building

- when creating a new package, sometimes you may be unsure of the package's
  exact build-dependencies.  You can start with a base guess, try building the
  package with whalebuilder, and if it fails, update the build-dependencies,
  and use the dependency image that whalebuilder created as your new base
  image.  In this way, it will not need to re-install the build-dependencies
  that it had already installed.

- if you need to install build-dependencies that are not (yet) in Debian, you
  can either use the `--deb` option to install individual `.deb` files, or you
  can use the `--hooks` feature to add sources to `/etc/apt/sources.list.d/`

Running in non-Debian environments
----------------------------------

In theory, since most of the work is done in Docker images, whalebuilder should
be runnable in non-Debian environments, though this has not been tested.

* If you cannot run debootstrap to build a base image, you may use a prebuilt one
  instead.
* Whalebuilder requires the [gpgme](http://github.com/ueno/ruby-gpgme) and
  [debian](https://anonscm.debian.org/git/pkg-ruby-extras/ruby-debian.git/)
  Ruby modules, which should both be usable in most environments.
* Whalebuilder calls `dpkg-architecture` to determine the build environment.
  Since `dpkg-architecture` won't be available on non-Debian environments, you
  can provide your own.  Either place it in the path, or edit whalebuilder to
  call it at the appropriate spot.  Alternatively, you can hard-code the values
  in whalebuilder.  Whalebuilder queries the following values:
  `DEB_HOST_ARCH_CPU` is the Debian CPU name of the host machine (e.g. for
  64-bit x86 machines, this value should be `amd64`), `DEB_HOST_ARCH_OS` is the
  Debian system name (this value should probably be `Linux` unless you are
  using a Docker image for a different system), and `DEB_HOST_ARCH` is the
  Debian architecture (e.g. for 64-bit x86 machines, this value should be
  `amd64`).

License
-------
Copyright (C) 2015-2017 Hubert Chathi <hubert@uhoreg.ca>

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

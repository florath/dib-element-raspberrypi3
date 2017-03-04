dib-element-raspberrypi3
########################

Element for diskimage-builder setting up Raspberry Pi 3 using arm64.

Features
++++++++

* Builds complete 64-bit arm64 system based on adaptable configuration
* Uses official up-to date Raspberry Pi kernel
* Uses official distribution arm64 - no need for special adapted
  versions like ``Raspberian``.


Tested
++++++

The following setups are known to be working

* Debian Stretch


Drawbacks
+++++++++

There are currently some GPIO libraries out there that relay on the
existance of some descriptions in the ``/proc/cpuinfo`` (like
``Hardware`` or ``Revision``).  This information is not (any longer)
available in the ``cpuinfo`` - and is now available in the device tree
``/proc/device-tree``.

Because the kernel and firmware related files (like ``start.elf`` or
``bootcode.bin``) are not part of the normal distribution, they will
not get updated automatically.


Setup
+++++

Before starting the build, there is the need to setup the build
environment.

diskimage-builder
-----------------
As the base that provides the infrastructure, the Openstack
diskimage-builder_ must is used.

.. _diskimage-builder: https://docs.openstack.org/developer/diskimage-builder/

Because some features are needed which are not merged, there is the
need to use the latest version and add some patches.  I'm currently
working on this and hopefully at some time the next steps are not
needed any longer.

::

   $ git clone https://git.openstack.org/openstack/diskimage-builder
   $ cd diskimage-builder
   $ git checkout -b feature/v2 origin/feature/v2

Then apply the following patches

* 426618_
* 414179_

.. _426618: https://review.openstack.org/#/c/426618/  

.. _414179: https://review.openstack.org/#/c/414179/

They can be e.g. cherry picked (see upper right corner of the page).


rpi3 module
-----------

The module itself needs some packages that must be installed. Look at
rpi3-readme_ for details.

.. _rpi3-readme: rpi/Readme.rst


Configuration
+++++++++++++

The configuration can be adapted in the ``create_rpi3.sh`` file.
You might want to change the Debian mirror to your needs.  If you
want, you can also change (or remove) the default user with username
``dib`` and password ``dib``.


Run
+++

::

   $ bash create_rpi3.sh

Install
+++++++

::

   $ dd if=rpi3-debian-minimal-stretch.raw of=/dev/your_mmc_device

Place the SD card into your RPi3 and have fun.


Post-Install
++++++++++++

Mostly no post-install procedures are needed. You might want to adapt
network configuration.  Also the installed system is minimal, i.e. if
you want to use the RPi3 with GUI, you have to install the appropriate
packages.


Controlling GPIO
++++++++++++++++

Not all GPIO libraries can be used (directly), because some use the fact,
that in some kernel versions there are special entries in the
/proc/cpuinfo.

The following methods are known to work


Using sysfs
-----------

All methods and libraries that are using the /sys/class/gpio interface
are working.


The bcm2835 library
-------------------

Using bcm2835_library_ works. Please note that this comes under GPL -
therefore also any source code that uses it must be delivered.  There
is a separate license for commercial projects.

.. _bcm2835_library: http://www.airspayce.com/mikem/bcm2835/


wiringPi
--------

The original wiringPi_ does not work, because it uses information from
the /proc/cpuinfo and bails out if if does not find those.
Nevertheless there is a fork available wiringPi64_ that is known to
work also with 64 bit systems.

.. _wiringPi: http://wiringpi.com/

.. _wiringPi64: https://github.com/florath/wireingPi64


Tutorial
++++++++

There is currently a small set of videos (in German) available on
Youtube_ that describes the setup of a Raspberry Pi 3 using this
diskimage-builder element.

.. _Youtube: https://www.youtube.com/playlist?list=PLB3AzDIYHSUk1CPf7k-DagLCVqSlbPq8l


It works
++++++++

.. image:: doc/images/RPi3-4Berries.png
           :alt: RPi3 boot screen
	   :width: 100%
	   :align: center

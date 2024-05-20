===============
immunity-config
===============

.. image:: https://github.com/edge-servers/immunity-config/workflows/Immunity%20Config%20CI%20Build/badge.svg?branch=master
    :target: https://github.com/edge-servers/immunity-config/actions?query=workflow%3A%22Immunity+Config+CI+Build%22
    :alt: ci build

.. image:: http://img.shields.io/github/release/immunity/immunity-config.svg
   :target: https://github.com/edge-servers/immunity-config/releases

.. image:: https://img.shields.io/gitter/room/nwjs/nw.js.svg?style=flat-square
   :target: https://gitter.im/immunity/general
   :alt: support chat

------------

`Immunity Controller <https://github.com/edge-servers/ansible-immunity2>`_
agent for `OpenWrt <https://openwrt.org/>`_.

**Want to help Immunity?** `Find out how to help us grow here
<http://immunity.io/docs/general/help-us.html>`_.

**Want a quick overview of Immunity?**
`Try the Immunity Demo <https://immunity.org/demo.html>`_.

.. image:: http://netjsonconfig.immunity.org/en/latest/_images/immunity.org.svg
  :target: http://immunity.org

.. contents:: **Table of Contents**:
 :backlinks: none
 :depth: 3

------------

Install precompiled package
---------------------------

First run:

.. code-block:: shell

    opkg update

Then install one of the `latest builds <https://downloads.immunity.io/?prefix=immunity-config/latest/>`_:

.. code-block:: shell

    opkg install <URL>

Where ``<URL>`` is the URL of the precompiled immunity-config package.

For a list of the latest built images, take a look at `downloads.immunity.io/?prefix=immunity-config/
<https://downloads.immunity.io/?prefix=immunity-config/>`_.

**If you need to compile the package yourself**, see `Compiling immunity-config`_
and `Compiling a custom OpenWRT image`_.

Once installed *immunity-config* needs to be configured (see `Configuration options`_)
and then started with::

    /etc/init.d/immunity_config start

To ensure the agent is working correctly find out how to perform debugging in
the `Debugging`_ section.

Configuration options
---------------------

UCI configuration options must go in ``/etc/config/immunity``.

- ``url``: url of controller, eg: ``https://controller.immunity.org``
- ``interval``: time in seconds between checks for changes to the configuration, defaults to ``120``
- ``management_interval``: time in seconds between the management ip discovery attempts, defaults to ``$interval/12``
- ``registration_interval``: time in seconds between the registration attempts, defaults to ``$interval/4``
- ``verify_ssl``: whether SSL verification must be performed or not, defaults to ``1``
- ``shared_secret``: shared secret, needed for `Automatic registration`_
- ``consistent_key``: whether `Consistent key generation`_ is enabled or not, defaults to ``1``
- ``merge_config``: whether `Merge configuration`_ is enabled or not, defaults to ``1``
- ``tags``: template tags to use during registration, multiple tags separated by space can be used,
  for more information see `Template Tags <https://immunity.io/docs/user/templates.html#template-tags>`_
- ``test_config``: whether a new configuration must be tested before being considered applied, defaults to ``1``
- ``test_retries``: maximum number of retries when doing the default configuration test, defaults to ``3``
- ``test_script``: custom test script, read more about this feature in `Configuration test`_
- ``uuid``: unique identifier of the router configuration in the controller application
- ``key``: key required to download the configuration
- ``hardware_id_script``: custom script to read out a hardware id (e.g. a serial number), read more about this feature in `Hardware ID`_
- ``hardware_id_key``: whether to use the hardware id for key generation or not, defaults to ``1``
- ``bootup_delay``: maximum value in seconds of a random delay after bootup, defaults to ``10``, see `Bootup Delay`_
- ``unmanaged``: list of config sections which won't be overwritten, see `Unmanaged Configurations`_
- ``capath``: value passed to curl ``--capath`` argument, by default is empty; see also `curl capath argument <https://curl.haxx.se/docs/manpage.html#--capath>`_
- ``cacert``: value passed to curl ``--cacert`` argument, by default is empty; see also `curl cacert argument <https://curl.haxx.se/docs/manpage.html#--cacert>`_
- ``connect_timeout``: value passed to curl ``--connect-timeout`` argument, defaults to ``15``; see `curl connect-timeout argument <https://curl.haxx.se/docs/manpage.html#--connect-timeout>`__
- ``max_time``: value passed to curl ``--max-time`` argument, defaults to ``30``; see `curl max-time argument <https://curl.haxx.se/docs/manpage.html#-m>`__
- ``mac_interface``: the interface from which the MAC address is taken when performing automatic registration, defaults to ``eth0``
- ``management_interface``: management interface name (both openwrt UCI names and
  linux interface names are supported), it's used to collect the management interface ip address
  and send this information to the Immunity server, for more information please read
  `how to make sure Immunity can reach your devices
  <https://immunity.io/docs/user/monitoring.html#immunity-reach-devices>`_
- ``default_hostname``: if your firmware has a custom default hostname, you can use this configuration
  option so the agent can recognize it during registration and replicate the standard behavior
  (new device will be named after its mac address, to avoid having many new devices with the same name),
  the possible options are to either set this to the value of the default hostname used by your firmware,
  or set it to ``*`` to always force to register new devices using their mac address as their name
  (this last option is useful if you have a firmware which can work on different hardware models
  and each model has a different default hostname)
- ``pre_reload_hook``: path to custom executable script, see `pre-reload-hook`_
- ``post_reload_hook``: path to custom executable script, see `post-reload-hook`_
- ``post_reload_delay``: delay in seconds to wait before the post-reload-hook and any configuration test, defaults to ``5``
- ``post_registration_hook``: path to custom executable script, see `post-registration-hook`_
- ``respawn_threshold``: time in seconds used as procd respawn threshold, defaults to ``3600``
- ``respawn_timeout``: time in seconds used as procd respawn timeout, defaults to ``5``
- ``respawn_retry``: number of procd respawn retries (use ``0`` for infinity), defaults to ``5``
- ``checksum_max_retries``: maximum number of retries for checksum requests which fail with 404, defaults to ``5``,
  after these failures the agent will assume the device has been deleted from Immunity Controller and will exit;
  please keep in mind that due to ``respawn_retry``, procd will try to respawn the agent after it exits, so the
  total number of attempts which will be tried has to be calculated as:
  ``checksum_max_retries * respawn_retry``
- ``checksum_retry_delay``: time in seconds between retries, defaults to ``6``

Automatic registration
----------------------

When the agent starts, if both ``uuid`` and ``key`` are not defined, it will consider
the router to be unregistered and it will attempt to perform an automatic registration.

The automatic registration is performed only if ``shared_secret`` is correctly set.

The device will choose as name one of its mac addresses, unless its hostname is not ``OpenWrt``,
in the latter case it will simply register itself with the current hostname.

When the registration is completed, the agent will automatically set ``uuid`` and ``key``
in ``/etc/config/immunity``.

To enable this feature by default on your firmware images, follow the procedure described in
`Compiling a custom OpenWRT image`_.

Consistent key generation
-------------------------

When using `Automatic registration`_, this feature allows devices to keep the same configuration
even if reset or reflashed.

The ``key`` is generated consistently with an operation like ``md5sum(mac_address + shared_secret)``;
this allows the controller application to recognize that an existing device is registering itself again.

The ``mac_interface`` configuration key specifies which interface is used to calculate the mac address,
this setting defaults to ``eth0``. If no ``eth0`` interface exists, the first non-loopback, non-bridge and non-tap
interface is used. You won't need to change this setting often, but if you do, ensure you choose a physical
interface which has constant mac address.

The "Consistent key generation" feature is enabled by default, but must be enabled also in the
controller application in order to work.

Merge configuration
-------------------

By default the remote configuration is merged with the local one. This has several advantages:

* less boilerplate configuration stored in the remote controller
* local users can change local configurations without fear of losing their changes

It is possible to turn this feature off by setting ``merge_config`` to ``0`` in ``/etc/config/immunity``.

**Details about the merging behavior**:

* if a configuration option or list is present both in the remote configuration
  and in the local configuration, the remote configurations will overwrite the local ones
* configuration options that are present in the local configuration but are not present
  in the remote configuration will be retained
* configuration files that were present in the local configuration and are replaced
  by the remote configuration are backed up and eventually restored if the modifications
  are removed from the controller

Configuration test
------------------

When a new configuration is downloaded, the agent will first backup the current running
configuration, then it will try to apply the new one and perform a basic test, which consists
in trying to contact the controller again;

If the test succeeds, the configuration is considered applied and the backup is deleted.

If the test fails, the backup is restored and the agent will log the failure via syslog
(see `Debugging`_ for more information on auditing logs).

Disable testing
^^^^^^^^^^^^^^^

To disable this feature, set the ``test_config`` option to ``0``, then reload/restart *immunity_config*.

Define custom tests
^^^^^^^^^^^^^^^^^^^

If the default test does not satisfy your needs, you can define your own tests in an
**executable** script and indicate the path to this script in the ``test_script`` config option.

If the exit code of the executable script is higher than ``0`` the test will be considered failed.

Hardware ID
-----------

It is possible to use a unique hardware id for device identification, for example a serial number.

If ``hardware_id_script`` contains the path to an executable script, it will be used to read out the hardware
id from the device. The hardware id will then be sent to the controller when the device is registered.

If the above configuration option is set then the hardware id will also be used for generating the device key,
instead of the mac address. If you use a hardware id script but prefer to use the mac address for key
generation then set ``hardware_id_key`` to ``0``.

See also the `related hardware ID settings in Immunity Controller
<https://github.com/edge-servers/immunity-controller/#immunity-controller-hardware-id-enabled>`_.

Bootup Delay
------------

The option ``bootup_delay`` is used to delay the initialization of the agent
for a random amount of seconds after the device boots.

The value specified in this option represents the maximum value of the range
of possible random values, the minimum value being ``0``.

The default value of this option is 10, meaning that the initialization of
the agent will be delayed for a random number of seconds, this random number
being comprised between ``0`` and ``10``.

This feature is used to spread the load on the Immunity server when a
large amount of devices boot up at the same time after a blackout.

Large Immunity installations may want to increase this value.

Unmanaged Configurations
------------------------

In some cases it could be necessary to ensure that some configuration sections won't be
overwritten by the controller.

These settings are called "unmanaged", in the sense that they are not managed remotely.
In the default configuration of *immunity_config* there are no unmanaged settings.

Example unmanaged settings::

    config controller 'http'
            ...
            list unmanaged 'system.@led'
            list unmanaged 'network.loopback'
            list unmanaged 'network.@switch'
            list unmanaged 'network.@switch_vlan'
            ...

Note the lines with the `@` sign; this syntax means any UCI section of the specified type will be unmanaged.

In the previous example, the loopback interface, all ``led settings``, all ``switch`` and ``switch_vlan``
directives will never be overwritten by the remote configuration and will only be editable via SSH
or via the web interface.

Hooks
-----

Below are described the available hooks in *immunity-config*.

pre-reload-hook
^^^^^^^^^^^^^^^

Defaults to ``/etc/immunity/pre-reload-hook``; the hook is not called if the
path does not point to an executable script file.

This hook is called each time *immunity-config* applies a configuration, but **before services are reloaded**,
more precisely in these situations:

* after a new remote configuration is downloaded and applied
* after a configuration test failed (see `Configuration test`_) and a previous backup is restored

You can use this hook to perform custom actions before services are reloaded, eg: to perform
auto-configuration with `LibreMesh <http://libre-mesh.org/>`_.

Example configuration::

    config controller 'http'
            ...
            option pre_reload_hook '/usr/sbin/my-pre-reload-hook'
            ...

Complete example:

.. code-block:: shell

    # set hook in configuration
    uci set immunity.http.pre_reload_hook='/usr/sbin/my-pre-reload-hook'
    uci commit immunity
    # create hook script
    cat <<EOF > /usr/sbin/my-pre-reload-hook
    #!/bin/sh
    # put your custom operations here
    EOF
    # make script executable
    chmod +x /usr/sbin/my-pre-reload-hook
    # reload immunity_config by using procd's convenient utility
    reload_config

post-reload-hook
^^^^^^^^^^^^^^^^

Defaults to ``/etc/immunity/post-reload-hook``; the hook is not called if the
path does not point to an executable script file.

Same as `pre_reload_hook` but with the difference that this hook is called
after the configuration services have been reloaded.

post-registration-hook
^^^^^^^^^^^^^^^^^^^^^^

Defaults to ``/etc/immunity/post-registration-hook``;

Path to an executable script that will be called after the registration is completed.

Hotplug Events
--------------

The agent sends the following
`Hotplug events <https://openwrt.org/docs/guide-user/base-system/hotplug>`_:

- After the registration is successfully completed: ``post-registration``
- After the registration failed: ``registration-failed``
- When the agent first starts after the bootup of the device: ``bootup``
- After any subsequent restart: ``restart``
- After the configuration has been successfully applied: ``config-applied``
- After the previous configuration has been restored: ``config-restored``
- Before services are reloaded: ``pre-reload``
- After services have been reloaded: ``post-reload``
- After the agent has finished its check cycle, before going to sleep: ``end-of-cycle``

If a hotplug event is sent by *immunity-config* then all scripts existing in
``/etc/hotplug.d/immunity/`` will be executed. In scripts the type of event
is visible in the variable ``$ACTION``. For example, a script to log the hotplug
events, ``/etc/hotplug.d/immunity/01_log_events``, could look like this:

.. code-block:: shell

    #!/bin/sh

    logger "immunity-config sent a hotplug event. Action: $ACTION"

It will create log entries like this::

    Wed Jun 22 06:15:17 2022 user.notice root: immunity-config sent a hotplug event. Action: registration-failed

For more information on using these events refer to the
`Hotplug Events OpenWrt Documentation <https://openwrt.org/docs/guide-user/base-system/hotplug>`_.

Compiling immunity-config
-------------------------

The following procedure illustrates how to compile *immunity-config* and its dependencies:

.. code-block:: shell

    git clone https://github.com/openwrt/openwrt.git openwrt
    cd openwrt
    git checkout <openwrt-branch>

    # configure feeds
    echo "src-git immunity https://github.com/edge-servers/immunity-config.git" > feeds.conf
    cat feeds.conf.default >> feeds.conf
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    # any arch/target is fine because the package is architecture indipendent
    arch="ar71xx"
    echo "CONFIG_TARGET_$arch=y" > .config;
    echo "CONFIG_PACKAGE_immunity-config=y" >> .config
    make defconfig
    make tools/install
    make toolchain/install
    make package/immunity-config/compile

Alternatively, you can configure your build interactively with ``make menuconfig``, in this case
you will need to select *immunity-config* by going to ``Administration > immunity``:

.. code-block:: shell

    git clone https://github.com/openwrt/openwrt.git openwrt
    cd openwrt
    git checkout <openwrt-branch>

    # configure feeds
    echo "src-git immunity https://github.com/edge-servers/immunity-config.git" > feeds.conf
    cat feeds.conf.default >> feeds.conf
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    make menuconfig
    # go to Administration > immunity and select the variant you need interactively
    make -j1 V=s

Compiling a custom OpenWRT image
--------------------------------

If you are managing many devices and customizing your ``immunity-config`` configuration by hand on
each new device, you should switch to using a custom OpenWRT firmware image that includes
``immunity-config`` and its precompiled configuration file, this strategy has a few important benefits:

* you can save yourself the effort of installing and configuring ``immunity-config`` on each device
* you can enable `Automatic registration`_ by setting ``shared_secret``,
  hence saving extra time and effort to register each device on the controller app
* if you happen to reset the firmware to initial settings, these precompiled settings will be restored as well

The following procedure illustrates how to compile a custom `OpenWRT <https://openwrt.org/>`_
image with a precompiled minimal ``/etc/config/immunity`` configuration file:

.. code-block:: shell

    git clone https://github.com/openwrt/openwrt.git openwrt
    cd openwrt
    git checkout <openwrt-branch>

    # include precompiled file
    mkdir -p files/etc/config
    cat <<EOF > files/etc/config/immunity
    config controller 'http'
        # change the values of the following 2 options
        option url 'https://immunity2.mydomain.com'
        option shared_secret 'mysharedsecret'
    EOF

    # configure feeds
    echo "src-git immunity https://github.com/edge-servers/immunity-config.git" > feeds.conf
    cat feeds.conf.default >> feeds.conf
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    # replace with your desired arch target
    arch="ar71xx"
    echo "CONFIG_TARGET_$arch=y" > .config
    echo "CONFIG_PACKAGE_immunity-config=y" >> .config
    make defconfig
    # compile with verbose output
    make -j1 V=s

Automate compilation for different organizations
------------------------------------------------

If you are working with Immunity, there are chances you may be compiling several images for different
organizations (clients or non-profit communities) and use cases (full featured, mesh, 4G, etc).

Doing this by hand without tracking your changes can lead you into a very disorganized and messy situation.

To alleviate this pain you can use `ansible-immunity2-imagegenerator
<https://github.com/edge-servers/ansible-immunity2-imagegenerator>`_.

Debugging
---------

Debugging *immunity-config* can be easily done by using the ``logread`` command:

.. code-block:: shell

    logread

Use grep to filter out any other log message:

.. code-block:: shell

    logread | grep immunity

If you are in doubt immunity-config is running at all, you can check with::

    ps | grep immunity

You should see something like::

    3800 root      1200 S    {immunity_config} /bin/sh /usr/sbin/immunity_config --url https://immunity2.mydomain.com --verify-ssl 1 --consistent-key 1 ...

You can inspect the version of immunity-config currently installed with::

    immunity_config --version

Quality Assurance Checks
------------------------

We use `LuaFormatter <https://luarocks.org/modules/tammela/luaformatter>`_ and
`shfmt <https://github.com/mvdan/sh#shfmt>`_ to format lua files and shell scripts respectively.

First of all, you will need install the lua packages mentioned above, then you can format all files with::

    ./qa-format

To run quality assurance checks you can use the ``run-qa-checks`` script::

    # install immunity-utils QA tools first
    pip install immunity-utils[qa]

    # run QA checks before committing code
    ./run-qa-checks

Run tests
---------

To run the unit tests, you must install the required dependencies first; to do this, you can take
a look at the `install-dev.sh <https://github.com/edge-servers/immunity-config/blob/master/install-dev.sh>`_
script.

You can run all the unit tests by launching the dedicated script::

    ./runtests

Alternatively, you can run specifc tests, eg::

    cd immunity-config/tests/
    lua test_utils.lua -v

Contributing
------------

Please read the `Immunity contributing guidelines
<http://immunity.io/docs/developer/contributing.html>`_.

Changelog
---------

See `CHANGELOG <https://github.com/edge-servers/immunity-config/blob/master/CHANGELOG.rst>`_.

License
-------

See `LICENSE <https://github.com/edge-servers/immunity-config/blob/master/LICENSE>`_.

Support
-------

See `Immunity Support Channels <http://immunity.org/support.html>`_.

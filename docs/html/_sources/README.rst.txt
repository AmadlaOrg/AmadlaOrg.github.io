Docs \| Amadla IaC CE
=============================

Menu
--------------------

-  `Setup <./setup.md>`__ - About the commands for making the server
   image and generate infrastructure.
-  `Secrets <./secrets.md>`__ - About managing secrets with Vault tool.
-  `CI/CD <./ci-cd.md>`__ - About CI/CD (`GitHub
   Workflow <https://docs.github.com/en/actions/using-workflows>`__,
   `Jenkins <https://www.jenkins.io/>`__).
-  `How It Works <./how-it-works.md>`__ - An explanation on how all the
   pieces come together.
-  `Dev <./dev.md>`__ - For those courageous enough to dev for this
   project.

..

   IMPORTANT! Note that they are multiple ways to run Amadla with:
   `Jenkins <../Jenkinsfile>`__, `GitHub
   Workflow <../.github/workflows/generate.yml>`__,
   `containers <../containers/Makefile>`__, or all the `tools installed
   on the system itself <../Makefile>`__.

Help
---------------------------

To get a list of make command:

.. code:: bash

   make help

Environment Variables
---------------------

-  **AMADLA_ROOT_PATH** - The Amadla cli application root directory
   path.
-  **AMADLA_USE_GIT_MODULES** - To determine if Git is used for the
   storage and management of modules.
-  **AMADLA_MODULES_REPO_ROOT_PATH** - The path to the directory where
   the modules are stored (in that directory the file ``.gitmodules``
   will be added if it does not exist).
-  **AMADLA_MODULES_PATH** - Modules path that contains ``apps.d``,
   ``servers.d`` and ``clouds.d``.
-  **AMADLA_APPS_PATH** - Path to the ``apps.d/`` directory.
-  **AMADLA_CLOUDS_PATH** - Path to the ``clouds.d/`` directory.
-  **AMADLA_SERVERS_PATH** - Path to the ``servers.d/`` directory.
-  **AMADLA_CONFIG_PATH** - Path to the ``config/`` directory.
-  **AMADLA_CONTAINERS_PATH** - Path to the ``containers/`` directory.
-  **AMADLA_CONTAINER_ENGINE** - The container engine (e.g.: ``docker``
   or ``podman``) by default it will use *Podman*.
-  **AMADLA_CONTAINER** - Determine if Amadla runs its tools with
   containers or not (values: true or false).
-  **AMADLA_LOCK_FILE_PATH** - The path to the Amadla lock file.
-  **AMADLA_LOGGING_FILE_PATH** - By default it is stored in the root of
   the project under the name ``amadla.log``.
-  **AMADLA_LOGGING_LEVEL** - The logging level (CRITICAL, FATAL, ERROR,
   WARNING, WARN, INFO, DEBUG, NOTSET).

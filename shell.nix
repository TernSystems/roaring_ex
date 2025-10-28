with import <nixpkgs> {};
let
  my-python-packages = python-packages: with python-packages; [
    pip
    setuptools
  ];

  localDomains = stdenv.lib.strings.concatStringsSep " " [
    "generic-dev.test"
  ];

  pwd = builtins.getEnv "PWD";
  host = "127.0.0.1";

  python-with-my-packages = pkgs.python3.withPackages my-python-packages;
  elixir = beam.packages.erlang_27.elixir_1_18;

  # define packages to install with special handling for OSX
  basePackages = [
    gnumake
    gcc
    readline
    openssl
    zlib
    libxml2
    curl
    libiconv
    elixir
    glibcLocales
    cargo
    rustc
  ];

  inputs = basePackages
    ++ lib.optional stdenv.isLinux inotify-tools
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
            CoreFoundation
            CoreServices
    ]);

  # define shell startup command
  hooks = ''
    export PS1='\[\033[1;32m\][nix-shell:\w]($(git rev-parse --abbrev-ref HEAD))\$\[\033[0m\] '
    # this allows python to work locally
    alias pip="PIP_PREFIX='$(pwd)/_build/pip_packages' \pip"
    export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.7/site-packages:$PYTHONPATH"
    unset SOURCE_DATE_EPOCH
    # this allows mix to work on the local directory
    mkdir -p .nix-mix
    mkdir -p .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
    export LANG=en_US.UTF-8
    export PATH=$PATH:$(pwd)/_build/pip_packages/bin
    export ERL_AFLAGS="-kernel shell_history enabled"
  '';

in pkgs.stdenv.mkDerivation {
  name = "hisparsebitset-shell";
  buildInputs = inputs;
  shellHook = hooks;


  HOST = host;
  NIX_PROJECT = builtins.baseNameOf pwd;
}

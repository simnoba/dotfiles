{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../modules/emacs.nix
    ../modules/general/default.nix
    ../modules/nix.nix
    ../modules/packages.nix
    ../modules/programs/default.nix
  ];

  local.nix.settings = {
    extra-trusted-public-keys = [
      "unison.cachix.org-1:i1DUFkisRPVOyLp/vblDsbsObmyCviq/zs6eRuzth3k="
    ];

    extra-trusted-substituters = [
      "https://unison.cachix.org"
    ];
  };

  nix.settings.trusted-users = ["nvj"];

  # Don't run as a daemon
  services.emacs.enable = false;

  environment = {
    variables.EDITOR = "vim";

    systemPackages = with pkgs; [
      cameracontroller
      colima
      cplt
      config.services.emacs.package
      coreutils-full
      docker
      docker-credential-helpers
      fluxcd
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      helm-chart-releaser
      k9s
      kubectl
      kubectx
      kubernetes-helm
      kubeseal
      # naisdevice-tenant TODO: get this nix package working
      orion-browser
      parinfer-rust-emacs # emacs dep
      proton-pass
      rectangle
      signal-desktop
      spotify
      trivy
      unison-ucm
      vesktop
      vim-with-conf
    ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = {
    enable = true;
    taps = [
      "helm/tap"
      {
        name = "nais/tap";
        trusted = true;
      }
    ];
    brews = [
      "mole"
      "nais" # nais cli
      # naisdevice-tenant dependency
      "wireguard-tools"
    ];
    casks = [
      "naisdevice-tenant"
    ];

    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
  };

  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
  ];

  system.defaults.dock.persistent-apps = [
    "/Applications/Nix Apps/Firefox.app"
    "/Applications/Nix Apps/Spotify.app"
    "/System/Applications/Messages.app"
    "/System/Applications/Calendar.app"
    "/Applications/Microsoft Outlook.app"
    "/Applications/Microsoft Teams.app"
    "/Applications/Nix Apps/Slack.app"
    "/Applications/Nix Apps/Vesktop.app"
    "/Applications/Nix Apps/KeePassXC.app"
    "/Applications/Nix Apps/Proton Pass.app"
    "/System/Applications/System Settings.app"
    "/Applications/Nix Apps/Ghostty.app"
    "/Applications/Nix Apps/Emacs.app"
    "/Users/nvj/Applications/IntelliJ IDEA.app"
    "/Users/nvj/Applications/Datagrip.app"
    "/System/Applications/Notes.app"
    "/System/Applications/Reminders.app"
  ];

  ids.gids.nixbld = 350;
  system.stateVersion = 6;
  system.primaryUser = "nvj";
}

# NB: this is a light version, used on shared computers
# The real one is at https://github.com/nim65s/dotfiles/tree/main/home/nim
{
  lib,
  pkgs,
  ...
}:
{
  home = {
    keyboard = {
      layout = "fr";
      variant = "ergol";
    };

    packages = with pkgs; [
      comma
      deadnix
      jq
      ninja
      prek
      sccache
    ];

    sessionVariables = {
      CMAKE_BUILD_TYPE = "RelWithDebInfo";
      CMAKE_C_COMPILER_LAUNCHER = "sccache";
      CMAKE_CXX_COMPILER_LAUNCHER = "sccache";
      CMAKE_COLOR_DIAGNOSTICS = "ON";
      CMAKE_EXPORT_COMPILE_COMMANDS = "ON";
      CMAKE_GENERATOR = "Ninja";
      CMEEL_LOG_LEVEL = "DEBUG";
      CTEST_OUTPUT_ON_FAILURE = "ON";
      CTEST_PROGRESS_OUTPUT = "ON";
      DELTA_PAGER = "less -FR";
      POETRY_VIRTUALENVS_IN_PROJECT = "true";
      RUSTC_WRAPPER = lib.getExe pkgs.sccache;
    };
  };

  programs = {
    bat = {
      config = {
        style = "plain";
      };
      extraPackages = with pkgs.bat-extras; [
        batman
      ];
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        hyperlinks = true;
      };
    };

    eza = {
      enable = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--classify"
        "--color-scale=all"
        # "--git-ignore"
        "--group"
        "--header"
        "--hyperlink"
        "--ignore-glob=.git|*.orig|*~"
      ];
    };

    fd.extraOptions = [
      "--hyperlink"
    ];

    fish = {
      enable = true;
      shellAbbrs = {
        "-" = "cd -";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";
        bn = "cmake -B build";
        bnb = "cmake -B build && cmake --build build";
        bb = "cmake --build build";
        bt = "cmake --build build -t test";
        bi = "cmake --build build -t install";
        da = "direnv allow";
        db = "direnv block";
        gc = {
          expansion = "git commit -am '%'";
          setCursor = true;
        };
        gd = "git difftool";
        gst = "git status";
        gp = "git push";
        gf = "git fetch --all --prune";
        gcaf = "git commit -a --fixup";
        gcan = "git commit -a --amend --no-edit";
        gch = "git checkout";
        v = "hx";
      };

      shellAliases = {
        "+" = "echo";
        cp = "cp -r";
        mv = "mv -v";
        rm = "rm -Iv";
        watch = "watch --color -d";
      };
      preferAbbrs = true;
    };

    git.settings = {
      branch = {
        autoSetupRebase = "always";
        sort = "-committerdate";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = true;
        colorMovedWS = "allow-indentation-change";
        renames = "true";
      };
      help.autocorrect = 1;
      rerere = {
        autoupdate = true;
        enabled = true;
      };
      user =
        let
          me = [
            "Guilhem"
            "Saurel"
          ];
        in
        {
          name = lib.concatStringsSep " " me;
          email = "${lib.concatStringsSep "." me}@laas.fr";
        };
    };

    helix = {
      enable = true;
      defaultEditor = true;
    };

    hwatch.enable = true;

    kitty = {
      enable = true;

      keybindings = {
        "kitty_mod+a" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
        "kitty_mod+k" = "launch --location=vsplit --cwd=current";
        "kitty_mod+." = "launch --location=hsplit --cwd=current";
        "kitty_mod+r" = "previous_window";
        "kitty_mod+t" = "next_window";
        "kitty_mod+," = "new_tab_with_cwd";
        "kitty_mod+h" = "previous_tab";
        "kitty_mod+g" = "next_tab";
        # "kitty_mod+p" = "show_scrollback";
        "kitty_mod+p" = "kitty_scrollback_nvim";
      };

      settings = {
        cursor_trail = "1";
        enable_audio_bell = false;
        enabled_layouts = "splits,fat,tall,grid,horizontal,vertical,stack";
        focus_follows_mouse = true;
        scrollback_pager_history_size = 2;
        shell = lib.getExe pkgs.fish;
        tab_bar_style = "powerline";
      };
      shellIntegration.mode = "enabled";
    };

    ripgrep.arguments = [
      "--hyperlink-format=kitty"
    ];

    ssh.settings = {
      upe.hostname = "upepesanke";
      miya.hostname = "miyanoura";
      root = {
        user = "root";
        hostname = "localhost";
      };
      "*.l" = {
        hostname = "%haas.fr";
        user = "gsaurel";
      };
      "*.L" = {
        hostname = "%haas.fr";
        user = "root";
      };
    };

    starship = {
      enable = true;
      presets = [
        "nerd-font-symbols"
      ];
      settings = {
        format = "┬─ $all$time$line_break╰─ $jobs$battery$status$container$os$shell$character";
        time.disabled = false;
        status.disabled = false;
        package.disabled = true;
        os.disabled = false;
      };
    };

    yazi = {
      enable = true;
      initLua = ''
        require("git"):setup()
        require("starship"):setup()
      '';
      keymap = {
        mgr.prepend_keymap = [
          {
            on = [ "+" ];
            run = "arrow next";
          }
          {
            on = [ "-" ];
            run = "arrow prev";
          }
          {
            on = [ "l" ];
            run = "plugin enter";
          }
        ];
      };
      plugins = {
        inherit (pkgs.yaziPlugins) git starship;
      };
      settings = {
        plugin.prepend_fetchers = [
          {
            id = "git";
            url = "*";
            run = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
          }
        ];
      };
      shellWrapperName = "y";
    };

    zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };
}

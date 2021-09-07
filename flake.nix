{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?rev=860b56be91fb874d48e23a950815969a7b832fbc";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.plfa.url = "github:plfa/plfa.github.io";
  inputs.plfa.flake = false;

  outputs = { self, nixpkgs, flake-utils, plfa }:
    flake-utils.lib.eachDefaultSystem
    (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      agda = pkgs.agda.withPackages (p: [
        p.standard-library
        (p.mkDerivation {
          pname = "plfa";
          meta = null;
          version = "1.0.0";
          buildInputs = [ p.standard-library ];
          preBuild = ''
            echo "module Everything where" > Everything.agda
			find src -name '*.lagda.md' | sed -e 's/src\///' -e 's/\.lagda\.md//' -e 's/\//\./g' -e 's/^/import /' | grep -Ev '^import plfa\.part1\.Equality|Naturals$' >> Everything.agda
            export LANG=C.UTF-8
          '';
          src = plfa;
        })
      ]);
      emacsWithPackages = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages
      (epkgs: (with epkgs.melpaPackages; [
        gruvbox-theme
        agda2-mode
        evil
      ]) ++ (with epkgs.elpaPackages; [
        undo-tree
      ]));
    in {
      devShell =
        pkgs.mkShell {
          buildInputs = [
            emacsWithPackages
            agda
          ];
          shellHook = ''
            XDG_CONFIG_HOME=$(pwd) emacs
          '';
        };
      });
    }


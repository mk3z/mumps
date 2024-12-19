{
  description = "MUMPS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    mumps-src = {
      url = "tarball+https://mumps-solver.org/MUMPS_5.7.3.tar.gz";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    mumps-src,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "mumps";

          src = ./.;

          nativeBuildInputs = with pkgs; [
            cmake
            gfortran
          ];

          buildInputs = with pkgs; [
            liblapack
            mpi
            scalapack
          ];

          patches = ["patch.diff"];

          preConfigure = ''
            mkdir -p mumps
            cp -r ${mumps-src}/* mumps
            chmod -R u+w mumps
          '';

          cmakeFlags = [
            "-DBUILD_SHARED_LIBS=on"
          ];
        };
      }
    );
}
